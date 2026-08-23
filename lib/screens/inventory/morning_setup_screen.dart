import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_models.dart';
import '../../providers/inventory_provider.dart';
import '../../utils/app_colors.dart';

class MorningSetupScreen extends StatefulWidget {
  const MorningSetupScreen({super.key});

  @override
  State<MorningSetupScreen> createState() => _MorningSetupScreenState();
}

class _MorningSetupScreenState extends State<MorningSetupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().loadMorningSetup();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventory = context.watch<InventoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Morning Setup'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.copy_outlined, size: 16),
            label: const Text('Copy Yesterday'),
            onPressed: () =>
                context.read<InventoryProvider>().copyYesterday(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.primary.withOpacity(0.08),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny, color: AppColors.pending, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Set Today\'s Preparation',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                      Text(
                        'Enter how many units you\'ve prepared today',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Column headers
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Expanded(child: Text('Item', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700))),
                SizedBox(width: 70, child: Text('Yesterday', style: theme.textTheme.bodySmall, textAlign: TextAlign.center)),
                SizedBox(width: 120, child: Text('Today\'s Qty', style: theme.textTheme.bodySmall, textAlign: TextAlign.center)),
              ],
            ),
          ),
          const Divider(height: 1),

          // Items
          Expanded(
            child: inventory.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: inventory.morningSetup.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (ctx, i) {
                      final entry = inventory.morningSetup[i];
                      return _MorningSetupRow(
                        entry: entry,
                        onChanged: (qty) => context
                            .read<InventoryProvider>()
                            .updateMorningEntry(entry.itemId, qty),
                      );
                    },
                  ),
          ),

          // Save button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: inventory.isLoading
                    ? null
                    : () async {
                        await context
                            .read<InventoryProvider>()
                            .saveAndStartDay();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Inventory saved! Ready to take orders.'),
                              backgroundColor: AppColors.accent,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save & Start Day'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MorningSetupRow extends StatefulWidget {
  final MorningSetupEntry entry;
  final ValueChanged<int> onChanged;

  const _MorningSetupRow({required this.entry, required this.onChanged});

  @override
  State<_MorningSetupRow> createState() => _MorningSetupRowState();
}

class _MorningSetupRowState extends State<_MorningSetupRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: '${widget.entry.madeQty}');
  }

  @override
  void didUpdateWidget(_MorningSetupRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entry.madeQty != oldWidget.entry.madeQty) {
      _controller.text = '${widget.entry.madeQty}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment(int delta) {
    final current = int.tryParse(_controller.text) ?? 0;
    final newVal = (current + delta).clamp(0, 9999);
    _controller.text = '$newVal';
    widget.onChanged(newVal);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Item name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.entry.itemName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500)),
                Text(widget.entry.categoryName,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),

          // Yesterday qty
          SizedBox(
            width: 70,
            child: Center(
              child: Text(
                widget.entry.yesterdayMadeQty != null
                    ? '${widget.entry.yesterdayMadeQty}'
                    : '-',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ),

          // Qty stepper
          SizedBox(
            width: 120,
            child: Row(
              children: [
                // Quick add buttons
                PopupMenuButton<int>(
                  tooltip: 'Quick add',
                  onSelected: _increment,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.add_circle_outline,
                      size: 18,
                      color: AppColors.primary.withOpacity(0.7)),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 5, child: Text('+5')),
                    const PopupMenuItem(value: 10, child: Text('+10')),
                    const PopupMenuItem(value: 20, child: Text('+20')),
                    const PopupMenuItem(value: 50, child: Text('+50')),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      isDense: true,
                    ),
                    onChanged: (v) {
                      widget.onChanged(int.tryParse(v) ?? 0);
                    },
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
