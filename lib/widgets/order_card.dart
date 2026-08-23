import 'package:flutter/material.dart';
import '../data/db_types.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'source_badge.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onInvoiceTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onLongPress,
    this.onInvoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(order.orderStatus);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: order number + status badge + source badge
              Row(
                children: [
                  Text(
                    order.orderNumber,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SourceBadge(source: _sourceDisplay),
                  const Spacer(),
                  _StatusBadge(status: order.orderStatus, color: statusColor),
                ],
              ),
              const SizedBox(height: 8),

              // Middle row: amount + customer phone
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderSource == AppConstants.sourceOffline
                            ? AppFormatters.currency(order.finalTotal)
                            : 'Net: ${AppFormatters.currency(order.netEarnings)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (order.orderSource != AppConstants.sourceOffline)
                        Text(
                          'Gross: ${AppFormatters.currency(order.grossAmount)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (onInvoiceTap != null)
                    IconButton(
                      icon: const Icon(Icons.receipt_long_outlined, size: 20),
                      color: AppColors.primary,
                      onPressed: onInvoiceTap,
                      tooltip: 'View Invoice',
                    ),
                ],
              ),

              const SizedBox(height: 6),
              // Bottom: time + customer phone
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 13,
                      color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  const SizedBox(width: 4),
                  Text(
                    AppFormatters.relativeTime(order.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (order.customerPhone != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.phone,
                        size: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text(
                      order.customerPhone!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _sourceDisplay {
    if (order.deliveryAppName != null && order.deliveryAppName!.isNotEmpty) {
      return '${order.orderSource} (${order.deliveryAppName})';
    }
    return order.orderSource;
  }

  Color _statusColor(String status) {
    return switch (status) {
      AppConstants.statusPending => AppColors.pending,
      AppConstants.statusPreparing => AppColors.preparing,
      AppConstants.statusReady => AppColors.ready,
      AppConstants.statusCompleted => AppColors.completed,
      _ => AppColors.textMuted,
    };
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
