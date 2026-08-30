import 'package:flutter/material.dart';
import '../data/repositories/order_repository.dart';
import '../models/app_models.dart';
import '../utils/constants.dart';

class ReportProvider extends ChangeNotifier {
  final OrderRepository _orderRepo;

  DailyReport? _report;
  List<ItemAnalytics> _itemAnalytics = [];
  bool _isLoading = false;
  String? _error;
  String _selectedRange = AppConstants.rangeToday;
  DateTime? _customStart;
  DateTime? _customEnd;

  // Item Analytics filtering & sorting
  String _itemSearchQuery = '';
  String _itemSortBy = 'qty'; // 'qty', 'revenue', 'profit', 'margin'

  ReportProvider({required OrderRepository orderRepo}) : _orderRepo = orderRepo;

  DailyReport? get report => _report;
  List<ItemAnalytics> get itemAnalytics => _itemAnalytics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedRange => _selectedRange;
  DateTime? get customStart => _customStart;
  DateTime? get customEnd => _customEnd;
  String get itemSearchQuery => _itemSearchQuery;
  String get itemSortBy => _itemSortBy;

  ({DateTime start, DateTime end}) get dateRange {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (_selectedRange) {
      AppConstants.rangeToday => (start: today, end: today),
      AppConstants.rangeYesterday => (
          start: today.subtract(const Duration(days: 1)),
          end: today.subtract(const Duration(days: 1)),
        ),
      AppConstants.rangeLast7 => (
          start: today.subtract(const Duration(days: 6)),
          end: today,
        ),
      AppConstants.rangeLast30 => (
          start: today.subtract(const Duration(days: 29)),
          end: today,
        ),
      AppConstants.rangeCustom => (
          start: _customStart ?? today,
          end: _customEnd ?? today,
        ),
      _ => (start: today, end: today),
    };
  }

  void setRange(String range) {
    _selectedRange = range;
    notifyListeners();
    loadReport();
  }

  void setCustomRange(DateTime start, DateTime end) {
    _selectedRange = AppConstants.rangeCustom;
    _customStart = start;
    _customEnd = end;
    notifyListeners();
    loadReport();
  }

  void setItemSearchQuery(String query) {
    _itemSearchQuery = query;
    notifyListeners();
  }

  void setItemSortBy(String sortBy) {
    _itemSortBy = sortBy;
    notifyListeners();
  }

  List<ItemAnalytics> get filteredItemAnalytics {
    var list = List<ItemAnalytics>.from(_itemAnalytics);

    if (_itemSearchQuery.isNotEmpty) {
      final q = _itemSearchQuery.toLowerCase();
      list = list.where((i) => i.itemName.toLowerCase().contains(q) || i.categoryName.toLowerCase().contains(q)).toList();
    }

    switch (_itemSortBy) {
      case 'revenue':
        list.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
        break;
      case 'profit':
        list.sort((a, b) => b.totalProfit.compareTo(a.totalProfit));
        break;
      case 'margin':
        list.sort((a, b) => b.profitMarginPct.compareTo(a.profitMarginPct));
        break;
      default: // 'qty'
        list.sort((a, b) => b.totalQtySold.compareTo(a.totalQtySold));
        break;
    }

    return list;
  }

  List<CategoryAnalytics> get categoryAnalytics {
    final Map<String, List<ItemAnalytics>> grouped = {};
    for (final item in _itemAnalytics) {
      grouped.putIfAbsent(item.categoryName, () => []).add(item);
    }

    final List<CategoryAnalytics> list = [];
    for (final entry in grouped.entries) {
      final catName = entry.key;
      final items = entry.value;

      final totalQtySold = items.fold(0, (sum, i) => sum + i.totalQtySold);
      final totalRevenue = items.fold(0.0, (sum, i) => sum + i.totalRevenue);
      final totalCost = items.fold(0.0, (sum, i) => sum + i.totalCost);
      final totalProfit = items.fold(0.0, (sum, i) => sum + i.totalProfit);

      final itemList = List<ItemAnalytics>.from(items)
        ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

      list.add(CategoryAnalytics(
        categoryName: catName,
        totalQtySold: totalQtySold,
        totalRevenue: totalRevenue,
        totalCost: totalCost,
        totalProfit: totalProfit,
        itemCount: items.length,
        items: itemList,
      ));
    }

    list.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
    return list;
  }

  Future<void> loadReport() async {
    _isLoading = true;
    notifyListeners();
    try {
      final range = dateRange;
      final allOrders = await _orderRepo.getOrdersForDateRange(
          range.start, range.end);

      // Exclude cancelled orders from all report calculations
      final orders = allOrders
          .where((o) => o.orderStatus != AppConstants.statusCancelled)
          .toList();

      final bySource = <String, SourceStats>{};
      double totalRevenue = 0;

      for (final o in orders) {
        final isStaff = o.orderSource == AppConstants.sourceStaff ||
            o.paymentMethod == AppConstants.paymentStaff;

        final revenueContrib = isStaff ? 0.0 : o.finalTotal;
        totalRevenue += revenueContrib;

        final existing = bySource[o.orderSource];
        bySource[o.orderSource] = SourceStats(
          source: o.orderSource,
          orderCount: (existing?.orderCount ?? 0) + 1,
          grossRevenue: (existing?.grossRevenue ?? 0) + revenueContrib,
          platformFees: 0,
          netRevenue: (existing?.netRevenue ?? 0) + revenueContrib,
        );
      }

      _report = DailyReport(
        date: range.start,
        totalOrders: orders.length,
        totalRevenue: totalRevenue,
        netEarnings: totalRevenue,
        totalPlatformFees: 0,
        bySource: bySource,
        totalItemsMade: 0,
        totalItemsSold: 0,
        totalWastage: 0,
      );

      // Load item detailed analytics
      _itemAnalytics = await _orderRepo.getItemAnalytics(range.start, range.end);
      _error = null;
    } catch (e) {
      _error = 'Failed to load report: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<MapEntry<String, int>>> getTopItems({int limit = 5}) async {
    final range = dateRange;
    return await _orderRepo.getTopItems(range.start, range.end, limit: limit);
  }
}
