import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_models.dart';
import '../providers/inventory_provider.dart';
import '../providers/order_provider.dart';
import '../providers/printer_provider.dart';
import '../providers/report_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/printer_dialog.dart';
import '../widgets/source_badge.dart';
import 'invoice_preview_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderSummary? _summary;
  bool _loading = true;
  bool _isPrintingThermal = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final summary =
        await context.read<OrderProvider>().getOrderSummary(widget.orderId);
    if (mounted) setState(() { _summary = summary; _loading = false; });
  }

  Future<void> _printThermal() async {
    final printer = context.read<PrinterProvider>();
    final settings = context.read<SettingsProvider>();

    if (_summary == null) return;

    if (!printer.isConnected) {
      await PrinterDialog.show(context);
      return;
    }

    if (settings.businessSettings == null || settings.taxSettings == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings not loaded. Please try again.')),
      );
      return;
    }

    setState(() => _isPrintingThermal = true);

    try {
      final success = await printer.printOrderReceipt(
        order: _summary!.order,
        items: _summary!.items,
        business: settings.businessSettings!,
        taxSettings: settings.taxSettings!,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receipt printed on thermal printer!'),
              backgroundColor: AppColors.inStock,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(printer.errorMessage ?? 'Thermal print failed. Check Bluetooth connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isPrintingThermal = false);
    }
  }

  Future<void> _updateStatus(String status) async {
    await context.read<OrderProvider>().updateOrderStatus(widget.orderId, status);
    await _load();
  }

  Future<void> _handleCancelOrder() async {
    if (_summary == null) return;
    final order = _summary!.order;
    final totalItems = _summary!.items.fold(0, (sum, i) => sum + i.quantity);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancel Order?'),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel Order #${order.orderNumber}?\n\n'
          '• Order status will become Cancelled\n'
          '• $totalItems items will be restored to today\'s inventory\n'
          '• ${AppFormatters.currency(order.finalTotal)} will be removed from sales & revenue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No, Keep Order'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Yes, Cancel Order'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok = await context.read<OrderProvider>().cancelOrder(widget.orderId);
    if (mounted && ok) {
      await context.read<InventoryProvider>().loadInventoryStatus();
      await context.read<ReportProvider>().loadReport();
      await _load();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #${order.orderNumber} cancelled. Items restored to inventory.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Status',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...AppConstants.orderStatuses.map((s) => ListTile(
                  title: Text(s),
                  leading: Icon(Icons.circle,
                      size: 12, color: _statusColor(s)),
                  onTap: () {
                    Navigator.pop(context);
                    if (s == AppConstants.statusCancelled) {
                      _handleCancelOrder();
                    } else {
                      _updateStatus(s);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) {
    return switch (s) {
      AppConstants.statusPending => AppColors.pending,
      AppConstants.statusPreparing => AppColors.preparing,
      AppConstants.statusReady => AppColors.ready,
      AppConstants.statusCompleted => AppColors.completed,
      AppConstants.statusCancelled => Colors.red,
      _ => AppColors.textMuted,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_summary == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Order not found')),
      );
    }

    final order = _summary!.order;
    final items = _summary!.items;
    final isCancelled = order.orderStatus == AppConstants.statusCancelled;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.orderNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: _printThermal,
            tooltip: 'Print Thermal Receipt',
          ),
          if (!isCancelled)
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: _handleCancelOrder,
              tooltip: 'Cancel Order',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cancelled Notice Banner
          if (isCancelled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel_rounded, color: Colors.red, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORDER CANCELLED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Items have been restored to inventory and revenue excluded from reports.',
                          style: TextStyle(fontSize: 12, color: Colors.red.shade800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${order.orderNumber}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SourceBadge(source: order.orderSource),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppFormatters.dateTime(order.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                      InkWell(
                        onTap: isCancelled ? null : _showStatusPicker,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(order.orderStatus).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 8, color: _statusColor(order.orderStatus)),
                              const SizedBox(width: 6),
                              Text(
                                order.orderStatus,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _statusColor(order.orderStatus),
                                  fontSize: 13,
                                ),
                              ),
                              if (!isCancelled) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down, size: 16),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Order Items Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Items (${items.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 16),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${item.quantity}x',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  if (item.specialInstructions.isNotEmpty)
                                    Text(
                                      item.specialInstructions,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              AppFormatters.currency(item.quantity * item.priceAtOrder),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Bill Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Billing Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 16),
                  _InfoRow(label: 'Subtotal', value: AppFormatters.currency(order.subtotal)),
                  if (order.sgstAmount > 0)
                    _InfoRow(label: 'SGST', value: AppFormatters.currency(order.sgstAmount)),
                  if (order.cgstAmount > 0)
                    _InfoRow(label: 'CGST', value: AppFormatters.currency(order.cgstAmount)),
                  if (order.discountAmount > 0)
                    _InfoRow(
                      label: 'Discount',
                      value: '- ${AppFormatters.currency(order.discountAmount)}',
                      valueColor: AppColors.inStock,
                    ),
                  if (order.deliveryFee > 0)
                    _InfoRow(label: 'Delivery Fee', value: AppFormatters.currency(order.deliveryFee)),
                  const Divider(height: 16),
                  _InfoRow(
                    label: 'Total Amount',
                    value: AppFormatters.currency(order.finalTotal),
                    bold: true,
                    valueColor: isCancelled ? Colors.red : AppColors.primary,
                  ),
                  _InfoRow(
                    label: 'Payment Method',
                    value: order.paymentMethod,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons: Print Thermal Receipt
          Consumer<PrinterProvider>(
            builder: (context, printer, _) {
              return ElevatedButton.icon(
                onPressed: _isPrintingThermal ? null : _printThermal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isPrintingThermal
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.print_rounded, size: 20),
                label: Text(
                  _isPrintingThermal
                      ? 'Printing Thermal Receipt...'
                      : printer.isConnected
                          ? 'Print Thermal Receipt (${printer.paperSize})'
                          : 'Connect & Print Thermal Receipt',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          if (order.invoicePath != null)
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => InvoicePreviewScreen(
                  orderId: order.id,
                  invoicePath: order.invoicePath,
                ),
              )),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: const Text('View PDF Invoice & Share'),
            ),

          if (!isCancelled) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _handleCancelOrder,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Cancel Order & Restore Inventory'),
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? theme.colorScheme.onSurface,
                fontSize: bold ? 15 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
