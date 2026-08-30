import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/app_database.dart';
import '../../data/db_types.dart';
import '../../models/app_models.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';

class ItemSelectorPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ItemSelectorPage({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ItemSelectorPage> createState() => _ItemSelectorPageState();
}

class _ItemSelectorPageState extends State<ItemSelectorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _showSearch = false;
  Map<int, int> _remainingQty = {};

  @override
  void initState() {
    super.initState();
    final menuProvider = context.read<MenuProvider>();
    _tabController = TabController(
      length: menuProvider.categories.length + 2, // All + Best Sellers + categories
      vsync: this,
    );
    _loadStockInfo();
  }

  Future<void> _loadStockInfo() async {
    final inventory = context.read<InventoryProvider>();
    final items = context.read<MenuProvider>().items;
    final Map<int, int> qty = {};
    for (final item in items) {
      qty[item.id] = await inventory.getRemainingQty(item.id);
    }
    if (mounted) setState(() => _remainingQty = qty);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final theme = Theme.of(context);
    final categories = menuProvider.categories;

    return Column(
      children: [
        // Header with search
        Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              // Cart summary bar
              if (orderProvider.cartItemCount > 0)
                Container(
                  color: AppColors.primary.withOpacity(0.1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${orderProvider.cartItemCount} items',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppFormatters.currency(orderProvider.cartSubtotal),
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

              // Search bar or category tabs
              if (_showSearch)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() => _showSearch = false);
                          _searchController.clear();
                          context.read<MenuProvider>().setSearchQuery('');
                        },
                      ),
                    ),
                    onChanged: (q) =>
                        context.read<MenuProvider>().setSearchQuery(q),
                  ),
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: AppColors.primary,
                            unselectedLabelColor:
                                theme.colorScheme.onSurface.withOpacity(0.5),
                            indicatorColor: AppColors.primary,
                            tabs: [
                              const Tab(text: 'All'),
                              const Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                                    SizedBox(width: 4),
                                    Text('Best Sellers'),
                                  ],
                                ),
                              ),
                               ...categories
                                  .map((Category c) => Tab(text: c.name))
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, size: 20),
                          onPressed: () => setState(() => _showSearch = true),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Items list
        Expanded(
          child: _showSearch
              ? _buildSearchResults(
                  menuProvider.filteredItems, orderProvider, theme)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // "All" tab
                    _buildItemList(
                        menuProvider.items, orderProvider, theme),
                    // "Best Sellers" tab
                    _buildItemList(
                        menuProvider.bestSellerItems, orderProvider, theme),
                    // Category tabs
                    ...categories.map((Category cat) => _buildItemList(
                        menuProvider.itemsByCategory(cat.id),
                        orderProvider,
                        theme)),
                  ],
                ),
        ),

        // Bottom: Next button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('← Back'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: orderProvider.cartItems.isNotEmpty
                      ? widget.onNext
                      : null,
                  child: Text(
                    'Checkout (${orderProvider.cartItemCount} items)',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemList(
      List<Item> items, OrderProvider orderProvider, ThemeData theme) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.restaurant_menu_outlined,
        title: 'No items',
        subtitle: 'Add items from Menu settings',
      );
    }
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (_, i) =>
          _ItemTile(item: items[i], remainingQty: _remainingQty[items[i].id]),
    );
  }

  Widget _buildSearchResults(
      List<Item> items, OrderProvider orderProvider, ThemeData theme) {
    return _buildItemList(items, orderProvider, theme);
  }
}

class _ItemTile extends StatelessWidget {
  final Item item;
  final int? remainingQty;

  const _ItemTile({required this.item, this.remainingQty});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final theme = Theme.of(context);
    final qty = orderProvider.getCartQty(item.id);
    final remaining = remainingQty ?? 999;
    final isOutOfStock = remaining == 0 && (remainingQty != null);
    final isLow = remaining <= item.lowStockThreshold && remaining > 0 && remainingQty != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                item.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isOutOfStock
                                      ? theme.colorScheme.onSurface.withOpacity(0.3)
                                      : null,
                                ),
                              ),
                            ),
                            if (item.isBestSeller)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Color(0xFFF59E0B),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isOutOfStock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.outOfStock.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'OUT',
                            style: TextStyle(
                              color: AppColors.outOfStock,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        AppFormatters.currency(item.sellingPrice),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (remainingQty != null && remaining < 999) ...[
                        const SizedBox(width: 8),
                        Text(
                          isOutOfStock
                              ? 'Out of stock'
                              : '$remaining left${isLow ? ' ⚠️' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isOutOfStock
                                ? AppColors.outOfStock
                                : isLow
                                    ? AppColors.lowStock
                                    : AppColors.inStock,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Quantity stepper
            if (!isOutOfStock) ...[
              if (qty == 0)
                ElevatedButton(
                  onPressed: () => context.read<OrderProvider>().addItemToCart(
                        CartItem(
                          itemId: item.id,
                          itemName: item.name,
                          price: item.sellingPrice,
                          availableQty: remaining,
                        ),
                      ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(60, 34),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: const Text('Add'),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepperBtn(
                      icon: Icons.remove,
                      onTap: () => context
                          .read<OrderProvider>()
                          .removeItemFromCart(item.id),
                    ),
                    Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: Text(
                        '$qty',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _StepperBtn(
                      icon: Icons.add,
                      onTap: remaining > qty
                          ? () => context
                              .read<OrderProvider>()
                              .addItemToCart(
                                CartItem(
                                  itemId: item.id,
                                  itemName: item.name,
                                  price: item.sellingPrice,
                                  availableQty: remaining,
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: onTap != null
                ? AppColors.primary.withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null
              ? AppColors.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
      ),
    );
  }
}
