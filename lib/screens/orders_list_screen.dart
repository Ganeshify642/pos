import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/order_card.dart';
import 'order_details_screen.dart';
import 'invoice_preview_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  String _selectedDateRange = 'Today';
  String _customLabel = 'Custom';

  static const List<String> _dateRangeOptions = [
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'All',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
      _applyDateRange('Today');
    });
  }

  void _applyDateRange(String range) {
    setState(() => _selectedDateRange = range);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final provider = context.read<OrderProvider>();

    switch (range) {
      case 'Today':
        provider.setFilterDate(today);
        break;
      case 'Yesterday':
        provider.setFilterDate(today.subtract(const Duration(days: 1)));
        break;
      case 'Last 7 Days':
        provider.setFilterDateRange(
          today.subtract(const Duration(days: 6)),
          now,
        );
        break;
      case 'Last 30 Days':
        provider.setFilterDateRange(
          today.subtract(const Duration(days: 29)),
          now,
        );
        break;
      case 'All':
        provider.clearFilters();
        break;
      case 'Custom':
        _showCustomDatePicker();
        break;
    }
  }

  Future<void> _showCustomDatePicker() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: today,
        end: today,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF4500),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      final start = picked.start;
      final end = picked.end;
      final provider = context.read<OrderProvider>();

      // Check if same day selected (single date)
      if (start.year == end.year &&
          start.month == end.month &&
          start.day == end.day) {
        provider.setFilterDate(start);
        setState(() {
          _customLabel =
              '${start.day}/${start.month}/${start.year}';
          _selectedDateRange = 'Custom';
        });
      } else {
        provider.setFilterDateRange(start, end);
        setState(() {
          _customLabel =
              '${start.day}/${start.month} - ${end.day}/${end.month}';
          _selectedDateRange = 'Custom';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final ordersList = orderProvider.filteredOrders;
    final totalSales = ordersList.fold(0.0, (sum, o) => sum + o.finalTotal);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  // Custom Date Picker Button
                  _HeaderActionButton(
                    icon: Icons.calendar_month_rounded,
                    tooltip: 'Custom Date',
                    isActive: _selectedDateRange == 'Custom',
                    onTap: () => _applyDateRange('Custom'),
                  ),
                ],
              ),
            ),
            // Custom date label indicator with clear button
            if (_selectedDateRange == 'Custom')
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10, top: 4, bottom: 4, right: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: Color(0xFFFF4500),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _customLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF4500),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => _applyDateRange('Today'),
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Color(0xFFFF4500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // ── Top Performance Summary Cards (Total Orders & Total Sales) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Card 1: Total Orders Today
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFF1F5F9), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0ED),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFFFF4500),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ordersList.length}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Total Orders',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                   _selectedDateRange,
                                   style: const TextStyle(
                                     fontSize: 11.5,
                                     fontWeight: FontWeight.w700,
                                     color: Color(0xFFFF4500),
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Card 2: Total Sales Today
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFF1F5F9), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F7F0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.currency_rupee_rounded,
                              color: Color(0xFF10B981),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppFormatters.currency(totalSales),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Total Sales',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                   _selectedDateRange,
                                   style: const TextStyle(
                                     fontSize: 11.5,
                                     fontWeight: FontWeight.w700,
                                     color: Color(0xFF10B981),
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Date Range Filter Pills Bar ──────────────────────────────
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _dateRangeOptions.map((range) {
                  final isSelected = _selectedDateRange == range;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterPill(
                      label: range,
                      isSelected: isSelected,
                      onTap: () => _applyDateRange(range),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // ── Orders List ───────────────────────────────────────────────
            Expanded(
              child: orderProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ordersList.isEmpty
                      ? EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: 'No orders found',
                          subtitle: _selectedDateRange != 'All'
                              ? 'Try selecting a different date range'
                              : 'Tap + to create your first order',
                        )
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<OrderProvider>().loadOrders(),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: ordersList.length + 1,
                            itemBuilder: (ctx, i) {
                              // Footer element
                              if (i == ordersList.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 32),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: Divider(
                                          color: Color(0xFFE2E8F0),
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          "You've reached the end",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Color(0xFFE2E8F0),
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final order = ordersList[i];
                              return OrderCard(
                                order: order,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailsScreen(
                                        orderId: order.id),
                                  ),
                                ),
                                onLongPress: () => _showStatusPicker(order.id),
                                onInvoiceTap: order.invoicePath != null
                                    ? () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => InvoicePreviewScreen(
                                              orderId: order.id,
                                              invoicePath: order.invoicePath,
                                              autoPrint: false,
                                              autoRedirect: false,
                                            ),
                                          ),
                                        )
                                    : null,
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

  void _showStatusPicker(int orderId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 14),
            ...AppConstants.orderStatuses.map(
              (s) => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<OrderProvider>().updateOrderStatus(orderId, s);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isActive;

  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF4500) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFFF4500)
                  : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? const Color(0xFFFF4500).withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: isActive ? 6 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4500) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF4500) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF4500).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

