import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db_types.dart';
import '../../models/app_models.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/printer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/mock_data_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_image_widget.dart';
import '../invoice_preview_screen.dart';
import '../menu/menu_screen.dart';
import 'checkout_page.dart';

class CreateOrderScreen extends StatefulWidget {
  final bool isTabInHome;
  const CreateOrderScreen({super.key, this.isTabInHome = false});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  // -1 =  Items (virtual, shows all items with s first)
  // null = All items (no filter)
  // positive int = specific category
  int? _selectedCategoryId = -1;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    final orderProvider = context.read<OrderProvider>();
    final settings = context.read<SettingsProvider>();

    if (orderProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item to cart')),
      );
      return;
    }

    if (settings.taxSettings == null || settings.businessSettings == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings not loaded. Please try again.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final summary = await orderProvider.submitOrder(
      taxSettings: settings.taxSettings!,
      businessSettings: settings.businessSettings!,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (summary != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => InvoicePreviewScreen(
          orderId: summary.order.id,
          invoicePath: summary.order.invoicePath,
          autoPrint: true,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'Failed to create order'),
          backgroundColor: AppColors.outOfStock,
        ),
      );
    }
  }

  void _openCheckoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: CheckoutPage(
                onBack: () => Navigator.of(ctx).pop(),
                onSubmit: () async {
                  Navigator.of(ctx).pop();
                  await _submitOrder();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black87),
        //   onPressed: () {
        //     if (Navigator.of(context).canPop()) {
        //       Navigator.of(context).pop();
        //     }
        //   },
        // ),
        title: const Text(
          'New Sale',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.receipt_long_outlined, color: Colors.black87),
            tooltip: 'View Orders List',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              );
            },
          ),
        ],
      ),
      body: isTablet
          ? Row(
              children: [
                Expanded(
                  flex: 65,
                  child: Column(
                    children: [
                      _buildSearchBar(context),
                      _buildCategoryFilter(context),
                      const SizedBox(height: 8),
                      Expanded(child: _buildItemCatalog(context)),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  flex: 35,
                  child: _buildTabletCartPanel(context),
                ),
              ],
            )
          : Stack(
              children: [
                Column(
                  children: [
                    // Search & Scan Bar
                    _buildSearchBar(context),

                    // Horizontal Category Filters
                    _buildCategoryFilter(context),

                    const SizedBox(height: 8),

                    // Product Grid
                    Expanded(child: _buildItemCatalog(context)),
                  ],
                ),

                // Floating Cart Bottom Banner
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildFloatingCartBanner(context),
                ),
              ],
            ),
    );
  }

  // ── Search Header ─────────────────────────────────────────────────────────

  Widget _buildSearchBar(BuildContext context) {
    final op = context.watch<OrderProvider>();
    final isStaff = op.selectedSource == AppConstants.sourceStaff;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isStaff
                      ? const Color(0xFF7C3AED).withValues(alpha: 0.5)
                      : const Color(0xFFE5E7EB),
                  width: isStaff ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: Colors.grey.shade600, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 14),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Staff Mode Toggle Button on Item Selector Screen
          InkWell(
            onTap: () {
              if (isStaff) {
                op.setOrderSource(AppConstants.sourceCounter);
                op.setPaymentMethod(AppConstants.paymentCash);
              } else {
                op.setOrderSource(AppConstants.sourceStaff);
                op.setPaymentMethod(AppConstants.paymentStaff);
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isStaff ? const Color(0xFF7C3AED) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isStaff
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFFE5E7EB),
                  width: 1.5,
                ),
                boxShadow: isStaff
                    ? [
                        BoxShadow(
                          color:
                              const Color(0xFF7C3AED).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isStaff ? Icons.badge : Icons.badge_outlined,
                    color: isStaff ? Colors.white : const Color(0xFF7C3AED),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Staff',
                    style: TextStyle(
                      color: isStaff ? Colors.white : const Color(0xFF7C3AED),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Chips ─────────────────────────────────────────────────────────

  Widget _buildCategoryFilter(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final categories = menuProvider.categories;

    return Container(
      color: Colors.white,
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          //  Items - always first, acts as virtual "all with s first"
          _buildCategoryPill(
            title: ' Items',
            isSelected: _selectedCategoryId == -1,
            onTap: () => setState(() => _selectedCategoryId = -1),
          ),
          const SizedBox(width: 8),
          _buildCategoryPill(
            title: 'All',
            isSelected: _selectedCategoryId == null,
            onTap: () => setState(() => _selectedCategoryId = null),
          ),
          const SizedBox(width: 8),
          ...categories.where((cat) => cat.name != ' Items').map((cat) {
            final isSel = _selectedCategoryId == cat.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryPill(
                title: cat.name,
                isSelected: isSel,
                onTap: () => setState(() => _selectedCategoryId = cat.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryPill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4500) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFFF4500) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ── Items Grid ─────────────────────────────────────────────────────────────

  Widget _buildItemCatalog(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final orderProvider = context.watch<OrderProvider>();

    var items = menuProvider.items;

    if (_selectedCategoryId == -1) {
      //  Items: show ALL items, but sort s to top
      items = List<Item>.from(items);
      items.sort((a, b) {
        final aIsBest = a.name.contains('') ? 0 : 1;
        final bIsBest = b.name.contains('') ? 0 : 1;
        return aIsBest.compareTo(bIsBest);
      });
    } else if (_selectedCategoryId != null) {
      items = items.where((i) => i.categoryId == _selectedCategoryId).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items.where((i) => i.name.toLowerCase().contains(q)).toList();
    }

    if (menuProvider.items.isEmpty) {
      return EmptyState(
        icon: Icons.fastfood_outlined,
        title: 'No Products Available',
        subtitle: 'Load sample items or add menu items to get started.',
        actionLabel: '+ Add Product to Menu',
        onAction: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MenuScreen()),
        ),
        secondaryActionLabel: 'Load Sample Menu',
        onSecondaryAction: () async {
          final db = context.read<AppDatabase>();
          await MockDataService.loadVadapavMockData(db);
          if (context.mounted) {
            await context.read<SettingsProvider>().loadSettings();
            if (context.mounted) await context.read<MenuProvider>().loadAll();
            if (context.mounted)
              await context.read<InventoryProvider>().loadInventoryStatus();
            if (context.mounted)
              await context.read<OrderProvider>().loadOrders();
          }
        },
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No matching products found',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 500 ? 3 : 2;
        final childAspectRatio = width >= 500 ? 0.72 : 0.74;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final item = items[idx];
            final qty = orderProvider.getCartQty(item.id);
            return ProductGridCard(
              item: item,
              quantity: qty,
              onAdd: () {
                orderProvider.addItemToCart(CartItem(
                  itemId: item.id,
                  itemName: item.name,
                  price: item.sellingPrice,
                ));
              },
              onRemove: () {
                orderProvider.removeItemFromCart(item.id);
              },
              onSetQuantity: () {
                _showQuantityDialog(
                  context,
                  itemName: item.name,
                  initialQty: qty,
                  onConfirm: (newQty) {
                    orderProvider.setItemQuantity(
                      item.id,
                      newQty,
                      itemTemplate: CartItem(
                        itemId: item.id,
                        itemName: item.name,
                        price: item.sellingPrice,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Floating Bottom Cart Banner ────────────────────────────────────────────

  Widget _buildFloatingCartBanner(BuildContext context) {
    final op = context.watch<OrderProvider>();
    final isStaff = op.selectedSource == AppConstants.sourceStaff;

    if (op.cartItemCount == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shopping Cart / Staff Icon Container with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isStaff
                      ? const Color(0xFF7C3AED).withValues(alpha: 0.12)
                      : const Color(0xFFFFECE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isStaff ? Icons.badge : Icons.shopping_cart_outlined,
                  color: isStaff
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFFFF4500),
                  size: 22,
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isStaff
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${op.cartItemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Items and Total Price Stack
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '${op.cartItemCount} items',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  if (isStaff) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'STAFF',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                AppFormatters.currency(op.cartSubtotal),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isStaff ? const Color(0xFF7C3AED) : Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Clear / Cancel Cart Icon Button
          InkWell(
            onTap: () => op.clearCart(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black54,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // More / Options Button (Discount, Custom breakdown)
          InkWell(
            onTap: () => _openCheckoutSheet(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.black54,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Direct 1-Tap Checkout & Print Button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isStaff ? const Color(0xFF7C3AED) : const Color(0xFFFF4500),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isStaff
                            ? Icons.check_circle_outline
                            : Icons.print_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isStaff ? 'Save Staff' : 'Print Bill',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ── Tablet Split Panel Cart ───────────────────────────────────────────────

  Widget _buildTabletCartPanel(BuildContext context) {
    final theme = Theme.of(context);
    final op = context.watch<OrderProvider>();
    final isStaff = op.selectedSource == AppConstants.sourceStaff;

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: (isStaff ? const Color(0xFF7C3AED) : const Color(0xFFFF4500))
                .withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(
                  isStaff ? Icons.badge : Icons.shopping_cart,
                  color: isStaff
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFFFF4500),
                ),
                const SizedBox(width: 8),
                Text(
                  isStaff ? 'Staff Order' : 'Current Order',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isStaff ? const Color(0xFF7C3AED) : null,
                  ),
                ),
                const Spacer(),
                if (op.cartItems.isNotEmpty)
                  TextButton(
                    onPressed: () => op.clearCart(),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: AppColors.outOfStock),
                    ),
                  ),
              ],
            ),
          ),
          // Order Type Selector on Tablet Panel
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <String>[
                  AppConstants.sourceCounter,
                  AppConstants.sourceDineIn,
                  AppConstants.sourceTakeaway,
                  AppConstants.sourceDelivery,
                  AppConstants.sourceStaff,
                ].map((String source) {
                  final isSel = op.selectedSource == source;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(source, style: const TextStyle(fontSize: 12)),
                      selected: isSel,
                      selectedColor: source == AppConstants.sourceStaff
                          ? const Color(0xFF7C3AED)
                          : AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : Colors.black87,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        op.setOrderSource(source);
                        if (source == AppConstants.sourceStaff) {
                          op.setPaymentMethod(AppConstants.paymentStaff);
                        } else {
                          op.setPaymentMethod(AppConstants.paymentCash);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: op.cartItems.isEmpty
                ? const Center(
                    child: Text('Cart is empty. Select items to add.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: op.cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final item = op.cartItems[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${AppFormatters.currency(item.price)} each',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      size: 20),
                                  onPressed: () =>
                                      op.removeItemFromCart(item.itemId),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      size: 20),
                                  onPressed: () => op.addItemToCart(item),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppFormatters.currency(item.lineTotal),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text(
                      AppFormatters.currency(op.cartSubtotal),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: op.cartItems.isEmpty || _isSubmitting
                        ? null
                        : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isStaff
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFFFF4500),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isStaff
                                    ? Icons.check_circle_outline
                                    : Icons.print_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isStaff
                                    ? 'Save Staff Order'
                                    : 'Print & Save Bill →',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quantity Dialog ─────────────────────────────────────────────────────────

Future<void> _showQuantityDialog(
  BuildContext context, {
  required String itemName,
  required int initialQty,
  required ValueChanged<int> onConfirm,
}) async {
  final controller =
      TextEditingController(text: initialQty > 0 ? '$initialQty' : '1');
  final result = await showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Set Item Quantity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              hintText: 'Enter quantity e.g. 10',
              prefixIcon: Icon(Icons.numbers),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (val) {
              final parsed = int.tryParse(val.trim());
              if (parsed != null && parsed >= 0) {
                Navigator.of(ctx).pop(parsed);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final parsed = int.tryParse(controller.text.trim());
            if (parsed != null && parsed >= 0) {
              Navigator.of(ctx).pop(parsed);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4500)),
          child:
              const Text('Set Quantity', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
  if (result != null) {
    onConfirm(result);
  }
}

// ── PRODUCT CARD WIDGET (Matching Screenshot UI) ────────────────────────────

class ProductGridCard extends StatelessWidget {
  final Item item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback? onSetQuantity;

  const ProductGridCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.onSetQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAdd,
      onLongPress: onSetQuantity,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: quantity > 0
                ? const Color(0xFFFF4500)
                : const Color(0xFFF3F4F6),
            width: quantity > 0 ? 1.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Header with Veg Icon Badge
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: ItemImageWidget(
                      imageUrl: item.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: Container(
                        color: const Color(0xFFF3F4F6),
                        child: const Icon(
                          Icons.fastfood,
                          size: 32,
                          color: Color(0xFFFF4500),
                        ),
                      ),
                    ),
                  ),
                  // Green Veg Symbol Badge (Standard Indian FSSAI symbol)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 18,
                      height: 18,
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF008000),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF008000),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details & Price & Action Button Area
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppFormatters.currency(item.sellingPrice),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF4500),
                        ),
                      ),
                      if (quantity == 0)
                        InkWell(
                          onTap: onAdd,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFFFF4500),
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (quantity > 0) ...[
                    const SizedBox(height: 6),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFF4500),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: onRemove,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.remove,
                                color: Color(0xFFFF4500),
                                size: 16,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onSetQuantity,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.edit,
                                    size: 11,
                                    color: Color(0xFFFF4500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onAdd,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFFF4500),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
