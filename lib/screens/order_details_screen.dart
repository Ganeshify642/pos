import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../data/database/app_database.dart';
import '../data/db_types.dart';
import '../models/app_models.dart';
import '../providers/order_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
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

  Future<void> _updateStatus(String status) async {
    await context.read<OrderProvider>().updateOrderStatus(widget.orderId, status);
    await _load();
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
                    _updateStatus(s);
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
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final order = _summary!.order;
    final items = _summary!.items;
    final isDelivery = order.orderSource != AppConstants.sourceOffline;
    final statusColor = _statusColor(order.orderStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text(order.orderNumber),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Status'),
            onPressed: _showStatusPicker,
          ),
          if (order.invoicePath != null)
            IconButton(
              icon: const Icon(Icons.receipt_long_outlined),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => InvoicePreviewScreen(
                  orderId: order.id,
                  invoicePath: order.invoicePath,
                ),
              )),
              tooltip: 'View Invoice',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SourceBadge(source: _summary!.sourceDisplay),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          order.orderStatus,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                      label: 'Date',
                      value: AppFormatters.dateTime(order.createdAt)),
                  if (order.customerPhone != null)
                    _InfoRow(
                        label: 'Customer',
                        value: order.customerPhone!),
                  if (order.deliveryAppOrderId != null)
                    _InfoRow(
                        label: 'App Order ID',
                        value: order.deliveryAppOrderId!),
                  if (order.deliveryAddress != null)
                    _InfoRow(
                        label: 'Address',
                        value: order.deliveryAddress!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Items
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...items.map((OrderItem item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${item.quantity}×  ',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    )),
                                Expanded(child: Text(item.itemName)),
                                Text(
                                  AppFormatters.currency(
                                      item.quantity * item.priceAtOrder),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            if (item.specialInstructions.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Text(
                                  '* ${item.specialInstructions}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Billing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Billing', style: theme.textTheme.titleMedium),
                  const Divider(height: 20),
                  _InfoRow(
                      label: 'Subtotal',
                      value: AppFormatters.currency(order.subtotal)),
                  if (order.taxAmount > 0) ...[
                    if (order.sgstAmount > 0)
                      _InfoRow(
                          label: 'SGST',
                          value: AppFormatters.currency(order.sgstAmount)),
                    if (order.cgstAmount > 0)
                      _InfoRow(
                          label: 'CGST',
                          value: AppFormatters.currency(order.cgstAmount)),
                    if (order.sgstAmount == 0)
                      _InfoRow(
                          label: 'Tax',
                          value: AppFormatters.currency(order.taxAmount)),
                  ],
                  if (order.deliveryFee > 0)
                    _InfoRow(
                        label: 'Delivery Charge',
                        value: AppFormatters.currency(order.deliveryFee)),
                  if (order.discountAmount > 0)
                    _InfoRow(
                        label: 'Discount',
                        value:
                            '-${AppFormatters.currency(order.discountAmount)}',
                        valueColor: AppColors.inStock),
                  const Divider(height: 16),
                  _InfoRow(
                    label: 'Total Paid',
                    value: AppFormatters.currency(order.finalTotal),
                    bold: true,
                    valueColor: AppColors.accent,
                  ),
                  _InfoRow(
                      label: 'Payment Method',
                      value:
                          '${order.paymentMethod} (${order.paymentStatus})'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (order.invoicePath != null)
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => InvoicePreviewScreen(
                  orderId: order.id,
                  invoicePath: order.invoicePath,
                ),
              )),
              icon: const Icon(Icons.receipt_long_outlined, size: 18),
              label: const Text('View & Print Invoice'),
            ),
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
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
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
