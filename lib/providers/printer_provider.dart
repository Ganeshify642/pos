import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/db_types.dart';
import '../services/printer_service.dart';
import '../services/thermal_receipt_builder.dart';

class PrinterProvider extends ChangeNotifier {
  final PrinterService _printerService = PrinterService();

  List<PrinterDevice> _devices = [];
  PrinterDevice? _connectedPrinter;
  bool _isConnected = false;
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isPrinting = false;
  bool _isBluetoothEnabled = true;
  String? _statusMessage;
  String? _errorMessage;

  // Settings
  String _paperSize = '58mm';
  bool _autoPrintOnOrder = false;
  String? _savedPrinterMac;
  String? _savedPrinterName;

  StreamSubscription<BluetoothAdapterState>? _btStateSub;

  PrinterProvider() {
    _init();
  }

  // Getters
  List<PrinterDevice> get devices => _devices;
  PrinterDevice? get connectedPrinter => _connectedPrinter;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isPrinting => _isPrinting;
  bool get isBluetoothEnabled => _isBluetoothEnabled;
  String? get statusMessage => _statusMessage;
  String? get errorMessage => _errorMessage;
  String get paperSize => _paperSize;
  bool get is80mm => _paperSize == '80mm';
  bool get autoPrintOnOrder => _autoPrintOnOrder;
  String? get savedPrinterName => _savedPrinterName;
  String? get savedPrinterMac => _savedPrinterMac;

  Future<void> _init() async {
    await _loadPrefs();
    await checkBluetoothState();

    // Listen to adapter changes
    _btStateSub = FlutterBluePlus.adapterState.listen((state) {
      final enabled = state == BluetoothAdapterState.on;
      if (_isBluetoothEnabled != enabled) {
        _isBluetoothEnabled = enabled;
        if (!enabled) {
          _isConnected = false;
          _statusMessage = 'Bluetooth is turned off';
        } else {
          _statusMessage = null;
          refreshPairedDevices();
        }
        notifyListeners();
      }
    });

    await refreshPairedDevices();

    if (_savedPrinterMac != null && _isBluetoothEnabled) {
      _autoReconnect();
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _paperSize = prefs.getString('printer_paper_size') ?? '58mm';
    _autoPrintOnOrder = prefs.getBool('printer_auto_print') ?? false;
    _savedPrinterMac = prefs.getString('printer_saved_mac');
    _savedPrinterName = prefs.getString('printer_saved_name');
    notifyListeners();
  }

  Future<void> _autoReconnect() async {
    if (_savedPrinterMac == null) return;
    try {
      final alreadyConnected = await _printerService.isConnected();
      if (alreadyConnected) {
        _isConnected = true;
        _connectedPrinter = PrinterDevice(
          name: _savedPrinterName ?? 'Thermal Printer',
          macAddress: _savedPrinterMac!,
        );
        notifyListeners();
        return;
      }

      final ok = await _printerService.connect(_savedPrinterMac!);
      if (ok) {
        _isConnected = true;
        _connectedPrinter = PrinterDevice(
          name: _savedPrinterName ?? 'Thermal Printer',
          macAddress: _savedPrinterMac!,
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> checkBluetoothState() async {
    _isBluetoothEnabled = await _printerService.isBluetoothEnabled();
    notifyListeners();
  }

  Future<void> setPaperSize(String size) async {
    _paperSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_paper_size', size);
  }

  Future<void> setAutoPrintOnOrder(bool value) async {
    _autoPrintOnOrder = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('printer_auto_print', value);
  }

  Future<void> turnOnBluetooth() async {
    await _printerService.turnOnBluetooth();
    await checkBluetoothState();
  }

  /// Get nearby printers
  Future<void> refreshPairedDevices() async {
    final paired = await _printerService.getPairedDevices();
    _devices = paired;

    final isConn = await _printerService.isConnected();
    _isConnected = isConn;
    if (!isConn && _connectedPrinter != null) {
      _connectedPrinter = null;
    }

    notifyListeners();
  }

  /// Explicitly requests bluetooth permissions and initializes printer discovery
  Future<void> requestPermissionsAndInit() async {
    await _printerService.requestPermissions();
    await checkBluetoothState();
    await refreshPairedDevices();
    if (_savedPrinterMac != null && _isBluetoothEnabled) {
      _autoReconnect();
    }
  }

  /// Scan for nearby Bluetooth printers
  Future<void> startScan() async {
    _errorMessage = null;
    _statusMessage = null;

    final hasPerms = await _printerService.requestPermissions();
    if (!hasPerms) {
      _errorMessage =
          'Nearby Devices / Bluetooth permissions are required to scan for printers.';
      notifyListeners();
      return;
    }

    final isBtOn = await _printerService.isBluetoothEnabled();
    _isBluetoothEnabled = isBtOn;
    if (!isBtOn) {
      _errorMessage = 'Bluetooth is turned off. Please turn ON Bluetooth.';
      notifyListeners();
      return;
    }

    _isScanning = true;
    _statusMessage = 'Scanning for nearby Bluetooth printers...';
    notifyListeners();

    try {
      final list = await _printerService.scanNearbyDevices(
        timeout: const Duration(seconds: 6),
      );

      _devices = list;
      _isScanning = false;
      _statusMessage = null;
      notifyListeners();
    } catch (e) {
      _isScanning = false;
      _errorMessage = 'Scan failed: $e';
      notifyListeners();
    }
  }

  /// Connect to a specific printer device
  Future<bool> connect(PrinterDevice device) async {
    _isConnecting = true;
    _errorMessage = null;
    _statusMessage = 'Connecting to ${device.name}...';
    notifyListeners();

    try {
      final success = await _printerService.connect(device.macAddress);
      _isConnecting = false;

      if (success) {
        _isConnected = true;
        _connectedPrinter = device;
        _savedPrinterMac = device.macAddress;
        _savedPrinterName = device.name;
        _statusMessage = 'Connected to ${device.name}';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('printer_saved_mac', device.macAddress);
        await prefs.setString('printer_saved_name', device.name);
      } else {
        _isConnected = false;
        _errorMessage =
            'Could not connect to ${device.name}. Ensure printer is powered ON and in range.';
        _statusMessage = null;
      }

      notifyListeners();
      return success;
    } catch (e) {
      _isConnecting = false;
      _isConnected = false;
      _errorMessage = 'Connection error: $e';
      _statusMessage = null;
      notifyListeners();
      return false;
    }
  }

  /// Disconnect printer
  Future<void> disconnect() async {
    await _printerService.disconnect();
    _isConnected = false;
    _connectedPrinter = null;
    _statusMessage = 'Disconnected';
    notifyListeners();
  }

  /// Print order receipt
  Future<bool> printOrderReceipt({
    required Order order,
    required List<OrderItem> items,
    required BusinessSetting business,
    required TaxSetting taxSettings,
  }) async {
    if (!_isConnected || _connectedPrinter == null) {
      if (_savedPrinterMac != null) {
        final connected = await _printerService.connect(_savedPrinterMac!);
        if (connected) {
          _isConnected = true;
          _connectedPrinter = PrinterDevice(
            name: _savedPrinterName ?? 'Thermal Printer',
            macAddress: _savedPrinterMac!,
          );
        } else {
          _errorMessage =
              'Printer not connected. Please connect your printer first.';
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage =
            'Printer not connected. Please connect your printer first.';
        notifyListeners();
        return false;
      }
    }

    _isPrinting = true;
    _errorMessage = null;
    _statusMessage = 'Printing receipt #${order.orderNumber}...';
    notifyListeners();

    try {
      final bytes = await ThermalReceiptBuilder.buildOrderReceipt(
        order: order,
        items: items,
        business: business,
        taxSettings: taxSettings,
        is80mm: is80mm,
      );

      final success = await _printerService.printBytes(bytes);
      _isPrinting = false;

      if (success) {
        _statusMessage = 'Receipt printed successfully!';
      } else {
        _errorMessage =
            'Failed to send data to thermal printer. Check connection.';
      }

      notifyListeners();
      return success;
    } catch (e) {
      _isPrinting = false;
      _errorMessage = 'Print error: $e';
      _statusMessage = null;
      notifyListeners();
      return false;
    }
  }

  /// Print test receipt
  Future<bool> printTestReceipt({
    required BusinessSetting business,
  }) async {
    if (!_isConnected || _connectedPrinter == null) {
      if (_savedPrinterMac != null) {
        final connected = await _printerService.connect(_savedPrinterMac!);
        if (connected) {
          _isConnected = true;
          _connectedPrinter = PrinterDevice(
            name: _savedPrinterName ?? 'Thermal Printer',
            macAddress: _savedPrinterMac!,
          );
        } else {
          _errorMessage = 'No printer connected. Connect a printer first.';
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'No printer connected. Connect a printer first.';
        notifyListeners();
        return false;
      }
    }

    _isPrinting = true;
    _errorMessage = null;
    _statusMessage = 'Printing test receipt...';
    notifyListeners();

    try {
      final bytes = await ThermalReceiptBuilder.buildTestReceipt(
        business: business,
        is80mm: is80mm,
      );

      final success = await _printerService.printBytes(bytes);
      _isPrinting = false;

      if (success) {
        _statusMessage = 'Test receipt printed!';
      } else {
        _errorMessage = 'Failed to print test receipt.';
      }

      notifyListeners();
      return success;
    } catch (e) {
      _isPrinting = false;
      _errorMessage = 'Test print error: $e';
      _statusMessage = null;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _btStateSub?.cancel();
    super.dispose();
  }
}
