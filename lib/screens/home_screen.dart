import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/order_card.dart';
import '../widgets/stat_card.dart';
import 'create_order/create_order_screen.dart';
import 'orders_list_screen.dart';
import 'inventory/inventory_screen.dart';
import 'menu/menu_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'order_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, double> _todayStats = {};

  final _pages = const [
    _DashboardTab(),
    OrdersListScreen(),
    _InventoryTab(),
    _MenuTab(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final orderProvider = context.read<OrderProvider>();
    final inventoryProvider = context.read<InventoryProvider>();
    await orderProvider.loadOrders();
    await inventoryProvider.loadInventoryStatus();
    final stats = await orderProvider.getTodayRevenueSummary();
    if (mounted) setState(() => _todayStats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const CreateOrderScreen(),
                ));
                _loadData();
              },
              icon: const Icon(Icons.bolt, color: Colors.white),
              label: const Text('New Quick Sale',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}

// ── Dashboard Tab ─────────────────────────────────────────────────────────────

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  Map<String, double> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final stats = await context.read<OrderProvider>().getTodayRevenueSummary();
    if (mounted) setState(() { _stats = stats; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();
    final inventory = context.watch<InventoryProvider>();
    final orders = context.watch<OrderProvider>();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.businessName,
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    'Today, ${AppFormatters.date(DateTime.now())}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.bar_chart_rounded),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ReportsScreen(),
                  )),
                  tooltip: 'Reports',
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ));
                    context.read<SettingsProvider>().loadSettings();
                  },
                  tooltip: 'Settings',
                ),
              ],
            ),

            // ── Stock Alert Banner ─────────────────────────────────────────
            if (inventory.totalAlertCount > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.outOfStock.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.outOfStock.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.outOfStock, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${inventory.outOfStockCount} out of stock  •  '
                              '${inventory.lowStockCount} low stock',
                              style: const TextStyle(
                                color: AppColors.outOfStock,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 12, color: AppColors.outOfStock),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Today's Stats ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text("Today's Overview",
                    style: theme.textTheme.titleMedium),
              ),
            ),

            SliverToBoxAdapter(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Column(
                        children: [
                          // Main revenue card (full width)
                          StatCard(
                            label: 'Total Revenue Today',
                            value: AppFormatters.currency(_stats['total'] ?? 0),
                            subtitle:
                                '${(_stats['orderCount'] ?? 0).toInt()} orders today',
                            icon: Icons.account_balance_wallet_rounded,
                            color: AppColors.accent,
                            gradient: AppColors.revenueGradient,
                          ),
                          const SizedBox(height: 10),

                          // Conditional breakdown cards
                          if (settings.orderModesEnabled)
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    label: 'Dine-In',
                                    value: AppFormatters.currency(
                                        _stats['dineIn'] ?? 0),
                                    icon: Icons.restaurant,
                                    color: const Color(0xFF4F46E5),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: StatCard(
                                    label: 'Takeaway',
                                    value: AppFormatters.currency(
                                        _stats['takeaway'] ?? 0),
                                    icon: Icons.shopping_bag_outlined,
                                    color: const Color(0xFFD97706),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: StatCard(
                                    label: 'Delivery',
                                    value: AppFormatters.currency(
                                        _stats['delivery'] ?? 0),
                                    icon: Icons.delivery_dining,
                                    color: const Color(0xFF059669),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    label: 'Counter Sales',
                                    value: AppFormatters.currency(
                                        _stats['total'] ?? 0),
                                    icon: Icons.point_of_sale_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: StatCard(
                                    label: 'Avg Order',
                                    value: (_stats['orderCount'] ?? 0) > 0
                                        ? AppFormatters.currency(
                                            (_stats['total'] ?? 0) /
                                                (_stats['orderCount'] ?? 1))
                                        : '—',
                                    icon: Icons.receipt_outlined,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),

            // ── Recent Orders ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  children: [
                    Text('Recent Orders', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) {
                  final recentOrders = orders.orders.take(10).toList();
                  if (idx >= recentOrders.length) return null;
                  final o = recentOrders[idx];
                  return OrderCard(
                    order: o,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(orderId: o.id),
                    )),
                  );
                },
                childCount: orders.orders.take(10).length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),
    );
  }
}

// Placeholder tabs that delegate to their own screens
class _InventoryTab extends StatelessWidget {
  const _InventoryTab();
  @override
  Widget build(BuildContext context) => const InventoryScreen();
}

class _MenuTab extends StatelessWidget {
  const _MenuTab();
  @override
  Widget build(BuildContext context) => const MenuScreen();
}
