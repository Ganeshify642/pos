import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db_types.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

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
    final statusStyle = _getStatusBadgeStyle(order.orderStatus);
    final modeStyle = _getModeStyle(order.orderSource);
    final orderNum = order.orderNumber.startsWith('#')
        ? order.orderNumber
        : '#${order.orderNumber}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Left 44x44 Mode Icon Box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: modeStyle.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    modeStyle.icon,
                    color: modeStyle.iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Center Section: Order number, status, source with bullet dot, item count with icon
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Order Number + Status Badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              orderNum,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusStyle.bgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              order.orderStatus,
                              style: TextStyle(
                                color: statusStyle.textColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Row 2: Colored Bullet Dot + Source String
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: modeStyle.iconColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _sourceDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Row 3: Calendar/Receipt Icon + Item Count
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 5),
                          _buildItemCountWidget(context),
                          if (order.customerPhone != null &&
                              order.customerPhone!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.phone_outlined,
                              size: 11,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              order.customerPhone!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Section: Amount + Time (e.g. 12:42 PM)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppFormatters.currency(order.finalTotal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppFormatters.time(order.createdAt),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCountWidget(BuildContext context) {
    return FutureBuilder(
      future: context.read<OrderProvider>().getOrderSummary(order.id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final items = snapshot.data!.items;
          final totalQty = items.fold(0, (sum, item) => sum + item.quantity);
          final label = totalQty == 1 ? '1 item' : '$totalQty items';
          return Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          );
        }
        return const Text(
          '...',
          style: TextStyle(
            fontSize: 11.5,
            color: Color(0xFF94A3B8),
          ),
        );
      },
    );
  }

  String get _sourceDisplay {
    if (order.deliveryAppName != null && order.deliveryAppName!.isNotEmpty) {
      return '${order.orderSource} (${order.deliveryAppName})';
    }
    return order.orderSource;
  }

  _ModeStyle _getModeStyle(String source) {
    return switch (source) {
      AppConstants.sourceStaff => const _ModeStyle(
          bgColor: Color(0xFFFFF0ED),
          iconColor: Color(0xFFFF5722),
          icon: Icons.shopping_bag_outlined,
        ),
      AppConstants.sourceCounter => const _ModeStyle(
          bgColor: Color(0xFFFFF0ED),
          iconColor: Color(0xFFFF5722),
          icon: Icons.point_of_sale_outlined,
        ),
      AppConstants.sourceTakeaway => const _ModeStyle(
          bgColor: Color(0xFFEFF6FF),
          iconColor: Color(0xFF2563EB),
          icon: Icons.shopping_bag_outlined,
        ),
      AppConstants.sourceDineIn => const _ModeStyle(
          bgColor: Color(0xFFF3E8FF),
          iconColor: Color(0xFF9333EA),
          icon: Icons.flatware_rounded,
        ),
      AppConstants.sourceDelivery => const _ModeStyle(
          bgColor: Color(0xFFECFDF5),
          iconColor: Color(0xFF059669),
          icon: Icons.two_wheeler_outlined,
        ),
      _ => const _ModeStyle(
          bgColor: Color(0xFFFFF0ED),
          iconColor: Color(0xFFFF5722),
          icon: Icons.shopping_bag_outlined,
        ),
    };
  }

  _StatusBadgeStyle _getStatusBadgeStyle(String status) {
    return switch (status) {
      AppConstants.statusCompleted => const _StatusBadgeStyle(
          bgColor: Color(0xFFE6F7F0),
          textColor: Color(0xFF10B981),
        ),
      AppConstants.statusPending => const _StatusBadgeStyle(
          bgColor: Color(0xFFFFF4E5),
          textColor: Color(0xFFF59E0B),
        ),
      AppConstants.statusPreparing => const _StatusBadgeStyle(
          bgColor: Color(0xFFEFF6FF),
          textColor: Color(0xFF2563EB),
        ),
      AppConstants.statusReady => const _StatusBadgeStyle(
          bgColor: Color(0xFFECFDF5),
          textColor: Color(0xFF059669),
        ),
      AppConstants.statusCancelled => const _StatusBadgeStyle(
          bgColor: Color(0xFFFEE2E2),
          textColor: Color(0xFFEF4444),
        ),
      _ => const _StatusBadgeStyle(
          bgColor: Color(0xFFF1F5F9),
          textColor: Color(0xFF64748B),
        ),
    };
  }
}

class _ModeStyle {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  const _ModeStyle({
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });
}

class _StatusBadgeStyle {
  final Color bgColor;
  final Color textColor;
  const _StatusBadgeStyle({required this.bgColor, required this.textColor});
}



