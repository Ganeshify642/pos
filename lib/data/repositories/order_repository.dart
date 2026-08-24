import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../db_types.dart';
import '../../utils/formatters.dart';
import '../../models/app_models.dart';
import '../../utils/constants.dart';


class OrderRepository {
  final AppDatabase _db;

  OrderRepository(this._db);

  // ─── ORDER CRUD ────────────────────────────────────────────────────────

  /// Get next order sequence number for today (starts from 1 each day)
  Future<int> getNextOrderSequence() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todaysOrders = await (_db.select(_db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay)))
        .get();

    return todaysOrders.length + 1;
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
          ..where((t) =>
              t.createdAt.isBetweenValues(start, end.add(const Duration(days: 1))))
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
    return await (_db.select(_db.ordersTable)
          ..where((t) => t.id.equals(id)))
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
    await (_db.update(_db.ordersTable)
          ..where((t) => t.id.equals(orderId)))
        .write(OrdersTableCompanion(
      orderStatus: Value(status),
      completedAt: status == 'Completed'
          ? Value(DateTime.now())
          : const Value.absent(),
    ));
  }

  /// Update invoice path after PDF generation
  Future<void> updateInvoicePath(int orderId, String path) async {
    await (_db.update(_db.ordersTable)
          ..where((t) => t.id.equals(orderId)))
        .write(OrdersTableCompanion(invoicePath: Value(path)));
  }

  /// Delete order (for cancellation)
  Future<void> deleteOrder(int orderId) async {
    await (_db.delete(_db.orderItemsTable)
          ..where((t) => t.orderId.equals(orderId)))
        .go();
    await (_db.delete(_db.ordersTable)
          ..where((t) => t.id.equals(orderId)))
        .go();
  }

  // ─── REPORTING QUERIES ────────────────────────────────────────────────

  /// Revenue summary by source for a date range
  Future<Map<String, SourceStats>> getRevenueBySource(
      DateTime start, DateTime end) async {
    final orders = await getOrdersForDateRange(start, end);
    final Map<String, SourceStats> result = {};

    for (final order in orders) {
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

  /// Top selling items by quantity for a date range
  Future<List<MapEntry<String, int>>> getTopItems(
      DateTime start, DateTime end, {int limit = 5}) async {
    final List<Order> orders = await getOrdersForDateRange(start, end);
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

  /// Get detailed item sales and profit analytics for a date range
  Future<List<ItemAnalytics>> getItemAnalytics(
      DateTime start, DateTime end) async {
    final List<Order> orders = await getOrdersForDateRange(start, end);
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
