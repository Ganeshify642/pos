import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import '../data/db_types.dart';
import '../services/calculation_service.dart';
import '../services/invoice_service.dart';
import '../utils/constants.dart';

class MockDataService {
  /// Populates complete, rich mock data for Gopal Vadapav Shop
  static Future<void> loadVadapavMockData(AppDatabase db) async {
    // 1. Update Business Settings
    await (db.update(db.businessSettingsTable)..where((t) => t.id.equals(1)))
        .write(const BusinessSettingsTableCompanion(
      businessName: Value('Gopal Vadapav & Fast Food'),
      phone: Value('+91 98765 43210'),
      address: Value('Shop #4, Station Road, Opp. Platform 1, Mumbai - 400001'),
      gstId: Value('27AABCU9603R1ZM'),
    ));

    // 2. Clear existing menu, inventory & orders to prevent duplicates
    await db.delete(db.orderItemsTable).go();
    await db.delete(db.ordersTable).go();
    await db.delete(db.inventoryAdjustmentsTable).go();
    await db.delete(db.dailyInventoryTable).go();
    await db.delete(db.itemsTable).go();
    await db.delete(db.categoriesTable).go();

    // 3. Insert Categories
    final catVadapavId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Vadapav Specials'),
            sortOrder: Value(0),
            colorHex: Value('#E65100'),
          ),
        );

    final catSamosaId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Samosa & Puffs'),
            sortOrder: Value(1),
            colorHex: Value('#D84315'),
          ),
        );

    final catSnacksId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Snacks & Bhajiya'),
            sortOrder: Value(2),
            colorHex: Value('#F57C00'),
          ),
        );

    final catBeveragesId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Beverages & Tea'),
            sortOrder: Value(3),
            colorHex: Value('#00897B'),
          ),
        );

    final catCombosId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Value Combos'),
            sortOrder: Value(4),
            colorHex: Value('#7B1FA2'),
          ),
        );

    // 4. Insert Menu Items
    final List<(int, String, String, double, double, int, int)> mockItems = [
      // Vadapav Specials
      (
        catVadapavId,
        'Classic Mumbai Vadapav',
        'Traditional spiced potato patty in pav with spicy garlic chutney & fried green chilli',
        20.0,
        9.0,
        120,
        15
      ),
      (
        catVadapavId,
        'Cheese Burst Vadapav',
        'Loaded with melted Amul mozzarella cheese & signature chutneys',
        45.0,
        22.0,
        60,
        10
      ),
      (
        catVadapavId,
        'Schezwan Spicy Vadapav',
        'Desi vadapav infused with spicy Chinese schezwan sauce & onions',
        30.0,
        13.0,
        70,
        10
      ),
      (
        catVadapavId,
        'Butter Grill Vadapav',
        'Pav toasted on pan with pure butter until crispy & golden brown',
        35.0,
        15.0,
        50,
        10
      ),
      (
        catVadapavId,
        'Ulta Vadapav (Crispy Fried)',
        'Pav stuffed with batata filling and batter-fried to golden perfection',
        35.0,
        14.0,
        40,
        8
      ),
      (
        catVadapavId,
        'Mayo Garlic Vadapav',
        'Creamy garlic mayonnaise spread with crunchy onions & special masala',
        35.0,
        15.0,
        45,
        8
      ),

      // Samosa & Puffs
      (
        catSamosaId,
        'Punjabi Samosa Pav',
        'Crispy potato pea samosa tucked inside fresh pav with sweet tamarind chutney',
        25.0,
        11.0,
        90,
        15
      ),
      (
        catSamosaId,
        'Single Punjabi Samosa',
        'Large crispy spiced potato and green peas samosa (1 pc)',
        20.0,
        9.0,
        80,
        15
      ),
      (
        catSamosaId,
        'Cheese Corn Puff',
        'Flaky golden baked puff pastry stuffed with sweet corn & cheese',
        35.0,
        17.0,
        35,
        5
      ),

      // Snacks & Bhajiya
      (
        catSnacksId,
        'Kanda Bhaji Plate (Onion Pakoda)',
        'Crispy thinly sliced onion fritters seasoned with carom seeds & spices',
        40.0,
        16.0,
        50,
        10
      ),
      (
        catSnacksId,
        'Batata Bhajiya Plate',
        'Thin sliced potato fritters coated in spiced gram flour batter',
        40.0,
        16.0,
        40,
        8
      ),
      (
        catSnacksId,
        'Fried Salted Chillies (Extra)',
        'Deep fried green chillies seasoned with rock salt & chaat masala',
        10.0,
        3.0,
        100,
        20
      ),

      // Beverages & Tea
      (
        catBeveragesId,
        'Special Masala Cutting Chai',
        'Freshly brewed hot tea with crushed ginger, cardamom & aromatic spices',
        15.0,
        5.0,
        180,
        25
      ),
      (
        catBeveragesId,
        'Ginger Cardamom Full Tea',
        'Full cup aromatic kadak tea with milk & freshly crushed ginger',
        25.0,
        8.0,
        100,
        15
      ),
      (
        catBeveragesId,
        'Chilled Masala Chaas (Buttermilk)',
        'Refreshing spiced buttermilk with roasted cumin, mint & black salt',
        20.0,
        7.0,
        60,
        10
      ),
      (
        catBeveragesId,
        'Cold Drink 250ml',
        'Assorted chilled soft drinks (Thums Up, Sprite, Coke)',
        25.0,
        18.0,
        50,
        10
      ),

      // Value Combos
      (
        catCombosId,
        'Chai + Vadapav Combo',
        '1 Classic Mumbai Vadapav + 1 Masala Cutting Chai (Customer favorite!)',
        32.0,
        14.0,
        60,
        10
      ),
      (
        catCombosId,
        '2 Vadapav + Masala Chai Combo',
        '2 Classic Vadapav + 1 Masala Cutting Chai',
        52.0,
        23.0,
        40,
        8
      ),
      (
        catCombosId,
        'Family Feast (4 Vadapav + 2 Chai)',
        '4 Classic Vadapav + 2 Masala Cutting Chai + Fried Salted Chillies',
        100.0,
        45.0,
        25,
        5
      ),
    ];

    final Map<String, int> itemNameToId = {};
    final Map<int, Item> itemMap = {};

    for (final it in mockItems) {
      final id = await db.into(db.itemsTable).insert(
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
      itemNameToId[it.$2] = id;
      final createdItem = await (db.select(db.itemsTable)..where((t) => t.id.equals(id))).getSingle();
      itemMap[id] = createdItem;
    }

    // 5. Populate Daily Inventory for Today
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (final it in mockItems) {
      final itemId = itemNameToId[it.$2]!;
      final made = it.$6; // default prep qty
      final sold = (made * 0.65).round();
      final wasted = (made * 0.03).round();

      await db.into(db.dailyInventoryTable).insert(
            DailyInventoryTableCompanion(
              itemId: Value(itemId),
              date: Value(todayStr),
              madeQty: Value(made),
              soldQty: Value(sold),
              wastedQty: Value(wasted),
              createdAt: Value(DateTime.now().subtract(const Duration(hours: 6))),
              updatedAt: Value(DateTime.now()),
            ),
          );
    }

    // 6. Generate Realistic Sample Orders (Today, Yesterday, Earlier this week)
    final business = await (db.select(db.businessSettingsTable)..where((t) => t.id.equals(1))).getSingle();
    final tax = await (db.select(db.taxSettingsTable)..where((t) => t.id.equals(1))).getSingle();

    final now = DateTime.now();

    final List<_MockOrderDef> orderDefs = [
      // Today Orders
      _MockOrderDef(
        time: now.subtract(const Duration(minutes: 15)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('Classic Mumbai Vadapav', 2, ''),
          ('Special Masala Cutting Chai', 2, 'Extra ginger'),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(minutes: 42)),
        source: AppConstants.sourceDineIn,
        tableName: 'Table 2',
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('Cheese Burst Vadapav', 2, 'Extra cheese'),
          ('Kanda Bhaji Plate (Onion Pakoda)', 1, 'Crispy'),
          ('Chilled Masala Chaas (Buttermilk)', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 1, minutes: 20)),
        source: AppConstants.sourceTakeaway,
        customerPhone: '9820198201',
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('Chai + Vadapav Combo', 3, 'Packed separately'),
          ('Butter Grill Vadapav', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 2, minutes: 10)),
        source: AppConstants.sourceDelivery,
        deliveryApp: 'Swiggy',
        deliveryAppOrderId: 'SWIG-89421',
        customerPhone: '9811223344',
        deliveryAddress: 'Flat 402, Sai Shraddha Apts, Station Road',
        deliveryFee: 30.0,
        paymentMethod: 'Swiggy Online',
        items: [
          ('Family Feast (4 Vadapav + 2 Chai)', 1, 'Pack with extra fried chillies'),
          ('Ulta Vadapav (Crispy Fried)', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 3, minutes: 5)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('Classic Mumbai Vadapav', 4, ''),
          ('Special Masala Cutting Chai', 4, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 4, minutes: 30)),
        source: AppConstants.sourceDelivery,
        deliveryApp: 'Zomato',
        deliveryAppOrderId: 'ZOM-65129',
        customerPhone: '9765432109',
        deliveryAddress: 'Office #12, Trade Center, 2nd Floor',
        deliveryFee: 30.0,
        paymentMethod: 'Zomato Online',
        items: [
          ('Schezwan Spicy Vadapav', 3, ''),
          ('Punjabi Samosa Pav', 3, ''),
          ('Cold Drink 250ml', 3, 'Chilled Thums Up'),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 5, minutes: 15)),
        source: AppConstants.sourceDineIn,
        tableName: 'Table 4',
        paymentMethod: AppConstants.paymentCard,
        items: [
          ('Batata Bhajiya Plate', 2, 'Hot & fresh'),
          ('Ginger Cardamom Full Tea', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 6, minutes: 40)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('Classic Mumbai Vadapav', 1, ''),
          ('Special Masala Cutting Chai', 1, ''),
        ],
      ),

      // Yesterday Orders
      _MockOrderDef(
        time: now.subtract(const Duration(days: 1, hours: 2)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('2 Vadapav + Masala Chai Combo', 2, ''),
          ('Single Punjabi Samosa', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(days: 1, hours: 4)),
        source: AppConstants.sourceDelivery,
        deliveryApp: 'Swiggy',
        deliveryAppOrderId: 'SWIG-87103',
        customerPhone: '9898989898',
        deliveryAddress: 'B-201, Green Heights, Opp Station',
        deliveryFee: 30.0,
        paymentMethod: 'Swiggy Online',
        items: [
          ('Family Feast (4 Vadapav + 2 Chai)', 2, 'Extra chutney please'),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(days: 1, hours: 6)),
        source: AppConstants.sourceDineIn,
        tableName: 'Table 1',
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('Cheese Burst Vadapav', 1, ''),
          ('Schezwan Spicy Vadapav', 1, ''),
          ('Cold Drink 250ml', 1, ''),
        ],
      ),

      // 2 Days ago Orders
      _MockOrderDef(
        time: now.subtract(const Duration(days: 2, hours: 3)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('Classic Mumbai Vadapav', 5, 'Quick packing'),
          ('Special Masala Cutting Chai', 5, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(days: 2, hours: 5)),
        source: AppConstants.sourceTakeaway,
        customerPhone: '9123456780',
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('Kanda Bhaji Plate (Onion Pakoda)', 2, ''),
          ('Batata Bhajiya Plate', 2, ''),
          ('Special Masala Cutting Chai', 4, ''),
        ],
      ),
    ];

    final Map<String, int> dateSeqMap = {};
    for (final def in orderDefs) {
      final dateKey = DateFormat('yyyyMMdd').format(def.time);
      final currentSeq = (dateSeqMap[dateKey] ?? 0) + 1;
      dateSeqMap[dateKey] = currentSeq;

      final orderNumber =
          CalculationService.generateOrderNumber(currentSeq, def.time);

      // Prepare line items
      final List<({double price, int qty})> lineItemTuples = [];
      final List<OrderItemsTableCompanion> itemCompanions = [];

      for (final it in def.items) {
        final itemId = itemNameToId[it.$1];
        if (itemId != null) {
          final item = itemMap[itemId]!;
          lineItemTuples.add((qty: it.$2, price: item.sellingPrice));
          itemCompanions.add(OrderItemsTableCompanion.insert(
            orderId: 0,
            itemId: itemId,
            itemName: item.name,
            quantity: it.$2,
            priceAtOrder: item.sellingPrice,
            specialInstructions: Value(it.$3),
          ));
        }
      }

      final calc = CalculationService.calculateOfflineOrderTotal(
        items: lineItemTuples,
        taxSettings: tax,
        deliveryFee: def.deliveryFee,
      );

      final isDelivery = def.source == AppConstants.sourceDelivery;
      final platformFee = isDelivery ? calc.finalTotal * 0.18 : 0.0;
      final netEarnings = calc.finalTotal - platformFee;

      final orderCompanion = OrdersTableCompanion.insert(
        orderNumber: orderNumber,
        orderSource: def.source,
        deliveryAppName: Value(def.tableName ?? def.deliveryApp),
        deliveryAppOrderId: Value(def.deliveryAppOrderId),
        customerPhone: Value(def.customerPhone),
        deliveryAddress: Value(def.deliveryAddress),
        subtotal: Value(calc.subtotal),
        taxAmount: Value(calc.taxAmount),
        sgstAmount: Value(calc.sgst),
        cgstAmount: Value(calc.cgst),
        discountAmount: const Value(0.0),
        deliveryFee: Value(def.deliveryFee),
        platformFee: Value(platformFee),
        grossAmount: Value(calc.finalTotal),
        netEarnings: Value(netEarnings),
        finalTotal: Value(calc.finalTotal),
        paymentMethod: Value(def.paymentMethod),
        paymentStatus: const Value(AppConstants.paymentPaid),
        orderStatus: const Value(AppConstants.statusCompleted),
        notes: const Value(''),
        createdAt: Value(def.time),
        completedAt: Value(def.time.add(const Duration(minutes: 5))),
      );

      final orderId = await db.transaction(() async {
        final insertedOrderId = await db.into(db.ordersTable).insert(orderCompanion);
        for (final ic in itemCompanions) {
          await db.into(db.orderItemsTable).insert(ic.copyWith(orderId: Value(insertedOrderId)));
        }
        return insertedOrderId;
      });

      // Generate invoice PDF
      try {
        final createdOrder = await (db.select(db.ordersTable)..where((t) => t.id.equals(orderId))).getSingle();
        final createdItems = await (db.select(db.orderItemsTable)..where((t) => t.orderId.equals(orderId))).get();
        final pdfPath = await InvoiceService.generateInvoice(
          order: createdOrder,
          items: createdItems,
          businessSettings: business,
          taxSettings: tax,
        );
        await (db.update(db.ordersTable)..where((t) => t.id.equals(orderId)))
            .write(OrdersTableCompanion(invoicePath: Value(pdfPath)));
      } catch (_) {}
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

class _MockOrderDef {
  final DateTime time;
  final String source;
  final String? tableName;
  final String? deliveryApp;
  final String? deliveryAppOrderId;
  final String? customerPhone;
  final String? deliveryAddress;
  final double deliveryFee;
  final String paymentMethod;
  final List<(String itemName, int qty, String instruction)> items;

  _MockOrderDef({
    required this.time,
    required this.source,
    this.tableName,
    this.deliveryApp,
    this.deliveryAppOrderId,
    this.customerPhone,
    this.deliveryAddress,
    this.deliveryFee = 0.0,
    required this.paymentMethod,
    required this.items,
  });
}
