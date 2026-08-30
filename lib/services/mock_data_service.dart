import 'package:drift/drift.dart';
import '../data/db_types.dart';

class MockDataService {
  /// Populates demo categories and menu items for Gopal Vadapav Shop
  static Future<void> loadVadapavMockData(AppDatabase db) async {
    await db.delete(db.itemsTable).go();
    await db.delete(db.categoriesTable).go();

 
    final catPattiId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Patti'),
            sortOrder: Value(1),
            colorHex: Value('#D84315'),
          ),
        );

    final catPufId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Puf'),
            sortOrder: Value(2),
            colorHex: Value('#F57C00'),
          ),
        );

    final catRollId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Roll'),
            sortOrder: Value(3),
            colorHex: Value('#FF8F00'),
          ),
        );

    final catChatneeId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('ચટણી'),
            sortOrder: Value(4),
            colorHex: Value('#00897B'),
          ),
        );

    final catChaashId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('છાશ'),
            sortOrder: Value(5),
            colorHex: Value('#0288D1'),
          ),
        );

    final catPizzaId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('પીણાં'),
            sortOrder: Value(6),
            colorHex: Value('#C62828'),
          ),
        );

    final catMamriPavId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('મમરી પાંઉ'),
            sortOrder: Value(7),
            colorHex: Value('#6A1B9A'),
          ),
        );

    final catVadaId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('વડા'),
            sortOrder: Value(8),
            colorHex: Value('#AD1457'),
          ),
        );

    final catVadapavId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('વડાપાંઉ'),
            sortOrder: Value(9),
            colorHex: Value('#E65100'),
          ),
        );

    final catSideItemId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('સાઈડ આઇટમ'),
            sortOrder: Value(10),
            colorHex: Value('#4E342E'),
          ),
        );

    // ── Insert Menu Items ──────────────────────────────────────────────
    // Format: (categoryId, name, description, sellingPrice, costPrice, prepQty, lowStock)
    final List<(int, String, String, double, double, int, int)> mockItems = [
      // ── વડાપાંઉ (Vadapav) ──
      (catVadapavId, 'સાદા વડાપાંઉ', 'સાદા વડાપાંઉ with chutney', 25.0, 10.0, 100, 15),
      (catVadapavId, 'અમુલ બટર', 'અમુલ બટર વડાપાંઉ', 30.0, 12.0, 80, 10),
      (catVadapavId, 'અમુલ ડબલ બટર', 'અમુલ ડબલ બટર વડાપાંઉ', 35.0, 15.0, 80, 10),
      (catVadapavId, 'અમુલ ચીઝ', 'અમુલ ચીઝ વડાપાંઉ', 45.0, 18.0, 60, 10),
      (catVadapavId, 'ડબલ બટર ચીઝ', 'ડબલ બટર ચીઝ વડાપાંઉ', 55.0, 22.0, 50, 8),
      (catVadapavId, 'ડબલ ચીઝ', 'ડબલ ચીઝ વડાપાંઉ', 65.0, 26.0, 40, 8),
      (catVadapavId, 'ગાર્લિક માયો', 'ગાર્લિક માયો વડાપાંઉ', 35.0, 14.0, 60, 10),
      (catVadapavId, 'તંદુરી માયો', 'તંદુરી માયો વડાપાંઉ', 35.0, 14.0, 60, 10),
      (catVadapavId, 'સેઝવાન', 'સેઝવાન વડાપાંઉ', 35.0, 14.0, 60, 10),
      (catVadapavId, 'ચીઝ સેઝવાન', 'ચીઝ સેઝવાન વડાપાંઉ', 50.0, 20.0, 40, 8),
      (catVadapavId, 'અમુલ ચીઝ તંદુરી', 'અમુલ ચીઝ તંદુરી વડાપાંઉ', 50.0, 20.0, 50, 8),
      (catVadapavId, 'અમુલ ચીઝ ગાર્લિક', 'અમુલ ચીઝ ગાર્લિક વડાપાંઉ', 50.0, 20.0, 50, 8),

      // ── મમરી પાંઉ (Mamri Pav) ──
      (catMamriPavId, 'મમરી પાંઉ', 'સાદા મમરી પાંઉ', 25.0, 10.0, 60, 10),
      (catMamriPavId, 'ડબલ બટર મમરી', 'ડબલ બટર મમરી પાંઉ', 30.0, 12.0, 50, 8),
      (catMamriPavId, 'ગાર્લિક મમરી', 'ગાર્લિક મમરી પાંઉ', 30.0, 12.0, 50, 8),
      (catMamriPavId, 'તંદુરી મમરી', 'તંદુરી મમરી પાંઉ', 30.0, 12.0, 50, 8),
      (catMamriPavId, 'ચીઝ મમરી', 'ચીઝ મમરી પાંઉ', 40.0, 16.0, 40, 8),

      // ── વડા (Vada) ──
      (catVadaId, 'વડા (૨ નંગ)', 'વડા ૨ નંગ', 30.0, 12.0, 80, 10),
      (catVadaId, 'બટર વડા', 'બટર વડા', 40.0, 16.0, 60, 8),
      (catVadaId, 'ચીઝ વડા', 'અમુલ ચીઝ વડા', 50.0, 20.0, 40, 8),

      // ── ચટણી (Chatni) ──
      (catChatneeId, 'બટર ચટણી', 'બટર ચટણી', 10.0, 4.0, 100, 15),
      (catChatneeId, 'ચીઝ ચટણી', 'ચીઝ ચટણી', 20.0, 8.0, 80, 10),

      // ── છાશ (Chhaash) ──
      (catChaashId, 'છાશ', 'છાશ', 15.0, 5.0, 100, 15),

      // ── સાઈડ આઇટમ (Side Items) ──
      (catSideItemId, 'સ્પે. પટ્ટી મરચા (કિલો)', 'સ્પેશ્યલ પટ્ટી મરચા - 1 કિલો', 300.0, 150.0, 10, 3),
      (catSideItemId, 'એક્સ્ટ્રા પટ્ટી (100 ગ્રામ)', 'એક્સ્ટ્રા પટ્ટી - 100 ગ્રામ', 30.0, 15.0, 50, 10),
    ];

    for (final it in mockItems) {
      await db.into(db.itemsTable).insert(
            ItemsTableCompanion(
              categoryId: Value(it.$1),
              name: Value(it.$2),
              description: Value(it.$3),
              sellingPrice: Value(it.$4),
              costPrice: Value(it.$5),
              defaultPrepQty: Value(it.$6),
              lowStockThreshold: Value(it.$7),
              isAvailable: const Value(true),
              isDeleted: const Value(false),
            ),
          );
    }
  }

  /// Clears all operational data (Orders, Inventory, Items, Categories)
  static Future<void> clearAllData(AppDatabase db) async {
    await db.delete(db.orderItemsTable).go();
    await db.delete(db.ordersTable).go();
    await db.delete(db.inventoryAdjustmentsTable).go();
    await db.delete(db.dailyInventoryTable).go();
    await db.delete(db.itemsTable).go();
    await db.delete(db.categoriesTable).go();
  }
}
