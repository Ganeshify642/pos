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
      businessName: Value('ગોપાલ વડાપાંઉ'),
      phone: Value('+91 92650 53568'),
      address: Value('ગોપાલ વડાપાંઉ'),
      gstId: Value(''),
    ));

    // 2. Clear existing menu, inventory & orders to prevent duplicates
    await db.delete(db.orderItemsTable).go();
    await db.delete(db.ordersTable).go();
    await db.delete(db.inventoryAdjustmentsTable).go();
    await db.delete(db.dailyInventoryTable).go();
    await db.delete(db.itemsTable).go();
    await db.delete(db.categoriesTable).go();

    // 3. Insert Categories (matching the category list from the app)
    final catBestSellerId = await db.into(db.categoriesTable).insert(
          const CategoriesTableCompanion(
            name: Value('Best Seller Items'),
            sortOrder: Value(0),
            colorHex: Value('#EA580C'),
          ),
        );

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
            name: Value('પીઝા'),
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

    // 4. Insert Menu Items
    // Format: (categoryId, name, description, sellingPrice, costPrice, prepQty, lowStock, imageUrl)
    final List<(int, String, String, double, double, int, int, String)> mockItems = [
      // ── વડાપાંઉ (Vadapav) ──
      (catVadapavId, 'સાદા વડાપાંઉ', 'સાદા વડાપાંઉ with chutney', 25.0, 10.0, 100, 15, ''),
      (catVadapavId, 'અમુલ બટર', 'અમુલ બટર વડાપાંઉ', 30.0, 12.0, 80, 10, ''),
      (catVadapavId, 'અમુલ ડબલ બટર (Best Seller)', 'અમુલ ડબલ બટર વડાપાંઉ - Best Seller', 35.0, 15.0, 80, 10, ''),
      (catVadapavId, 'અમુલ ચીઝ', 'અમુલ ચીઝ વડાપાંઉ', 45.0, 18.0, 60, 10, ''),
      (catVadapavId, 'ડબલ બટર ચીઝ', 'ડબલ બટર ચીઝ વડાપાંઉ', 55.0, 22.0, 50, 8, ''),
      (catVadapavId, 'ડબલ ચીઝ', 'ડબલ ચીઝ વડાપાંઉ', 65.0, 26.0, 40, 8, ''),
      (catVadapavId, 'ગાર્લિક માયો', 'ગાર્લિક માયો વડાપાંઉ', 35.0, 14.0, 60, 10, ''),
      (catVadapavId, 'તંદુરી માયો', 'તંદુરી માયો વડાપાંઉ', 35.0, 14.0, 60, 10, ''),
      (catVadapavId, 'સેઝવાન', 'સેઝવાન વડાપાંઉ', 35.0, 14.0, 60, 10, ''),
      (catVadapavId, 'ચીઝ સેઝવાન', 'ચીઝ સેઝવાન વડાપાંઉ', 50.0, 20.0, 40, 8, ''),
      (catVadapavId, 'અમુલ ચીઝ તંદુરી (Best Seller)', 'અમુલ ચીઝ તંદુરી વડાપાંઉ - Best Seller', 50.0, 20.0, 50, 8, ''),
      (catVadapavId, 'અમુલ ચીઝ ગાર્લિક (Best Seller)', 'અમુલ ચીઝ ગાર્લિક વડાપાંઉ - Best Seller', 50.0, 20.0, 50, 8, ''),

      // ── મમરી પાંઉ (Mamri Pav) ──
      (catMamriPavId, 'મમરી પાંઉ', 'સાદા મમરી પાંઉ', 25.0, 10.0, 60, 10, ''),
      (catMamriPavId, 'ડબલ બટર મમરી (Best Seller)', 'ડબલ બટર મમરી પાંઉ - Best Seller', 30.0, 12.0, 50, 8, ''),
      (catMamriPavId, 'ગાર્લિક મમરી', 'ગાર્લિક મમરી પાંઉ', 30.0, 12.0, 50, 8, ''),
      (catMamriPavId, 'તંદુરી મમરી', 'તંદુરી મમરી પાંઉ', 30.0, 12.0, 50, 8, ''),
      (catMamriPavId, 'ચીઝ મમરી (Best Seller)', 'ચીઝ મમરી પાંઉ - Best Seller', 40.0, 16.0, 40, 8, ''),

      // ── વડા (Vada) ──
      (catVadaId, 'વડા (૨ નંગ)', 'વડા ૨ નંગ', 30.0, 12.0, 80, 10, ''),
      (catVadaId, 'બટર વડા', 'બટર વડા', 40.0, 16.0, 60, 8, ''),
      (catVadaId, 'ચીઝ વડા', 'અમુલ ચીઝ વડા', 50.0, 20.0, 40, 8, ''),

      // ── ચટણી (Chatni) ──
      (catChatneeId, 'બટર ચટણી', 'બટર ચટણી', 10.0, 4.0, 100, 15, ''),
      (catChatneeId, 'ચીઝ ચટણી', 'ચીઝ ચટણી', 20.0, 8.0, 80, 10, ''),

      // ── છાશ (Chhaash) ──
      (catChaashId, 'છાશ', 'છાશ', 15.0, 5.0, 100, 15, ''),

      // ── સાઈડ આઇટમ (Side Items) ──
      (catSideItemId, 'સ્પે. પટ્ટી મરચા (કિલો)', 'સ્પેશ્યલ પટ્ટી મરચા - 1 કિલો', 300.0, 150.0, 10, 3, ''),
      (catSideItemId, 'એક્સ્ટ્રા પટ્ટી (100 ગ્રામ)', 'એક્સ્ટ્રા પટ્ટી - 100 ગ્રામ', 30.0, 15.0, 50, 10, ''),
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
              imageUrl: Value(it.$8.isEmpty ? null : it.$8),
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
          ('સાદા વડાપાંઉ', 2, ''),
          ('અમુલ ડબલ બટર (Best Seller)', 1, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(minutes: 42)),
        source: AppConstants.sourceDineIn,
        tableName: 'Table 2',
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('અમુલ ચીઝ', 2, 'Extra cheese'),
          ('ચીઝ મમરી (Best Seller)', 1, ''),
          ('છાશ', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 1, minutes: 20)),
        source: AppConstants.sourceTakeaway,
        customerPhone: '9820198201',
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('અમુલ ડબલ બટર (Best Seller)', 3, ''),
          ('ડબલ બટર મમરી (Best Seller)', 2, ''),
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
          ('ડબલ ચીઝ', 2, ''),
          ('ચીઝ સેઝવાન', 2, ''),
          ('છાશ', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 3, minutes: 5)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('સાદા વડાપાંઉ', 4, ''),
          ('વડા (૨ નંગ)', 2, ''),
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
          ('સેઝવાન', 3, ''),
          ('ચીઝ વડા', 2, ''),
          ('છાશ', 3, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 5, minutes: 15)),
        source: AppConstants.sourceDineIn,
        tableName: 'Table 4',
        paymentMethod: AppConstants.paymentCard,
        items: [
          ('ગાર્લિક માયો', 2, ''),
          ('મમરી પાંઉ', 2, ''),
          ('બટર ચટણી', 2, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(hours: 6, minutes: 40)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('અમુલ બટર', 1, ''),
          ('છાશ', 1, ''),
        ],
      ),

      // Yesterday Orders
      _MockOrderDef(
        time: now.subtract(const Duration(days: 1, hours: 2)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('અમુલ ચીઝ તંદુરી (Best Seller)', 2, ''),
          ('ડબલ બટર મમરી (Best Seller)', 2, ''),
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
          ('અમુલ ચીઝ ગાર્લિક (Best Seller)', 2, ''),
          ('ચીઝ મમરી (Best Seller)', 2, ''),
          ('છાશ', 4, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(days: 1, hours: 6)),
        source: AppConstants.sourceDineIn,
        tableName: 'Table 1',
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('ડબલ બટર ચીઝ', 1, ''),
          ('તંદુરી માયો', 1, ''),
          ('છાશ', 1, ''),
        ],
      ),

      // 2 Days ago Orders
      _MockOrderDef(
        time: now.subtract(const Duration(days: 2, hours: 3)),
        source: AppConstants.sourceCounter,
        paymentMethod: AppConstants.paymentCash,
        items: [
          ('સાદા વડાપાંઉ', 5, ''),
          ('બટર વડા', 3, ''),
        ],
      ),
      _MockOrderDef(
        time: now.subtract(const Duration(days: 2, hours: 5)),
        source: AppConstants.sourceTakeaway,
        customerPhone: '9123456780',
        paymentMethod: AppConstants.paymentUPI,
        items: [
          ('ગાર્લિક મમરી', 2, ''),
          ('તંદુરી મમરી', 2, ''),
          ('ચીઝ ચટણી', 4, ''),
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
