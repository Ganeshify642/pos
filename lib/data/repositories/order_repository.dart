import 'package:drift/drift.dart';
import '../../models/app_models.dart';
import '../../services/calculation_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../db_types.dart';

class OrderRepository {
  final AppDatabase _db;

  OrderRepository(this._db);

  // ─── ORDER CRUD ────────────────────────────────────────────────────────

  /// Get next order sequence number for a date (resets to 1 after midnight 12:00 AM)
  Future<int> getNextOrderSequence([DateTime? date]) async {
    final now = date ?? DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todaysOrders = await (_db.select(_db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay)))
        .get();

    int maxSeq = 0;
    for (final o in todaysOrders) {
      final seq = int.tryParse(o.orderNumber) ??
          int.tryParse(o.orderNumber.split('-').last) ??
          0;
      if (seq > maxSeq) {
        maxSeq = seq;
      }
    }

    return maxSeq + 1;
  }

  /// Generate guaranteed unique order number (001, 002, 003...)
  Future<String> generateUniqueOrderNumber([DateTime? date]) async {
    final now = date ?? DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    int seq = await getNextOrderSequence(now);
    while (true) {
      final candidate = CalculationService.generateOrderNumber(seq, now);
      final exists = await (_db.select(_db.ordersTable)
            ..where((t) =>
                t.orderNumber.equals(candidate) &
                t.createdAt.isBetweenValues(startOfDay, endOfDay)))
          .getSingleOrNull();
      if (exists == null) {
        return candidate;
      }
      seq++;
    }
  }

  /// Create a new order and its items, returns order ID
  Future<int> createOrder({
    required OrdersTableCompanion order,
    required List<OrderItemsTableCompanion> items,
  }) async {
    return await _db.transaction(() async {
      final orderId = await _db.into(_db.ordersTable).insert(order);
      for (final item in items) {
        await _db.into(_db.orderItemsTable).insert(
              item.copyWith(orderId: Value(orderId)),
            );
      }
      return orderId;
    });
  }

  /// Get all orders, most recent first
  Future<List<Order>> getAllOrders() async {
    return await (_db.select(_db.ordersTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get orders for a specific date range
  Future<List<Order>> getOrdersForDateRange(
      DateTime start, DateTime end) async {
    return await (_db.select(_db.ordersTable)
          ..where((t) => t.createdAt
              .isBetweenValues(start, end.add(const Duration(days: 1))))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get orders for today
  Future<List<Order>> getTodaysOrders() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    return await (_db.select(_db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get single order by ID
  Future<Order?> getOrderById(int id) async {
    return await (_db.select(_db.ordersTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get order items for an order
  Future<List<OrderItem>> getOrderItems(int orderId) async {
    return await (_db.select(_db.orderItemsTable)
          ..where((t) => t.orderId.equals(orderId)))
        .get();
  }

  /// Get order with items
  Future<OrderSummary?> getOrderSummary(int orderId) async {
    final order = await getOrderById(orderId);
    if (order == null) return null;
    final items = await getOrderItems(orderId);
    return OrderSummary(order: order, items: items);
  }

  /// Update order status
  Future<void> updateOrderStatus(int orderId, String status) async {
    await (_db.update(_db.ordersTable)..where((t) => t.id.equals(orderId)))
        .write(OrdersTableCompanion(
      orderStatus: Value(status),
      completedAt:
          status == 'Completed' ? Value(DateTime.now()) : const Value.absent(),
    ));
  }

  /// Update invoice path after PDF generation
  Future<void> updateInvoicePath(int orderId, String path) async {
    await (_db.update(_db.ordersTable)..where((t) => t.id.equals(orderId)))
        .write(OrdersTableCompanion(invoicePath: Value(path)));
  }

  /// Cancel order: updates status to Cancelled and restores sold inventory quantities
  Future<void> cancelOrder(int orderId) async {
    final order = await getOrderById(orderId);
    if (order == null || order.orderStatus == AppConstants.statusCancelled) {
      return;
    }

    await (_db.update(_db.ordersTable)..where((t) => t.id.equals(orderId)))
        .write(const OrdersTableCompanion(
      orderStatus: Value(AppConstants.statusCancelled),
      paymentStatus: Value(AppConstants.statusCancelled),
    ));

    // Restore inventory quantities for today
    final items = await getOrderItems(orderId);
    final today = AppFormatters.todayKey;

    for (final item in items) {
      final existingInv = await (_db.select(_db.dailyInventoryTable)
            ..where((t) => t.itemId.equals(item.itemId) & t.date.equals(today)))
          .getSingleOrNull();

      if (existingInv != null) {
        final newSold = (existingInv.soldQty - item.quantity).clamp(0, 999999);
        await (_db.update(_db.dailyInventoryTable)
              ..where((t) => t.id.equals(existingInv.id)))
            .write(DailyInventoryTableCompanion(
          soldQty: Value(newSold),
          updatedAt: Value(DateTime.now()),
        ));
      }
    }
  }

  /// Delete order
  Future<void> deleteOrder(int orderId) async {
    await (_db.delete(_db.orderItemsTable)
          ..where((t) => t.orderId.equals(orderId)))
        .go();
    await (_db.delete(_db.ordersTable)..where((t) => t.id.equals(orderId)))
        .go();
  }

  // ─── REPORTING QUERIES ────────────────────────────────────────────────

  /// Revenue summary by source for a date range (excludes cancelled orders)
  Future<Map<String, SourceStats>> getRevenueBySource(
      DateTime start, DateTime end) async {
    final orders = await getOrdersForDateRange(start, end);
    final Map<String, SourceStats> result = {};

    for (final order in orders) {
      if (order.orderStatus == AppConstants.statusCancelled) continue;

      final source = order.orderSource;
      final existing = result[source];
      result[source] = SourceStats(
        source: source,
        orderCount: (existing?.orderCount ?? 0) + 1,
        grossRevenue: (existing?.grossRevenue ?? 0) + order.grossAmount,
        platformFees: (existing?.platformFees ?? 0) + order.platformFee,
        netRevenue: (existing?.netRevenue ?? 0) + order.netEarnings,
      );
    }
    return result;
  }

  /// Top selling items by quantity for a date range (excludes cancelled orders)
  Future<List<MapEntry<String, int>>> getTopItems(DateTime start, DateTime end,
      {int limit = 5}) async {
    final List<Order> allOrders = await getOrdersForDateRange(start, end);
    final orders = allOrders
        .where((o) => o.orderStatus != AppConstants.statusCancelled)
        .toList();
    final List<int> orderIds = orders.map((Order o) => o.id).toList();

    if (orderIds.isEmpty) return [];

    final items = await (_db.select(_db.orderItemsTable)
          ..where((t) => t.orderId.isIn(orderIds)))
        .get();

    final Map<String, int> itemQty = {};
    for (final item in items) {
      itemQty[item.itemName] = (itemQty[item.itemName] ?? 0) + item.quantity;
    }

    final sorted = itemQty.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).toList();
  }

  /// Watch today's orders (reactive stream)
  Stream<List<Order>> watchTodaysOrders() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watch all orders (reactive)
  Stream<List<Order>> watchAllOrders() {
    return (_db.select(_db.ordersTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Get detailed item sales and profit analytics for a date range (excludes cancelled orders)
  Future<List<ItemAnalytics>> getItemAnalytics(
      DateTime start, DateTime end) async {
    final List<Order> allOrders = await getOrdersForDateRange(start, end);
    final orders = allOrders
        .where((o) => o.orderStatus != AppConstants.statusCancelled)
        .toList();
    final List<int> orderIds = orders.map((Order o) => o.id).toList();

    if (orderIds.isEmpty) return [];

    final orderItems = await (_db.select(_db.orderItemsTable)
          ..where((t) => t.orderId.isIn(orderIds)))
        .get();

    final allItems = await _db.select(_db.itemsTable).get();
    final itemMap = {for (final item in allItems) item.id: item};

    final allCategories = await _db.select(_db.categoriesTable).get();
    final catMap = {for (final cat in allCategories) cat.id: cat.name};

    final Map<int, List<OrderItem>> grouped = {};
    for (final oi in orderItems) {
      grouped.putIfAbsent(oi.itemId, () => []).add(oi);
    }

    final List<ItemAnalytics> result = [];

    final orderMap = {for (final o in orders) o.id: o};

    for (final entry in grouped.entries) {
      final itemId = entry.key;
      final oiList = entry.value;

      final itemDb = itemMap[itemId];
      final itemName = oiList.first.itemName;
      final categoryName =
          itemDb != null ? (catMap[itemDb.categoryId] ?? 'General') : 'General';
      final costPrice = itemDb?.costPrice ?? 0.0;
      final sellingPrice = oiList.first.priceAtOrder;

      int totalQtySold = 0;
      double totalRevenue = 0;
      final Set<int> orderSet = {};

      for (final oi in oiList) {
        final orderObj = orderMap[oi.orderId];
        final isStaff = orderObj != null &&
            (orderObj.orderSource == AppConstants.sourceStaff ||
                orderObj.paymentMethod == AppConstants.paymentStaff);

        totalQtySold += oi.quantity;
        if (!isStaff) {
          totalRevenue += oi.quantity * oi.priceAtOrder;
        }
        orderSet.add(oi.orderId);
      }

      final double totalCost = totalQtySold * costPrice;
      final double totalProfit = totalRevenue - totalCost;

      result.add(
        ItemAnalytics(
          itemId: itemId,
          itemName: itemName,
          categoryName: categoryName,
          costPrice: costPrice,
          sellingPrice: sellingPrice,
          totalQtySold: totalQtySold,
          totalRevenue: totalRevenue,
          totalCost: totalCost,
          totalProfit: totalProfit,
          orderCount: orderSet.length,
        ),
      );
    }

    result.sort((a, b) => b.totalQtySold.compareTo(a.totalQtySold));
    return result;
  }
}
