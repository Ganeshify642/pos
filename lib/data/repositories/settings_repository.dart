import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../db_types.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  // ─── BUSINESS SETTINGS ───────────────────────────────────────────────

  Future<BusinessSetting?> getBusinessSettings() async {
    return await (_db.select(_db.businessSettingsTable)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
  }

  Future<void> saveBusinessSettings(BusinessSettingsTableCompanion companion) async {
    final existing = await getBusinessSettings();
    if (existing != null) {
      await (_db.update(_db.businessSettingsTable)
            ..where((t) => t.id.equals(1)))
          .write(companion);
    } else {
      await _db.into(_db.businessSettingsTable).insert(companion);
    }
  }

  // ─── TAX SETTINGS ────────────────────────────────────────────────────

  Future<TaxSetting?> getTaxSettings() async {
    return await (_db.select(_db.taxSettingsTable)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
  }

  Future<void> saveTaxSettings(TaxSettingsTableCompanion companion) async {
    final existing = await getTaxSettings();
    if (existing != null) {
      await (_db.update(_db.taxSettingsTable)
            ..where((t) => t.id.equals(1)))
          .write(companion);
    } else {
      await _db.into(_db.taxSettingsTable).insert(companion);
    }
  }

  // ─── DELIVERY APP SETTINGS ───────────────────────────────────────────

  Future<List<DeliveryAppSetting>> getAllDeliveryApps() async {
    return await (_db.select(_db.deliveryAppSettingsTable)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  Future<DeliveryAppSetting?> getDeliveryApp(String appName) async {
    return await (_db.select(_db.deliveryAppSettingsTable)
          ..where((t) => t.appName.equals(appName) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<void> upsertDeliveryApp(
      String appName, double commissionPct, double fixedFee) async {
    final existing = await getDeliveryApp(appName);
    if (existing != null) {
      await (_db.update(_db.deliveryAppSettingsTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(DeliveryAppSettingsTableCompanion(
        commissionPct: Value(commissionPct),
        fixedFee: Value(fixedFee),
      ));
    } else {
      await _db.into(_db.deliveryAppSettingsTable).insert(
            DeliveryAppSettingsTableCompanion.insert(
              appName: appName,
              commissionPct: Value(commissionPct),
              fixedFee: Value(fixedFee),
            ),
          );
    }
  }

  Future<void> toggleDeliveryApp(int id, bool isActive) async {
    await (_db.update(_db.deliveryAppSettingsTable)
          ..where((t) => t.id.equals(id)))
        .write(DeliveryAppSettingsTableCompanion(isActive: Value(isActive)));
  }

  Stream<BusinessSetting?> watchBusinessSettings() {
    return (_db.select(_db.businessSettingsTable)
          ..where((t) => t.id.equals(1)))
        .watchSingleOrNull();
  }
}
