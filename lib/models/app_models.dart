// Models used across the app (plain Dart classes, not Drift-generated)
// These wrap the Drift data classes with convenience methods.

import '../data/database/app_database.dart';
import '../data/db_types.dart';
import '../utils/constants.dart';


// ─── CART ITEM (transient, not stored) ──────────────────────────────────────

class CartItem {
  final int itemId;
  final String itemName;
  final double price;
  int quantity;
  String specialInstructions;
  int? availableQty; // from daily inventory

  CartItem({
    required this.itemId,
    required this.itemName,
    required this.price,
    this.quantity = 1,
    this.specialInstructions = '',
    this.availableQty,
  });

  double get lineTotal => price * quantity;

  CartItem copyWith({
    int? quantity,
    String? specialInstructions,
    int? availableQty,
  }) {
    return CartItem(
      itemId: itemId,
      itemName: itemName,
      price: price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      availableQty: availableQty ?? this.availableQty,
    );
  }
}

// ─── ORDER SUMMARY (computed) ─────────────────────────────────────────────

class OrderSummary {
  final Order order;
  final List<OrderItem> items;

  OrderSummary({required this.order, required this.items});

  String get sourceDisplay => order.orderSource;
}

// ─── INVENTORY STATUS (computed) ─────────────────────────────────────────

class InventoryStatus {
  final int itemId;
  final String itemName;
  final String categoryName;
  final int madeQty;
  final int soldQty;
  final int wastedQty;
  final int lowStockThreshold;

  InventoryStatus({
    required this.itemId,
    required this.itemName,
    required this.categoryName,
    required this.madeQty,
    required this.soldQty,
    required this.wastedQty,
    required this.lowStockThreshold,
  });

  int get remainingQty => (madeQty - soldQty - wastedQty).clamp(0, 9999);
  bool get isOutOfStock => remainingQty == 0 && madeQty > 0;
  bool get isLowStock => remainingQty > 0 && remainingQty <= lowStockThreshold;
  bool get isAvailable => remainingQty > 0;
  double get utilizationPct =>
      madeQty > 0 ? (soldQty / madeQty * 100).clamp(0, 100) : 0;
  String get statusLabel {
    if (madeQty == 0) return 'Not Set';
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'Available';
  }
}

// ─── DAILY REPORT ─────────────────────────────────────────────────────────

class DailyReport {
  final DateTime date;
  final int totalOrders;
  final double totalRevenue;
  final double netEarnings;
  final double totalPlatformFees;
  final Map<String, SourceStats> bySource;
  final int totalItemsMade;
  final int totalItemsSold;
  final int totalWastage;

  DailyReport({
    required this.date,
    required this.totalOrders,
    required this.totalRevenue,
    required this.netEarnings,
    required this.totalPlatformFees,
    required this.bySource,
    required this.totalItemsMade,
    required this.totalItemsSold,
    required this.totalWastage,
  });

  double get avgOrderValue =>
      totalOrders > 0 ? totalRevenue / totalOrders : 0;
}

class SourceStats {
  final String source;
  final int orderCount;
  final double grossRevenue;
  final double platformFees;
  final double netRevenue;

  SourceStats({
    required this.source,
    required this.orderCount,
    required this.grossRevenue,
    required this.platformFees,
    required this.netRevenue,
  });

  double get avgOrderValue => orderCount > 0 ? grossRevenue / orderCount : 0;
}

// ─── MORNING SETUP ENTRY ─────────────────────────────────────────────────

class MorningSetupEntry {
  final int itemId;
  final String itemName;
  final String categoryName;
  int madeQty;
  int? yesterdayMadeQty;

  MorningSetupEntry({
    required this.itemId,
    required this.itemName,
    required this.categoryName,
    this.madeQty = 0,
    this.yesterdayMadeQty,
  });
}

// ─── ITEM ANALYTICS & DETAILED INSIGHTS ───────────────────────────────────

class ItemAnalytics {
  final int itemId;
  final String itemName;
  final String categoryName;
  final double costPrice;
  final double sellingPrice;
  final int totalQtySold;
  final double totalRevenue;
  final double totalCost;
  final double totalProfit;
  final int orderCount;

  ItemAnalytics({
    required this.itemId,
    required this.itemName,
    required this.categoryName,
    required this.costPrice,
    required this.sellingPrice,
    required this.totalQtySold,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.orderCount,
  });

  double get profitMarginPct =>
      totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0.0;

  double get avgQtyPerOrder =>
      orderCount > 0 ? totalQtySold / orderCount : 0.0;
}

// ── CATEGORY ANALYTICS & BREAKDOWN ──────────────────────────────────────

class CategoryAnalytics {
  final String categoryName;
  final int totalQtySold;
  final double totalRevenue;
  final double totalCost;
  final double totalProfit;
  final int itemCount;
  final List<ItemAnalytics> items;

  CategoryAnalytics({
    required this.categoryName,
    required this.totalQtySold,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.itemCount,
    required this.items,
  });

  double get profitMarginPct =>
      totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0.0;
}

