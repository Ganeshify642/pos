import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../data/db_types.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/mock_data_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_image_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _tabController.index == 0
                  ? _showCategoryForm(context)
                  : _showItemForm(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5722),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x4DFF5722),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Custom Segmented Tab Bar ──────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildTabButton(
                      index: 0,
                      title: 'Categories',
                      icon: Icons.grid_view_rounded,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildTabButton(
                      index: 1,
                      title: 'Items',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // ── Tab Views ────────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CategoriesTab(
                  onAddCategory: () => _showCategoryForm(context),
                  onEditCategory: (cat) => _showCategoryForm(context, cat),
                  onEditItem: (item) => _showItemForm(context, item),
                ),
                _ItemsTab(
                  onAddItem: () => _showItemForm(context),
                  onEditItem: (item) => _showItemForm(context, item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFFE2E8F0), width: 1) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFFFF5722) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFFFF5722) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryForm(BuildContext context, [Category? category]) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final isEdit = category != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(_).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit Category' : 'Add Category',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(_),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: const TextStyle(color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFF5722), width: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    if (isEdit) {
                      context.read<MenuProvider>().updateCategory(
                            category.id,
                            nameController.text.trim(),
                            category.colorHex,
                          );
                    } else {
                      context
                          .read<MenuProvider>()
                          .addCategory(nameController.text.trim());
                    }
                    Navigator.pop(_);
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? 'Save Changes' : 'Add Category',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemForm(BuildContext context, [Item? item]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ItemForm(item: item),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ── CATEGORIES TAB ───────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesTab extends StatefulWidget {
  final VoidCallback onAddCategory;
  final Function(Category) onEditCategory;
  final Function(Item) onEditItem;

  const _CategoriesTab({
    required this.onAddCategory,
    required this.onEditCategory,
    required this.onEditItem,
  });

  @override
  State<_CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<_CategoriesTab> {
  final Set<int> _expandedCategoryIds = {};

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final categories = menuProvider.categories;

    if (categories.isEmpty) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: 'No Categories',
        subtitle: 'Add your first menu category or load demo Vadapav menu',
        actionLabel: '+ Add Category',
        onAction: widget.onAddCategory,
        secondaryActionLabel: 'Load Demo Menu',
        onSecondaryAction: () async {
          final db = context.read<AppDatabase>();
          await MockDataService.loadVadapavMockData(db);
          if (context.mounted) {
            await context.read<SettingsProvider>().loadSettings();
            await context.read<MenuProvider>().loadAll();
            await context.read<InventoryProvider>().loadInventoryStatus();
            await context.read<OrderProvider>().loadOrders();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Demo Menu loaded successfully!'),
                backgroundColor: AppColors.inStock,
              ),
            );
          }
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: categories.length,
      itemBuilder: (ctx, i) {
        final cat = categories[i];
        final categoryItems = menuProvider.itemsByCategory(cat.id);
        final isExpanded = _expandedCategoryIds.contains(cat.id);
        final style = _getCategoryStyle(cat.name);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExpanded ? const Color(0xFF6EE7B7) : const Color(0xFFE2E8F0),
              width: isExpanded ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Category Header Row
              InkWell(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedCategoryIds.remove(cat.id);
                    } else {
                      _expandedCategoryIds.add(cat.id);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      // Category Icon Circle
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: style.bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(style.icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      // Category Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${categoryItems.length} items',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Actions: Edit, Delete, Expand
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFFFF7043)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () => widget.onEditCategory(cat),
                        tooltip: 'Edit Category',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF5350)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () => _confirmDeleteCategory(context, cat),
                        tooltip: 'Delete Category',
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.chevron_right_rounded,
                        color: const Color(0xFF64748B),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded Item List
              if (isExpanded) ...[
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                if (categoryItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No items in this category yet',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: categoryItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (ctx, idx) {
                      final item = categoryItems[idx];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Row(
                          children: [
                            // Item Thumbnail
                            ItemImageWidget(
                              imageUrl: item.imageUrl,
                              width: 40,
                              height: 40,
                              borderRadius: BorderRadius.circular(8),
                              placeholder: _buildItemPlaceholder(item),
                            ),
                            const SizedBox(width: 12),
                            // Name & Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '₹${item.sellingPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Best Seller Star Toggle
                            IconButton(
                              icon: Icon(
                                item.isBestSeller
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 22,
                                color: item.isBestSeller
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFFCBD5E1),
                              ),
                              onPressed: () => context
                                  .read<MenuProvider>()
                                  .toggleBestSeller(item.id, !item.isBestSeller),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              tooltip: item.isBestSeller ? 'Remove Best Seller' : 'Mark as Best Seller',
                            ),
                            // Active Toggle Switch
                            Transform.scale(
                              scale: 0.75,
                              child: Switch.adaptive(
                                value: item.isAvailable,
                                activeColor: const Color(0xFF10B981),
                                onChanged: (v) => context
                                    .read<MenuProvider>()
                                    .toggleItemAvailability(item.id, v),
                              ),
                            ),
                            // Edit
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFFFF7043)),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              onPressed: () => widget.onEditItem(item),
                            ),
                            // Delete
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF5350)),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              onPressed: () => _confirmDeleteItem(context, item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 6),
              ],
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteCategory(BuildContext context, Category cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Category?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${cat.name}"? Items inside will remain uncategorized.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              context.read<MenuProvider>().deleteCategory(cat.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteItem(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Item?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${item.name}" from the menu?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              context.read<MenuProvider>().deleteItem(item.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ── ITEMS TAB ────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────

class _ItemsTab extends StatefulWidget {
  final VoidCallback onAddItem;
  final Function(Item) onEditItem;
  const _ItemsTab({required this.onAddItem, required this.onEditItem});

  @override
  State<_ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<_ItemsTab> {
  final _searchController = TextEditingController();
  int? _filterCategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final allItems = menuProvider.items;
    final categories = menuProvider.categories;

    var filteredItems = menuProvider.filteredItems;
    if (_filterCategoryId != null) {
      filteredItems = filteredItems.where((i) => i.categoryId == _filterCategoryId).toList();
    }

    final totalCount = allItems.length;
    final activeCount = allItems.where((i) => i.isAvailable).length;
    final inactiveCount = totalCount - activeCount;

    if (allItems.isEmpty) {
      return EmptyState(
        icon: Icons.restaurant_menu_outlined,
        title: 'No Menu Items',
        subtitle: 'Add your first menu item or load sample demo menu',
        actionLabel: '+ Add Item',
        onAction: widget.onAddItem,
        secondaryActionLabel: 'Load Demo Menu',
        onSecondaryAction: () async {
          final db = context.read<AppDatabase>();
          await MockDataService.loadVadapavMockData(db);
          if (context.mounted) {
            await context.read<SettingsProvider>().loadSettings();
            await context.read<MenuProvider>().loadAll();
            await context.read<InventoryProvider>().loadInventoryStatus();
            await context.read<OrderProvider>().loadOrders();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Demo Menu loaded successfully!'),
                backgroundColor: AppColors.inStock,
              ),
            );
          }
        },
      );
    }

    return Column(
      children: [
        // ── Search & Filter Bar ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (q) => context.read<MenuProvider>().setSearchQuery(q),
                    style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                              onPressed: () {
                                _searchController.clear();
                                context.read<MenuProvider>().setSearchQuery('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFFF5722), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Filter Category Button
              PopupMenuButton<int?>(
                tooltip: 'Filter by category',
                initialValue: _filterCategoryId,
                onSelected: (id) => setState(() => _filterCategoryId = id),
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: null, child: Text('All Categories')),
                  ...categories.map(
                    (c) => PopupMenuItem(value: c.id, child: Text(c.name)),
                  ),
                ],
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _filterCategoryId != null ? const Color(0xFFFFF0ED) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _filterCategoryId != null ? const Color(0xFFFF5722) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: _filterCategoryId != null ? const Color(0xFFFF5722) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Item List ────────────────────────────────────────────────────────
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(
                  child: Text(
                    'No items found',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final item = filteredItems[i];
                    final catName = categories
                            .where((Category c) => c.id == item.categoryId)
                            .map((Category c) => c.name)
                            .firstOrNull ??
                        '';

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Reorder / Drag Grip dots icon
                          const Icon(
                            Icons.drag_indicator_rounded,
                            size: 18,
                            color: Color(0xFFCBD5E1),
                          ),
                          const SizedBox(width: 6),
                          // Food Thumbnail
                          ItemImageWidget(
                            imageUrl: item.imageUrl,
                            width: 44,
                            height: 44,
                            borderRadius: BorderRadius.circular(10),
                            placeholder: _buildItemPlaceholder(item),
                          ),
                          const SizedBox(width: 12),
                          // Item Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${item.sellingPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                                if (catName.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    catName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Best Seller Star Toggle
                          IconButton(
                            icon: Icon(
                              item.isBestSeller
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 22,
                              color: item.isBestSeller
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFCBD5E1),
                            ),
                            onPressed: () => context
                                .read<MenuProvider>()
                                .toggleBestSeller(item.id, !item.isBestSeller),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            tooltip: item.isBestSeller ? 'Remove Best Seller' : 'Mark as Best Seller',
                          ),
                          // Active Switch
                          Transform.scale(
                            scale: 0.75,
                            child: Switch.adaptive(
                              value: item.isAvailable,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (v) => context
                                  .read<MenuProvider>()
                                  .toggleItemAvailability(item.id, v),
                            ),
                          ),
                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFFFF7043)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            onPressed: () => widget.onEditItem(item),
                          ),
                          // Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF5350)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            onPressed: () => _confirmDeleteItem(context, item),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // ── Summary Status Footer ───────────────────────────────────────────
        Container(
          margin: const EdgeInsets.fromLTRB(16, 6, 16, 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
              const SizedBox(width: 8),
              Text(
                '$totalCount items   •   $activeCount active   •   $inactiveCount inactive',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF065F46),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDeleteItem(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Item?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${item.name}" from the menu?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              context.read<MenuProvider>().deleteItem(item.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ── ITEM ADD / EDIT FORM MODAL ──────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────

class _ItemForm extends StatefulWidget {
  final Item? item;
  const _ItemForm({this.item});

  @override
  State<_ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<_ItemForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  int? _selectedCategoryId;
  String? _imagePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _priceController.text = '${widget.item!.sellingPrice}';
      _descController.text = widget.item!.description;
      _selectedCategoryId = widget.item!.categoryId;
      _imagePath = widget.item!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (xFile != null && mounted) {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/item_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final fileName = 'item_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(xFile.path).copy('${imagesDir.path}/$fileName');
      setState(() => _imagePath = savedImage.path);
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(_);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(_);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(_);
                  setState(() => _imagePath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final isEdit = widget.item != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit Item' : 'Add Item',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Image Picker Box
            Center(
              child: GestureDetector(
                onTap: _showImageSourcePicker,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFCCBC), width: 1.2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _imagePath != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(File(_imagePath!), fit: BoxFit.cover),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.edit, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu_rounded, size: 30, color: Color(0xFFFF5722)),
                            SizedBox(height: 4),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF5722),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: _inputDecoration('Item Name *'),
              autofocus: !isEdit,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: _inputDecoration('Category *'),
              items: menuProvider.categories
                  .map((Category c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(c.name, style: const TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategoryId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: _inputDecoration('Selling Price ₹ *', prefix: '₹ '),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: _inputDecoration('Description (Optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty || _selectedCategoryId == null) {
                    return;
                  }
                  final companion = ItemsTableCompanion(
                    categoryId: Value(_selectedCategoryId!),
                    name: Value(_nameController.text.trim()),
                    sellingPrice: Value(double.tryParse(_priceController.text) ?? 0),
                    description: Value(_descController.text),
                    imageUrl: Value(_imagePath),
                  );
                  if (isEdit) {
                    context.read<MenuProvider>().updateItem(widget.item!.id, companion);
                  } else {
                    context.read<MenuProvider>().addItem(companion);
                  }
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? 'Save Changes' : 'Add Item',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      prefixText: prefix,
      prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF5722), width: 1.5),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ── HELPER UTILS & ICONS ─────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildItemPlaceholder(Item item) {
  return Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF0ED),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(
      Icons.restaurant_menu_rounded,
      color: Color(0xFFFF5722),
      size: 22,
    ),
  );
}

class _CategoryVisual {
  final Color bgColor;
  final IconData icon;
  const _CategoryVisual(this.bgColor, this.icon);
}

_CategoryVisual _getCategoryStyle(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('patti')) {
    return const _CategoryVisual(Color(0xFFEA580C), Icons.lunch_dining_rounded);
  } else if (lower.contains('puf')) {
    return const _CategoryVisual(Color(0xFFEAB308), Icons.local_pizza_rounded);
  } else if (lower.contains('roll')) {
    return const _CategoryVisual(Color(0xFFEF4444), Icons.breakfast_dining_rounded);
  } else if (lower.contains('ચટણી') || lower.contains('chat')) {
    return const _CategoryVisual(Color(0xFF0D9488), Icons.soup_kitchen_rounded);
  } else if (lower.contains('છાશ') || lower.contains('chaash')) {
    return const _CategoryVisual(Color(0xFF059669), Icons.local_drink_rounded);
  } else if (lower.contains('પીણાં') || lower.contains('drink') || lower.contains('beverage')) {
    return const _CategoryVisual(Color(0xFF8B5CF6), Icons.local_cafe_rounded);
  } else if (lower.contains('મમરી') || lower.contains('mamri')) {
    return const _CategoryVisual(Color(0xFF2563EB), Icons.dinner_dining_rounded);
  } else if (lower.contains('વડા') || lower.contains('vada')) {
    return const _CategoryVisual(Color(0xFFF43F5E), Icons.local_offer_rounded);
  }
  return const _CategoryVisual(Color(0xFFFF5722), Icons.fastfood_rounded);
}
