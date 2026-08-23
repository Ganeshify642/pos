import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../db_types.dart';
import '../../models/app_models.dart';
import '../../utils/formatters.dart';

class InventoryRepository {
  final AppDatabase _db;

  InventoryRepository(this._db);

  // ─── DAILY INVENTORY ──────────────────────────────────────────────────

  /// Get today's inventory for all items
  Future<List<DailyInventory>> getTodayInventory() async {
    final today = AppFormatters.todayKey;
    return await (_db.select(_db.dailyInventoryTable)
          ..where((t) => t.date.equals(today)))
        .get();
  }

  /// Get inventory for a specific date
  Future<List<DailyInventory>> getInventoryForDate(DateTime date) async {
    final dateStr = AppFormatters.dbDate(date);
    return await (_db.select(_db.dailyInventoryTable)
          ..where((t) => t.date.equals(dateStr)))
        .get();
  }

  /// Get inventory entry for a specific item on today
  Future<DailyInventory?> getTodayItemInventory(int itemId) async {
    final today = AppFormatters.todayKey;
    return await (_db.select(_db.dailyInventoryTable)
          ..where((t) => t.itemId.equals(itemId) & t.date.equals(today)))
        .getSingleOrNull();
  }

  /// Upsert daily inventory entry
  Future<void> upsertInventory(int itemId, int madeQty) async {
    final today = AppFormatters.todayKey;
    final existing = await getTodayItemInventory(itemId);
    if (existing != null) {
      await (_db.update(_db.dailyInventoryTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(DailyInventoryTableCompanion(
        madeQty: Value(madeQty),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await _db.into(_db.dailyInventoryTable).insert(
            DailyInventoryTableCompanion.insert(
              itemId: itemId,
              date: today,
              madeQty: Value(madeQty),
            ),
          );
    }
  }

  /// Deduct sold quantity when an order is created
  Future<void> deductSoldQty(int itemId, int qty) async {
    final today = AppFormatters.todayKey;
    final existing = await getTodayItemInventory(itemId);
    if (existing != null) {
      await (_db.update(_db.dailyInventoryTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(DailyInventoryTableCompanion(
        soldQty: Value(existing.soldQty + qty),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      // Auto-create entry with sold qty
      await _db.into(_db.dailyInventoryTable).insert(
            DailyInventoryTableCompanion.insert(
              itemId: itemId,
              date: today,
              soldQty: Value(qty),
            ),
          );
    }
  }

  /// Update wasted quantity
  Future<void> updateWastedQty(int itemId, int wastedQty,
      {String? reason}) async {
    final today = AppFormatters.todayKey;
    final existing = await getTodayItemInventory(itemId);
    if (existing != null) {
      // Log adjustment
      await _db.into(_db.inventoryAdjustmentsTable).insert(
            InventoryAdjustmentsTableCompanion.insert(
              dailyInventoryId: existing.id,
              adjustmentType: 'wasted',
              delta: wastedQty - existing.wastedQty,
              reason: Value(reason ?? ''),
            ),
          );
      await (_db.update(_db.dailyInventoryTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(DailyInventoryTableCompanion(
        wastedQty: Value(wastedQty),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  /// Get yesterday's inventory for "copy yesterday" feature
  Future<List<DailyInventory>> getYesterdayInventory() async {
    final yesterday = AppFormatters.dbDate(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    return await (_db.select(_db.dailyInventoryTable)
          ..where((t) => t.date.equals(yesterday)))
        .get();
  }

  /// Build inventory status by joining items + daily inventory
  Future<List<InventoryStatus>> getTodayInventoryStatus() async {
    final today = AppFormatters.todayKey;
    final items = await (_db.select(_db.itemsTable)
          ..where((t) => t.isDeleted.equals(false) & t.isAvailable.equals(true)))
        .get();

    final inventory = await getTodayInventory();
    final invMap = {for (final i in inventory) i.itemId: i};

    final categories = await (_db.select(_db.categoriesTable)).get();
    final catMap = {for (final c in categories) c.id: c.name};

    return items.map((item) {
      final inv = invMap[item.id];
      return InventoryStatus(
        itemId: item.id,
        itemName: item.name,
        categoryName: catMap[item.categoryId] ?? 'Unknown',
        madeQty: inv?.madeQty ?? 0,
        soldQty: inv?.soldQty ?? 0,
        wastedQty: inv?.wastedQty ?? 0,
        lowStockThreshold: item.lowStockThreshold,
      );
    }).toList();
  }

  /// Get remaining qty for an item today
  Future<int> getRemainingQty(int itemId) async {
    final inv = await getTodayItemInventory(itemId);
    if (inv == null) return 999; // If no inventory set, treat as unlimited
    return (inv.madeQty - inv.soldQty - inv.wastedQty).clamp(0, 9999);
  }

  /// Watch today's inventory (reactive)
  Stream<List<DailyInventory>> watchTodayInventory() {
    final today = AppFormatters.todayKey;
    return (_db.select(_db.dailyInventoryTable)
          ..where((t) => t.date.equals(today)))
        .watch();
  }
}
