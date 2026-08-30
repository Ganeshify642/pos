import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database/app_database.dart';
import '../data/db_types.dart';
import '../data/repositories/settings_repository.dart';
import '../utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repo;

  BusinessSetting? _businessSettings;
  TaxSetting? _taxSettings;
  List<DeliveryAppSetting> _deliveryApps = [];

  bool _isLoading = false;
  String? _error;

  // Theme (Default Light Mode)
  ThemeMode _themeMode = ThemeMode.light;

  // Order Modes Toggle
  bool _orderModesEnabled = false;

  SettingsProvider(this._repo) {
    _loadPrefs();
  }

  // Getters
  BusinessSetting? get businessSettings => _businessSettings;
  TaxSetting? get taxSettings => _taxSettings;
  List<DeliveryAppSetting> get deliveryApps => _deliveryApps;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ThemeMode get themeMode => _themeMode;
  bool get orderModesEnabled => _orderModesEnabled;

  String get businessName =>
      _businessSettings?.businessName ?? AppConstants.appName;
  String get businessPhone => _businessSettings?.phone ?? '';
  String get gstId => _businessSettings?.gstId ?? '';

  double get defaultSgstPct => _taxSettings?.sgstPct ?? AppConstants.defaultSgstPct;
  double get defaultCgstPct => _taxSettings?.cgstPct ?? AppConstants.defaultCgstPct;
  double get defaultIgstPct => _taxSettings?.igstPct ?? AppConstants.defaultIgstPct;
  bool get taxEnabled => _taxSettings?.taxEnabled ?? true;
  String get taxMode =>
      _taxSettings?.taxMode ?? AppConstants.taxModeSplit;

  DeliveryAppSetting? getDeliveryAppByName(String name) {
    try {
      return _deliveryApps.firstWhere((DeliveryAppSetting a) => a.appName == name);
    } catch (_) {
      return null;
    }
  }

  double getCommissionPct(String appName) {
    return getDeliveryAppByName(appName)?.commissionPct ??
        AppConstants.defaultCommissionPct;
  }

  double getFixedFee(String appName) {
    return getDeliveryAppByName(appName)?.fixedFee ?? 0;
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _businessSettings = await _repo.getBusinessSettings();
      if (_businessSettings == null ||
          _businessSettings!.businessName == 'My Restaurant' ||
          _businessSettings!.businessName.trim().isEmpty) {
        await _repo.saveBusinessSettings(BusinessSettingsTableCompanion(
          businessName: const Value('ગોપાલ વડાપાંવ'),
          phone: Value(_businessSettings?.phone ?? ''),
          address: Value(_businessSettings?.address ?? ''),
          gstId: Value(_businessSettings?.gstId ?? ''),
        ));
        _businessSettings = await _repo.getBusinessSettings();
      }
      _taxSettings = await _repo.getTaxSettings();
      _deliveryApps = await _repo.getAllDeliveryApps();
      _error = null;
    } catch (e) {
      _error = 'Failed to load settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBusinessSettings({
    required String businessName,
    required String phone,
    required String address,
    required String gstId,
    String? logoPath,
  }) async {
    await _repo.saveBusinessSettings(BusinessSettingsTableCompanion(
      businessName: Value(businessName),
      phone: Value(phone),
      address: Value(address),
      gstId: Value(gstId),
      logoPath: Value(logoPath),
    ));
    await loadSettings();
  }

  Future<void> saveTaxSettings({
    required double sgstPct,
    required double cgstPct,
    required double igstPct,
    required String taxMode,
    required bool taxEnabled,
  }) async {
    await _repo.saveTaxSettings(TaxSettingsTableCompanion(
      sgstPct: Value(sgstPct),
      cgstPct: Value(cgstPct),
      igstPct: Value(igstPct),
      taxMode: Value(taxMode),
      taxEnabled: Value(taxEnabled),
    ));
    await loadSettings();
  }

  Future<void> saveDeliveryAppSettings(
      String appName, double commissionPct, double fixedFee) async {
    await _repo.upsertDeliveryApp(appName, commissionPct, fixedFee);
    await loadSettings();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _orderModesEnabled = prefs.getBool('orderModesEnabled') ?? false;
    notifyListeners();
  }

  Future<void> setOrderModesEnabled(bool value) async {
    _orderModesEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('orderModesEnabled', value);
  }
}
