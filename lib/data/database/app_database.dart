import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ─── TABLE DEFINITIONS ──────────────────────────────────────────────────────

class BusinessSettingsTable extends Table {
  @override
  String get tableName => 'business_settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get businessName => text().withDefault(const Constant('My Restaurant'))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get gstId => text().withDefault(const Constant(''))();
  TextColumn get logoPath => text().nullable()();
}

class TaxSettingsTable extends Table {
  @override
  String get tableName => 'tax_settings';

  IntColumn get id => integer().autoIncrement()();
  RealColumn get sgstPct => real().withDefault(const Constant(9.0))();
  RealColumn get cgstPct => real().withDefault(const Constant(9.0))();
  RealColumn get igstPct => real().withDefault(const Constant(18.0))();
  TextColumn get taxMode => text().withDefault(const Constant('SGST+CGST'))();
  BoolColumn get taxEnabled => boolean().withDefault(const Constant(true))();
}

class DeliveryAppSettingsTable extends Table {
  @override
  String get tableName => 'delivery_app_settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get appName => text()();
  RealColumn get commissionPct => real().withDefault(const Constant(18.0))();
  RealColumn get fixedFee => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get colorHex => text().withDefault(const Constant('#4F46E5'))();
}

class ItemsTable extends Table {
  @override
  String get tableName => 'items';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(CategoriesTable, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get sellingPrice => real()();
  RealColumn get costPrice => real().withDefault(const Constant(0.0))();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(5))();
  IntColumn get defaultPrepQty => integer().withDefault(const Constant(0))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class OrdersTable extends Table {
  @override
  String get tableName => 'orders';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNumber => text()();
  TextColumn get orderSource => text()(); // Offline/Swiggy/Zomato/Other
  TextColumn get deliveryAppName => text().nullable()();
  TextColumn get deliveryAppOrderId => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get deliveryAddress => text().nullable()();
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get sgstAmount => real().withDefault(const Constant(0.0))();
  RealColumn get cgstAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get deliveryFee => real().withDefault(const Constant(0.0))();
  RealColumn get platformFee => real().withDefault(const Constant(0.0))();
  RealColumn get grossAmount => real().withDefault(const Constant(0.0))();
  RealColumn get netEarnings => real().withDefault(const Constant(0.0))();
  RealColumn get finalTotal => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('Cash'))();
  TextColumn get paymentStatus => text().withDefault(const Constant('Pending'))();
  TextColumn get orderStatus => text().withDefault(const Constant('Pending'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get invoicePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

class OrderItemsTable extends Table {
  @override
  String get tableName => 'order_items';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(OrdersTable, #id)();
  IntColumn get itemId => integer()();
  TextColumn get itemName => text()(); // snapshot at time of order
  IntColumn get quantity => integer()();
  RealColumn get priceAtOrder => real()();
  TextColumn get specialInstructions => text().withDefault(const Constant(''))();
}

class DailyInventoryTable extends Table {
  @override
  String get tableName => 'daily_inventory';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(ItemsTable, #id)();
  TextColumn get date => text()(); // "YYYY-MM-DD"
  IntColumn get madeQty => integer().withDefault(const Constant(0))();
  IntColumn get soldQty => integer().withDefault(const Constant(0))();
  IntColumn get wastedQty => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class InventoryAdjustmentsTable extends Table {
  @override
  String get tableName => 'inventory_adjustments';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyInventoryId => integer().references(DailyInventoryTable, #id)();
  TextColumn get adjustmentType => text()(); // 'made', 'wasted'
  IntColumn get delta => integer()();
  TextColumn get reason => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class BackupLogsTable extends Table {
  @override
  String get tableName => 'backup_logs';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get filePath => text()();
  IntColumn get fileSize => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── DATABASE ───────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  BusinessSettingsTable,
  TaxSettingsTable,
  DeliveryAppSettingsTable,
  CategoriesTable,
  ItemsTable,
  OrdersTable,
  OrderItemsTable,
  DailyInventoryTable,
  InventoryAdjustmentsTable,
  BackupLogsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _insertDefaults();
        },
        onUpgrade: (m, from, to) async {},
      );

  Future<void> _insertDefaults() async {
    // Insert default business settings
    await into(businessSettingsTable).insert(
      BusinessSettingsTableCompanion.insert(
        businessName: const Value('My Restaurant'),
        phone: const Value(''),
        address: const Value(''),
        gstId: const Value(''),
      ),
    );

    // Insert default tax settings
    await into(taxSettingsTable).insert(
      TaxSettingsTableCompanion.insert(
        sgstPct: const Value(9.0),
        cgstPct: const Value(9.0),
        igstPct: const Value(18.0),
        taxMode: const Value('SGST+CGST'),
        taxEnabled: const Value(true),
      ),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'delivery_bill_db');
  }
}
