import 'package:drift/drift.dart';
import '../data/db_types.dart';

class MockCategoryDef {
  final String key;
  final String en;
  final String gu;
  final String hi;
  final int sortOrder;
  final String colorHex;

  const MockCategoryDef({
    required this.key,
    required this.en,
    required this.gu,
    required this.hi,
    required this.sortOrder,
    required this.colorHex,
  });

  String getName(String lang) {
    if (lang == 'hi') return hi;
    if (lang == 'gu') return gu;
    return en;
  }
}

class MockItemDef {
  final String categoryKey;
  final String en;
  final String gu;
  final String hi;
  final double price;
  final String? imageUrl;
  final bool isBestSeller;
  final int? bestSellerRank;

  const MockItemDef({
    required this.categoryKey,
    required this.en,
    required this.gu,
    required this.hi,
    required this.price,
    this.imageUrl,
    this.isBestSeller = false,
    this.bestSellerRank,
  });

  String getName(String lang) {
    if (lang == 'hi') return hi;
    if (lang == 'gu') return gu;
    return en;
  }
}

class MockDataService {
  static const List<MockCategoryDef> categories = [
    MockCategoryDef(
      key: 'patti',
      en: 'Patti',
      gu: 'પટ્ટી',
      hi: 'पट्टी',
      sortOrder: 1,
      colorHex: '#D84315',
    ),
    MockCategoryDef(
      key: 'puf',
      en: 'Puff',
      gu: 'પફ',
      hi: 'पफ',
      sortOrder: 2,
      colorHex: '#F57C00',
    ),
    MockCategoryDef(
      key: 'roll',
      en: 'Roll',
      gu: 'રોલ',
      hi: 'रोल',
      sortOrder: 3,
      colorHex: '#FF8F00',
    ),
    MockCategoryDef(
      key: 'chatnee',
      en: 'Chutney',
      gu: 'ચટણી',
      hi: 'चटनी',
      sortOrder: 4,
      colorHex: '#00897B',
    ),
    MockCategoryDef(
      key: 'chaash',
      en: 'Chhaash',
      gu: 'છાશ',
      hi: 'छाछ',
      sortOrder: 5,
      colorHex: '#0288D1',
    ),
    MockCategoryDef(
      key: 'drinks',
      en: 'Drinks',
      gu: 'પીણાં',
      hi: 'पेय',
      sortOrder: 6,
      colorHex: '#C62828',
    ),
    MockCategoryDef(
      key: 'mamri_pav',
      en: 'Mamri Pav',
      gu: 'મમરી પાંઉ',
      hi: 'ममरी पाव',
      sortOrder: 7,
      colorHex: '#6A1B9A',
    ),
    MockCategoryDef(
      key: 'vada',
      en: 'Vada',
      gu: 'વડા',
      hi: 'वड़ा',
      sortOrder: 8,
      colorHex: '#AD1457',
    ),
    MockCategoryDef(
      key: 'vadapav',
      en: 'Vadapav',
      gu: 'વડાપાંઉ',
      hi: 'वड़ापाव',
      sortOrder: 9,
      colorHex: '#E65100',
    ),
    MockCategoryDef(
      key: 'side_items',
      en: 'Side Items',
      gu: 'સાઈડ આઇટમ',
      hi: 'साइड आइटम',
      sortOrder: 10,
      colorHex: '#4E342E',
    ),
  ];

  static const List<MockItemDef> items = [
    // ── Vadapav / વડાપાંઉ / वड़ापाव ──
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Regular Vadapav',
      gu: 'સાદા વડાપાંઉ',
      hi: 'सादा वड़ापाव',
      price: 25.0,
      imageUrl: 'assets/images/item/vadapav.jpeg',
      isBestSeller: true,
      bestSellerRank: 1,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Amul Butter Vadapav',
      gu: 'અમુલ બટર વડાપાંઉ',
      hi: 'अमुल बटर वड़ापाव',
      price: 30.0,
      imageUrl: 'assets/images/item/butter.jpg.jpeg',
      isBestSeller: true,
      bestSellerRank: 2,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Amul Double Butter Vadapav',
      gu: 'અમુલ ડબલ બટર વડાપાંઉ',
      hi: 'अमुल डबल बटर वड़ापाव',
      price: 35.0,
      imageUrl: 'assets/images/item/double_butter.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Amul Cheese Vadapav',
      gu: 'અમુલ ચીઝ વડાપાંઉ',
      hi: 'अमुल चीज़ वड़ापाव',
      price: 45.0,
      imageUrl: 'assets/images/item/cheese_vadapav.jpeg',
      isBestSeller: true,
      bestSellerRank: 3,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Double Butter Cheese Vadapav',
      gu: 'ડબલ બટર ચીઝ વડાપાંઉ',
      hi: 'डबल बटर चीज़ वड़ापाव',
      price: 55.0,
      imageUrl: 'assets/images/item/double_butter_cheeze.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Double Cheese Vadapav',
      gu: 'ડબલ ચીઝ વડાપાંઉ',
      hi: 'डबल चीज़ वड़ापाव',
      price: 65.0,
      imageUrl: 'assets/images/item/double_cheese.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Garlic Mayo Vadapav',
      gu: 'ગાર્લિક માયો વડાપાંઉ',
      hi: 'गार्लिक मायो वड़ापाव',
      price: 35.0,
      imageUrl: 'assets/images/item/garlik_mayo.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Tandoori Mayo Vadapav',
      gu: 'તંદુરી માયો વડાપાંઉ',
      hi: 'तंदूरी मायो वड़ापाव',
      price: 35.0,
      imageUrl: 'assets/images/item/Cheese_tanduari.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Schezwan Vadapav',
      gu: 'સેઝવાન વડાપાંઉ',
      hi: 'शेज़वान वड़ापाव',
      price: 35.0,
      imageUrl: 'assets/images/item/cheez_sezvan.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Cheese Schezwan Vadapav',
      gu: 'ચીઝ સેઝવાન વડાપાંઉ',
      hi: 'चीज़ शेज़वान वड़ापाव',
      price: 50.0,
      imageUrl: 'assets/images/item/cheez_sezvan.jpeg',
      isBestSeller: true,
      bestSellerRank: 4,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Amul Cheese Tandoori Vadapav',
      gu: 'અમુલ ચીઝ તંદુરી વડાપાંઉ',
      hi: 'अमुल चीज़ तंदूरी वड़ापाव',
      price: 50.0,
      imageUrl: 'assets/images/item/Cheese_tanduari.jpeg',
      isBestSeller: true,
      bestSellerRank: 5,
    ),
    MockItemDef(
      categoryKey: 'vadapav',
      en: 'Amul Cheese Garlic Vadapav',
      gu: 'અમુલ ચીઝ ગાર્લિક વડાપાંઉ',
      hi: 'अमुल चीज़ गार्लिक वड़ापाव',
      price: 50.0,
      imageUrl: 'assets/images/item/cheese_garlik.jpg.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),

    // ── Mamri Pav / મમરી પાંઉ / ममरी पाव ──
    MockItemDef(
      categoryKey: 'mamri_pav',
      en: 'Regular Mamri Pav',
      gu: 'મમરી પાંઉ',
      hi: 'ममरी पाव',
      price: 25.0,
      imageUrl: 'assets/images/item/cheese_mamari.jpg.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'mamri_pav',
      en: 'Double Butter Mamri',
      gu: 'ડબલ બટર મમરી',
      hi: 'डबल बटर ममरी',
      price: 30.0,
      imageUrl: 'assets/images/item/double_butter_2.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'mamri_pav',
      en: 'Garlic Mamri',
      gu: 'ગાર્લિક મમરી',
      hi: 'गार्लिक ममरी',
      price: 30.0,
      imageUrl: 'assets/images/item/garlik_mamari.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'mamri_pav',
      en: 'Tandoori Mamri',
      gu: 'તંદુરી મમરી',
      hi: 'तंदूरी ममरी',
      price: 30.0,
      imageUrl: 'assets/images/item/Cheese_tanduari.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'mamri_pav',
      en: 'Cheese Mamri',
      gu: 'ચીઝ મમરી',
      hi: 'चीज़ ममरी',
      price: 40.0,
      imageUrl: 'assets/images/item/cheese_mamri_pav.jpeg',
      isBestSeller: true,
      bestSellerRank: 6,
    ),

    // ── Vada / વડા / वड़ा ──
    MockItemDef(
      categoryKey: 'vada',
      en: 'Vada (2 Pcs)',
      gu: 'વડા (૨ નંગ)',
      hi: 'वड़ा (२ नग)',
      price: 30.0,
      imageUrl: 'assets/images/item/vada_1.jpeg',
      isBestSeller: true,
      bestSellerRank: 7,
    ),
    MockItemDef(
      categoryKey: 'vada',
      en: 'Butter Vada',
      gu: 'બટર વડા',
      hi: 'बटर वड़ा',
      price: 40.0,
      imageUrl: 'assets/images/item/vada_2.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'vada',
      en: 'Cheese Vada',
      gu: 'ચીઝ વડા',
      hi: 'चीज़ वड़ा',
      price: 50.0,
      imageUrl: 'assets/images/item/vada_2.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),

    // ── Chutney / ચટણી / चटनी ──
    MockItemDef(
      categoryKey: 'chatnee',
      en: 'Butter Chutney',
      gu: 'બટર ચટણી',
      hi: 'बटर चटनी',
      price: 10.0,
      imageUrl: 'assets/images/item/butter_chatani.png',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'chatnee',
      en: 'Cheese Chutney',
      gu: 'ચીઝ ચટણી',
      hi: 'चीज़ चटनी',
      price: 20.0,
      imageUrl: 'assets/images/item/cheese_chatani.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),

    // ── Chhaash / છાશ / छाछ ──
    MockItemDef(
      categoryKey: 'chaash',
      en: 'Chhaash (Buttermilk)',
      gu: 'છાશ',
      hi: 'छाछ',
      price: 15.0,
      imageUrl: 'assets/images/item/Chhas.jpeg',
      isBestSeller: true,
      bestSellerRank: 8,
    ),

    // ── Side Items / સાઈડ આઇટમ / साइड आइटम ──
    MockItemDef(
      categoryKey: 'side_items',
      en: 'Special Patti Mirchi (1 kg)',
      gu: 'સ્પે. પટ્ટી મરચા (કિલો)',
      hi: 'स्पेशल पट्टी मिर्च (१ किलो)',
      price: 300.0,
      imageUrl: 'assets/images/item/extra_patti.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'side_items',
      en: 'Extra Patti (100g)',
      gu: 'એક્સ્ટ્રા પટ્ટી (100 ગ્રામ)',
      hi: 'एक्स्ट्रा पट्टी (१०० ग्राम)',
      price: 30.0,
      imageUrl: 'assets/images/item/extra_patti.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'side_items',
      en: 'Chikki',
      gu: 'ચીક્કી',
      hi: 'चिक्की',
      price: 10.0,
      imageUrl: 'assets/images/item/chikki.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),

    // ── Patti / Puff / Roll / Drinks ──
    MockItemDef(
      categoryKey: 'patti',
      en: 'Special Patti',
      gu: 'સ્પેશ્યલ પટ્ટી',
      hi: 'स्पेशल पट्टी',
      price: 30.0,
      imageUrl: 'assets/images/item/extra_patti.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'puf',
      en: 'Puff',
      gu: 'પફ',
      hi: 'पफ',
      price: 25.0,
      imageUrl: 'assets/images/item/vadapav.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'roll',
      en: 'Cream Roll',
      gu: 'ક્રીમ રોલ',
      hi: 'क्रीम रोल',
      price: 25.0,
      imageUrl: 'assets/images/item/cream_role.jpeg',
      isBestSeller: false,
      bestSellerRank: null,
    ),
    MockItemDef(
      categoryKey: 'drinks',
      en: 'Mineral Water',
      gu: 'મિનરલ વોટર',
      hi: 'मिनरल वाटर',
      price: 20.0,
      imageUrl: 'assets/images/item/watter.png',
      isBestSeller: false,
      bestSellerRank: null,
    ),
  ];

  /// Populates categories and menu items for Gopal Vadapav Shop in the selected language ('en', 'hi', or 'gu')
  static Future<void> loadVadapavMockData(
    AppDatabase db, {
    String language = 'en',
  }) async {
    await clearAllData(db);

    final Map<String, int> categoryIdMap = {};

    for (final cat in categories) {
      final id = await db.into(db.categoriesTable).insert(
            CategoriesTableCompanion(
              name: Value(cat.getName(language)),
              sortOrder: Value(cat.sortOrder),
              colorHex: Value(cat.colorHex),
            ),
          );
      categoryIdMap[cat.key] = id;
    }

    for (final it in items) {
      final categoryId = categoryIdMap[it.categoryKey] ?? 1;
      final itemName = it.getName(language);

      await db.into(db.itemsTable).insert(
            ItemsTableCompanion(
              categoryId: Value(categoryId),
              name: Value(itemName),
              description: Value(itemName),
              sellingPrice: Value(it.price),
              costPrice: Value((it.price * 0.4).roundToDouble()),
              imageUrl: Value(it.imageUrl),
              lowStockThreshold: const Value(5),
              defaultPrepQty: const Value(0),
              isAvailable: const Value(true),
              isDeleted: const Value(false),
              isBestSeller: Value(it.isBestSeller),
              bestSellerRank: Value(it.bestSellerRank),
            ),
          );
    }
  }

  /// Updates existing menu items and categories in the database to the target language ('en', 'hi', or 'gu')
  static Future<void> updateMenuLanguage(
    AppDatabase db,
    String targetLang,
  ) async {
    // 1. Update Categories
    final currentCategories = await db.select(db.categoriesTable).get();
    for (final cat in currentCategories) {
      for (final def in categories) {
        if (cat.name == def.en || cat.name == def.gu || cat.name == def.hi) {
          final newName = def.getName(targetLang);
          if (newName != cat.name) {
            await (db.update(db.categoriesTable)..where((t) => t.id.equals(cat.id)))
                .write(CategoriesTableCompanion(name: Value(newName)));
          }
          break;
        }
      }
    }

    // 2. Update Items
    final currentItems = await db.select(db.itemsTable).get();
    for (final it in currentItems) {
      for (final def in items) {
        if (it.name == def.en || it.name == def.gu || it.name == def.hi) {
          final newName = def.getName(targetLang);
          if (newName != it.name) {
            await (db.update(db.itemsTable)..where((t) => t.id.equals(it.id)))
                .write(ItemsTableCompanion(
                  name: Value(newName),
                  description: Value(newName),
                ));
          }
          break;
        }
      }
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
