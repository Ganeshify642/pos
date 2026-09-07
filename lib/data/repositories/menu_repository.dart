import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../db_types.dart';

class MenuRepository {
  final AppDatabase _db;

  MenuRepository(this._db);

  // ─── CATEGORIES ──────────────────────────────────────────────────────

  Future<List<Category>> getAllCategories() async {
    return await (_db.select(_db.categoriesTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<void> addCategory(String name, {String colorHex = '#4F46E5'}) async {
    final count = await _db.categoriesTable.count().getSingle();
    await _db.into(_db.categoriesTable).insert(
          CategoriesTableCompanion.insert(
            name: name,
            sortOrder: Value(count),
            colorHex: Value(colorHex),
          ),
        );
  }

  Future<void> updateCategory(
      int id, String name, String colorHex) async {
    await (_db.update(_db.categoriesTable)
          ..where((t) => t.id.equals(id)))
        .write(CategoriesTableCompanion(
      name: Value(name),
      colorHex: Value(colorHex),
    ));
  }

  Future<void> deleteCategory(int id) async {
    await (_db.update(_db.categoriesTable)
          ..where((t) => t.id.equals(id)))
        .write(const CategoriesTableCompanion(isActive: Value(false)));
  }

  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categoriesTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  // ─── ITEMS ───────────────────────────────────────────────────────────

  Future<List<Item>> getAllItems({bool includeUnavailable = false}) async {
    final query = _db.select(_db.itemsTable)
      ..where((t) => t.isDeleted.equals(false));
    if (!includeUnavailable) {
      query.where((t) => t.isAvailable.equals(true));
    }
    query.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return await query.get();
  }

  Future<List<Item>> getItemsByCategory(int categoryId) async {
    return await (_db.select(_db.itemsTable)
          ..where((t) =>
              t.categoryId.equals(categoryId) &
              t.isDeleted.equals(false) &
              t.isAvailable.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<Item?> getItemById(int id) async {
    return await (_db.select(_db.itemsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> addItem(ItemsTableCompanion item) async {
    return await _db.into(_db.itemsTable).insert(item);
  }

  Future<void> updateItem(int id, ItemsTableCompanion companion) async {
    await (_db.update(_db.itemsTable)..where((t) => t.id.equals(id)))
        .write(companion);
  }

  Future<void> toggleItemAvailability(int id, bool isAvailable) async {
    await (_db.update(_db.itemsTable)..where((t) => t.id.equals(id)))
        .write(ItemsTableCompanion(isAvailable: Value(isAvailable)));
  }

  Future<void> deleteItem(int id) async {
    await (_db.update(_db.itemsTable)..where((t) => t.id.equals(id)))
        .write(const ItemsTableCompanion(isDeleted: Value(true)));
  }

  Stream<List<Item>> watchItems() {
    return (_db.select(_db.itemsTable)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Search items by name
  Future<List<Item>> searchItems(String query) async {
    return await (_db.select(_db.itemsTable)
          ..where((t) =>
              t.name.like('%$query%') &
              t.isDeleted.equals(false) &
              t.isAvailable.equals(true)))
        .get();
  }

  /// Toggle best seller status for an item with sequential ranking
  Future<void> toggleBestSeller(int id, bool isBestSeller) async {
    if (isBestSeller) {
      // Find current maximum rank among existing best sellers
      final currentBestSellers = await (_db.select(_db.itemsTable)
            ..where((t) =>
                t.isBestSeller.equals(true) & t.isDeleted.equals(false)))
          .get();

      int maxRank = 0;
      for (final item in currentBestSellers) {
        if (item.bestSellerRank != null && item.bestSellerRank! > maxRank) {
          maxRank = item.bestSellerRank!;
        }
      }
      final nextRank = maxRank + 1;

      await (_db.update(_db.itemsTable)..where((t) => t.id.equals(id))).write(
        ItemsTableCompanion(
          isBestSeller: const Value(true),
          bestSellerRank: Value(nextRank),
        ),
      );
    } else {
      // Unmark item as best seller
      await (_db.update(_db.itemsTable)..where((t) => t.id.equals(id))).write(
        const ItemsTableCompanion(
          isBestSeller: Value(false),
          bestSellerRank: Value(null),
        ),
      );

      // Re-compact remaining best sellers so ranks remain contiguous (1, 2, 3...)
      await _compactBestSellerRanks();
    }
  }

  /// Change rank of an existing best seller item (e.g. move to #1)
  Future<void> updateBestSellerRank(int id, int targetRank) async {
    final current = await (_db.select(_db.itemsTable)
          ..where((t) =>
              t.isBestSeller.equals(true) & t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.asc(t.bestSellerRank),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();

    final itemIndex = current.indexWhere((it) => it.id == id);
    if (itemIndex == -1) return;

    final item = current.removeAt(itemIndex);
    final clampedRank = targetRank.clamp(1, current.length + 1);
    current.insert(clampedRank - 1, item);

    for (int i = 0; i < current.length; i++) {
      final rank = i + 1;
      await (_db.update(_db.itemsTable)..where((t) => t.id.equals(current[i].id)))
          .write(ItemsTableCompanion(bestSellerRank: Value(rank)));
    }
  }

  /// Reorder best sellers according to an ordered list of item IDs
  Future<void> reorderBestSellers(List<int> itemIdsInOrder) async {
    for (int i = 0; i < itemIdsInOrder.length; i++) {
      final rank = i + 1;
      await (_db.update(_db.itemsTable)
            ..where((t) => t.id.equals(itemIdsInOrder[i])))
          .write(ItemsTableCompanion(
        isBestSeller: const Value(true),
        bestSellerRank: Value(rank),
      ));
    }
  }

  /// Re-compact best seller ranks so they are sequential 1, 2, 3...
  Future<void> _compactBestSellerRanks() async {
    final remaining = await (_db.select(_db.itemsTable)
          ..where((t) =>
              t.isBestSeller.equals(true) & t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.asc(t.bestSellerRank),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();

    for (int i = 0; i < remaining.length; i++) {
      final newRank = i + 1;
      if (remaining[i].bestSellerRank != newRank) {
        await (_db.update(_db.itemsTable)
              ..where((t) => t.id.equals(remaining[i].id)))
            .write(ItemsTableCompanion(bestSellerRank: Value(newRank)));
      }
    }
  }

  /// Get all items marked as best sellers ordered by bestSellerRank
  Future<List<Item>> getBestSellerItems() async {
    return await (_db.select(_db.itemsTable)
          ..where((t) =>
              t.isBestSeller.equals(true) &
              t.isDeleted.equals(false) &
              t.isAvailable.equals(true))
          ..orderBy([
            (t) => OrderingTerm.asc(t.bestSellerRank),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }
}
