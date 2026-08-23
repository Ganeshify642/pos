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
}
