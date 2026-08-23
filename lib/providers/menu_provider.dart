import 'package:flutter/material.dart';
import '../data/database/app_database.dart';
import '../data/db_types.dart';
import '../data/repositories/menu_repository.dart';

class MenuProvider extends ChangeNotifier {
  final MenuRepository _repo;

  List<Category> _categories = [];
  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;
  int? _selectedCategoryId;
  String _searchQuery = '';

  MenuProvider(this._repo);

  List<Category> get categories => _categories;
  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  List<Item> get filteredItems {
    var filtered = _items;
    if (_selectedCategoryId != null) {
      filtered = filtered.where((Item i) => i.categoryId == _selectedCategoryId).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((Item i) => i.name.toLowerCase().contains(q)).toList();
    }
    return filtered;
  }

  List<Item> itemsByCategory(int categoryId) =>
      _items.where((Item i) => i.categoryId == categoryId).toList();

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _repo.getAllCategories();
      _items = await _repo.getAllItems(includeUnavailable: true);
      _error = null;
    } catch (e) {
      _error = 'Failed to load menu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addCategory(String name, {String colorHex = '#4F46E5'}) async {
    await _repo.addCategory(name, colorHex: colorHex);
    await loadAll();
  }

  Future<void> updateCategory(int id, String name, String colorHex) async {
    await _repo.updateCategory(id, name, colorHex);
    await loadAll();
  }

  Future<void> deleteCategory(int id) async {
    await _repo.deleteCategory(id);
    await loadAll();
  }

  Future<void> addItem(ItemsTableCompanion item) async {
    await _repo.addItem(item);
    await loadAll();
  }

  Future<void> updateItem(int id, ItemsTableCompanion companion) async {
    await _repo.updateItem(id, companion);
    await loadAll();
  }

  Future<void> toggleItemAvailability(int id, bool isAvailable) async {
    await _repo.toggleItemAvailability(id, isAvailable);
    // Optimistic update
    final idx = _items.indexWhere((Item i) => i.id == id);
    if (idx != -1) {
      _items = List.from(_items);
      notifyListeners();
    }
    await loadAll();
  }

  Future<void> deleteItem(int id) async {
    await _repo.deleteItem(id);
    await loadAll();
  }

  Future<List<Item>> searchItems(String query) async {
    return await _repo.searchItems(query);
  }
}
