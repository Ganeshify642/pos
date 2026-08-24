import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterDevice {
  final String name;
  final String macAddress;
  final int? rssi;

  const PrinterDevice({
    required this.name,
    required this.macAddress,
    this.rssi,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterDevice &&
          runtimeType == other.runtimeType &&
          macAddress.toLowerCase() == other.macAddress.toLowerCase();

  @override
  int get hashCode => macAddress.toLowerCase().hashCode;
}

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  /// Check if Bluetooth is turned ON
  Future<bool> isBluetoothEnabled() async {
    try {
      if (kIsWeb) return false;
      return await PrintBluetoothThermal.bluetoothEnabled;
    } catch (_) {
      return false;
    }
  }

  /// Request Bluetooth and Location permissions
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      final scanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? false;
      final connectGranted =
          statuses[Permission.bluetoothConnect]?.isGranted ?? false;
      final locationGranted =
          statuses[Permission.locationWhenInUse]?.isGranted ?? false;

      return (scanGranted && connectGranted) || locationGranted;
    }

    if (Platform.isIOS) {
      final status = await Permission.bluetooth.request();
      return status.isGranted;
    }

    return true;
  }

  /// Turn on Bluetooth on Android
  Future<void> turnOnBluetooth() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      debugPrint('Error turning on Bluetooth: $e');
    }
  }

  /// Filter to keep printers and exclude obvious consumer non-printer devices
  bool isLikelyPrinter(String name) {
    if (name.isEmpty) return true;
    final n = name.toLowerCase();

    // Reject non-printer consumer hardware
    const nonPrinters = [
      'smart tv', 'tv', 'watch', 'fitbit', 'band', 'earphone', 'headphone',
      'buds', 'airpod', 'speaker', 'soundbar', 'audio', 'galaxy watch',
      'laptop', 'desktop', 'macbook', 'ipad', 'tablet'
    ];
    for (final kw in nonPrinters) {
      if (n == kw || n.contains(' $kw') || n.contains('$kw ') || n.startsWith(kw)) {
        return false;
      }
    }
    return true;
  }

  /// Check if name strongly indicates a printer
  bool isPrinterName(String name) {
    final n = name.toLowerCase();
    const printerKeywords = [
      'printer', 'pos', 'thermal', 'mpt', 'rp', '58', '80', 'pt-',
      'rpp', 'bt-', 'zj-', 'esc', 'mtp', 'gprinter', 'xprinter', 'imin', 'sunmi'
    ];
    for (final kw in printerKeywords) {
      if (n.contains(kw)) return true;
    }
    return false;
  }

  /// Get paired devices from system settings
  Future<List<PrinterDevice>> getPairedDevices() async {
    try {
      final List<BluetoothInfo> list =
          await PrintBluetoothThermal.pairedBluetooths;
      return list
          .where((b) => isLikelyPrinter(b.name))
          .map((b) => PrinterDevice(
                name: b.name.isNotEmpty ? b.name : 'Thermal Printer',
                macAddress: b.macAdress,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error fetching paired devices: $e');
      return [];
    }
  }

  /// Scan for nearby Bluetooth printers
  Future<List<PrinterDevice>> scanNearbyDevices({Duration timeout = const Duration(seconds: 6)}) async {
    final List<PrinterDevice> discovered = [];

    try {
      // Fetch devices
      final paired = await getPairedDevices();
      discovered.addAll(paired);

      // Start BLE / Nearby Bluetooth scan
      if (await FlutterBluePlus.isSupported) {
        await FlutterBluePlus.startScan(timeout: timeout);

        await for (final results in FlutterBluePlus.scanResults) {
          for (final r in results) {
            final name = r.device.platformName.isNotEmpty
                ? r.device.platformName
                : (r.advertisementData.advName.isNotEmpty
                    ? r.advertisementData.advName
                    : '');

            final mac = r.device.remoteId.str;
            if (mac.isNotEmpty && isLikelyPrinter(name)) {
              final device = PrinterDevice(
                name: name.isNotEmpty ? name : 'Thermal Printer ($mac)',
                macAddress: mac,
                rssi: r.rssi,
              );

              final existingIdx = discovered.indexWhere(
                  (d) => d.macAddress.toLowerCase() == mac.toLowerCase());
              if (existingIdx >= 0) {
                discovered[existingIdx] = device;
              } else {
                discovered.add(device);
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error scanning nearby devices: $e');
    }

    // Sort printers first
    discovered.sort((a, b) {
      final aIsPr = isPrinterName(a.name) ? 1 : 0;
      final bIsPr = isPrinterName(b.name) ? 1 : 0;
      if (aIsPr != bIsPr) return bIsPr.compareTo(aIsPr);
      return a.name.compareTo(b.name);
    });

    return discovered;
  }

  /// Connect to Bluetooth printer using MAC Address
  Future<bool> connect(String macAddress) async {
    try {
      try {
        await PrintBluetoothThermal.disconnect;
      } catch (_) {}

      final bool success = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );

      return success;
    } catch (e) {
      debugPrint('Connection exception: $e');
      return false;
    }
  }

  /// Check active connection status
  Future<bool> isConnected() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (_) {
      return false;
    }
  }

  /// Disconnect printer
  Future<bool> disconnect() async {
    try {
      return await PrintBluetoothThermal.disconnect;
    } catch (_) {
      return false;
    }
  }

  /// Send ESC/POS byte commands directly to the printer socket
  Future<bool> printBytes(List<int> bytes) async {
    try {
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      debugPrint('Print error: $e');
      return false;
    }
  }
}
