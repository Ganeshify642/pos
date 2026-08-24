import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db_types.dart';
import '../../models/app_models.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_image_widget.dart';
import '../invoice_preview_screen.dart';
import '../menu/menu_screen.dart';
import 'checkout_page.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedCategoryId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().resetWizard();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gopal Vadapav POS — Quick Billing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            tooltip: 'Manage Menu',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MenuScreen()),
            ),
          ),
        ],
      ),
      body: isTablet
          ? Row(
              children: [
                // Left 65%: Catalog & Item Selector
                Expanded(
                  flex: 65,
                  child: _buildItemCatalog(context),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                // Right 35%: Live Cart Panel
                Expanded(
                  flex: 35,
                  child: _buildTabletCartPanel(context),
                ),
              ],
            )
          : Column(
              children: [
                // Mobile Catalog
                Expanded(child: _buildItemCatalog(context)),
                // Mobile Bottom Bar
                _buildMobileCartBottomBar(context),
              ],
            ),
    );
  }

  // ── Item Catalog (Grid & Search) ─────────────────────────────────────────

  Widget _buildItemCatalog(BuildContext context) {
    final theme = Theme.of(context);
    final menuProvider = context.watch<MenuProvider>();
    final orderProvider = context.watch<OrderProvider>();

    var items = menuProvider.items;

    if (_selectedCategoryId != null) {
      items = items.where((i) => i.categoryId == _selectedCategoryId).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items.where((i) => i.name.toLowerCase().contains(q)).toList();
    }

    return Column(
      children: [
        // Search & Filter Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search items (e.g. Vadapav, Samosa)...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
            ],
          ),
        ),

        // Category Filter Chips
        if (menuProvider.categories.isNotEmpty)
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('All Items'),
                  selected: _selectedCategoryId == null,
                  onSelected: (_) => setState(() => _selectedCategoryId = null),
                ),
                const SizedBox(width: 8),
                ...menuProvider.categories.map((cat) {
                  final isSel = _selectedCategoryId == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat.name),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedCategoryId = cat.id),
                    ),
                  );
                }),
              ],
            ),
          ),

        const SizedBox(height: 8),

        // Items Grid
        Expanded(
          child: menuProvider.items.isEmpty
              ? EmptyState(
                  icon: Icons.fastfood_outlined,
                  title: 'No Menu Items Yet',
                  subtitle: 'Add your delicious items to start taking orders.',
                  actionLabel: '+ Add Items to Menu',
                  onAction: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MenuScreen()),
                  ),
                )
              : items.isEmpty
                  ? const Center(child: Text('No matching items found'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (ctx, idx) {
                        final item = items[idx];
                        final qty = orderProvider.getCartQty(item.id);
                        return _ItemCard(
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
                    ),
        ),
      ],
    );
  }

  // ── Tablet Split Panel Cart ───────────────────────────────────────────────

  Widget _buildTabletCartPanel(BuildContext context) {
    final theme = Theme.of(context);
    final op = context.watch<OrderProvider>();
    final sp = context.watch<SettingsProvider>();

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withOpacity(0.08),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Current Order', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (op.cartItems.isNotEmpty)
                  TextButton(
                    onPressed: () => op.clearCart(),
                    child: const Text('Clear All', style: TextStyle(color: AppColors.outOfStock)),
                  ),
              ],
            ),
          ),

          // Items list in cart
          Expanded(
            child: op.cartItems.isEmpty
                ? const Center(child: Text('Cart is empty. Select items to add.'))
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
                                  Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text('${AppFormatters.currency(item.price)} each', style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  onPressed: () => op.removeItemFromCart(item.itemId),
                                ),
                                InkWell(
                                  onTap: () {
                                    _showQuantityDialog(
                                      context,
                                      itemName: item.itemName,
                                      initialQty: item.quantity,
                                      onConfirm: (newQty) {
                                        op.setItemQuantity(
                                          item.itemId,
                                          newQty,
                                          itemTemplate: item,
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(Icons.edit, size: 12, color: AppColors.primary),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20),
                                  onPressed: () => op.addItemToCart(item),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppFormatters.currency(item.lineTotal),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Checkout Summary Box
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
                    Text(AppFormatters.currency(op.cartSubtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: op.cartItems.isEmpty || _isSubmitting ? null : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Checkout')),
                            body: CheckoutPage(
                              onBack: () => Navigator.of(context).pop(),
                              onSubmit: _submitOrder,
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Proceed to Checkout →', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile Bottom Cart Bar ───────────────────────────────────────────────

  Widget _buildMobileCartBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final op = context.watch<OrderProvider>();

    if (op.cartItemCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${op.cartItemCount} items selected',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  AppFormatters.currency(op.cartSubtotal),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Checkout')),
                      body: CheckoutPage(
                        onBack: () => Navigator.of(context).pop(),
                        onSubmit: _submitOrder,
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: AppColors.primary,
              ),
              child: const Row(
                children: [
                  Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
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
  final controller = TextEditingController(text: initialQty > 0 ? '$initialQty' : '1');
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
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Set Quantity', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
  if (result != null) {
    onConfirm(result);
  }
}

// ── Touch-Friendly Item Card ─────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final Item item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onSetQuantity;

  const _ItemCard({
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onSetQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: quantity > 0 ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: quantity > 0 ? AppColors.primary : theme.dividerColor,
          width: quantity > 0 ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Item Image or Icon
            ItemImageWidget(
              imageUrl: item.imageUrl,
              width: double.infinity,
              height: 72,
              borderRadius: BorderRadius.circular(10),
              placeholder: _iconPlaceholder(),
            ),

            // Item Name
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),

            // Price Tag
            Text(
              AppFormatters.currency(item.sellingPrice),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),

            // Stepper / Add button
            if (quantity == 0)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onAdd,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('+ Add', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 32),
                      onPressed: onRemove,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: onSetQuantity,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.edit, color: Colors.white, size: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 32),
                      onPressed: onAdd,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconPlaceholder() {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.fastfood, size: 28, color: AppColors.primary),
    );
  }
}
