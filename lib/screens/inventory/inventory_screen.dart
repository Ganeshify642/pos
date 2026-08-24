import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_models.dart';
import '../../providers/inventory_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/stock_status_chip.dart';
import 'morning_setup_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().loadInventoryStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventory = context.watch<InventoryProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Text(
                    'Inventory',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                const Spacer(),
                // Sort options
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort_rounded, size: 22),
                  tooltip: 'Sort by',
                  onSelected: (v) =>
                      context.read<InventoryProvider>().setSortBy(v),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'name', child: Text('Name')),
                    const PopupMenuItem(
                        value: 'utilization', child: Text('Utilization %')),
                    const PopupMenuItem(
                        value: 'remaining', child: Text('Remaining')),
                    const PopupMenuItem(
                        value: 'category', child: Text('Category')),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.wb_sunny_outlined, size: 22),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const MorningSetupScreen(),
                    ));
                    context.read<InventoryProvider>().loadInventoryStatus();
                  },
                  tooltip: 'Morning Setup',
                ),
              ],
            ),
          ),

          // Alert banner
          if (inventory.totalAlertCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.outOfStock.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.outOfStock.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.outOfStock, size: 16),
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
                  ],
                ),
              ),
            ),

          // Summary row
          if (inventory.inventoryStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _MiniStat(
                    label: 'Made',
                    value: '${inventory.totalMade}',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'Sold',
                    value: '${inventory.totalSold}',
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'Wasted',
                    value: '${inventory.totalWasted}',
                    color: AppColors.expense,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'Utilization',
                    value:
                        '${inventory.avgUtilization.toStringAsFixed(0)}%',
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Column headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Item',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700))),
                SizedBox(
                    width: 45,
                    child: Text('Made',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center)),
                SizedBox(
                    width: 45,
                    child: Text('Sold',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center)),
                SizedBox(
                    width: 85,
                    child: Text('Status',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          const Divider(height: 1),

          // Items list
          Expanded(
            child: inventory.isLoading
                ? const Center(child: CircularProgressIndicator())
                : inventory.inventoryStatus.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No inventory set',
                        subtitle: 'Tap ☀️ to set up today\'s preparation',
                        actionLabel: 'Morning Setup',
                        onAction: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const MorningSetupScreen()),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => context
                            .read<InventoryProvider>()
                            .loadInventoryStatus(),
                        child: ListView.separated(
                          itemCount: inventory.inventoryStatus.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 16),
                          itemBuilder: (ctx, i) {
                            final inv = inventory.inventoryStatus[i];
                            return _InventoryRow(
                              status: inv,
                              onWasteEdit: () =>
                                  _showWasteDialog(context, inv),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    ),
  );
}

  void _showWasteDialog(BuildContext context, InventoryStatus inv) {
    final controller = TextEditingController(text: '${inv.wastedQty}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Wastage: ${inv.itemName}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Wasted Qty',
            suffix: Text('units'),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(controller.text) ?? 0;
              context
                  .read<InventoryProvider>()
                  .updateWastedQty(inv.itemId, qty);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  final InventoryStatus status;
  final VoidCallback onWasteEdit;

  const _InventoryRow({required this.status, required this.onWasteEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onLongPress: onWasteEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status.itemName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500)),
                  Text(status.categoryName,
                      style: theme.textTheme.bodySmall),
                  if (status.madeQty > 0)
                    LinearProgressIndicator(
                      value: status.utilizationPct / 100,
                      backgroundColor: theme.dividerColor,
                      valueColor: AlwaysStoppedAnimation(
                        status.utilizationPct > 90
                            ? AppColors.accent
                            : status.utilizationPct < 50
                                ? AppColors.lowStock
                                : AppColors.primary,
                      ),
                      minHeight: 3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 45,
              child: Text(
                '${status.madeQty}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              width: 45,
              child: Text(
                '${status.soldQty}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 85,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: StockStatusChip(status: status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
            Text(label,
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
