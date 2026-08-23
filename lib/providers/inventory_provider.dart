import 'package:flutter/material.dart';
import '../data/db_types.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/menu_repository.dart';
import '../models/app_models.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryRepository _inventoryRepo;
  final MenuRepository _menuRepo;

  List<InventoryStatus> _inventoryStatus = [];
  List<MorningSetupEntry> _morningSetup = [];
  bool _isLoading = false;
  String? _error;
  String _sortBy = 'name'; // 'name', 'utilization', 'remaining', 'category'

  InventoryProvider({
    required InventoryRepository inventoryRepo,
    required MenuRepository menuRepo,
  })  : _inventoryRepo = inventoryRepo,
        _menuRepo = menuRepo;

  List<InventoryStatus> get inventoryStatus => _sortedStatus;
  List<MorningSetupEntry> get morningSetup => _morningSetup;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get sortBy => _sortBy;

  int get outOfStockCount =>
      _inventoryStatus.where((i) => i.isOutOfStock).length;
  int get lowStockCount =>
      _inventoryStatus.where((i) => i.isLowStock).length;
  int get totalAlertCount => outOfStockCount + lowStockCount;

  List<InventoryStatus> get outOfStockItems =>
      _inventoryStatus.where((i) => i.isOutOfStock).toList();
  List<InventoryStatus> get lowStockItems =>
      _inventoryStatus.where((i) => i.isLowStock).toList();

  int get totalMade =>
      _inventoryStatus.fold(0, (sum, i) => sum + i.madeQty);
  int get totalSold =>
      _inventoryStatus.fold(0, (sum, i) => sum + i.soldQty);
  int get totalWasted =>
      _inventoryStatus.fold(0, (sum, i) => sum + i.wastedQty);
  double get avgUtilization {
    final items = _inventoryStatus.where((i) => i.madeQty > 0).toList();
    if (items.isEmpty) return 0;
    return items.fold(0.0, (sum, i) => sum + i.utilizationPct) / items.length;
  }

  List<InventoryStatus> get _sortedStatus {
    final list = List<InventoryStatus>.from(_inventoryStatus);
    switch (_sortBy) {
      case 'utilization':
        list.sort((a, b) => b.utilizationPct.compareTo(a.utilizationPct));
        break;
      case 'remaining':
        list.sort((a, b) => a.remainingQty.compareTo(b.remainingQty));
        break;
      case 'category':
        list.sort((a, b) => a.categoryName.compareTo(b.categoryName));
        break;
      default:
        list.sort((a, b) => a.itemName.compareTo(b.itemName));
    }
    return list;
  }

  Future<void> loadInventoryStatus() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventoryStatus = await _inventoryRepo.getTodayInventoryStatus();
      _error = null;
    } catch (e) {
      _error = 'Failed to load inventory: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  // ── Morning Setup ────────────────────────────────────────────────

  Future<void> loadMorningSetup() async {
    _isLoading = true;
    notifyListeners();
    try {
      final items = await _menuRepo.getAllItems();
      final categories = await _menuRepo.getAllCategories();
      final catMap = {for (final c in categories) c.id: c.name};
      final yesterday = await _inventoryRepo.getYesterdayInventory();
      final yesterdayMap = {for (final y in yesterday) y.itemId: y.madeQty};

      _morningSetup = items.map((Item item) {
        return MorningSetupEntry(
          itemId: item.id,
          itemName: item.name,
          categoryName: catMap[item.categoryId] ?? 'Unknown',
          madeQty: 0,
          yesterdayMadeQty: yesterdayMap[item.id],
        );
      }).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load morning setup: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateMorningEntry(int itemId, int qty) {
    final idx = _morningSetup.indexWhere((e) => e.itemId == itemId);
    if (idx >= 0) {
      _morningSetup[idx].madeQty = qty;
      notifyListeners();
    }
  }

  void copyYesterday() {
    for (final entry in _morningSetup) {
      if (entry.yesterdayMadeQty != null) {
        entry.madeQty = entry.yesterdayMadeQty!;
      }
    }
    notifyListeners();
  }

  Future<void> saveAndStartDay() async {
    _isLoading = true;
    notifyListeners();
    try {
      for (final entry in _morningSetup) {
        if (entry.madeQty > 0) {
          await _inventoryRepo.upsertInventory(entry.itemId, entry.madeQty);
        }
      }
      await loadInventoryStatus();
      _error = null;
    } catch (e) {
      _error = 'Failed to save inventory: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWastedQty(int itemId, int qty, {String? reason}) async {
    try {
      await _inventoryRepo.updateWastedQty(itemId, qty, reason: reason);
      await loadInventoryStatus();
    } catch (e) {
      _error = 'Failed to update wasted qty: $e';
      notifyListeners();
    }
  }

  /// Check remaining qty for an item (used during order creation)
  Future<int> getRemainingQty(int itemId) async {
    return await _inventoryRepo.getRemainingQty(itemId);
  }
}
