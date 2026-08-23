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
  String? _selectedSource;
  String? _selectedStatus;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar area
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Text(
                    'Orders',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today_outlined, size: 20),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    setState(() => _selectedDate = picked);
                    context.read<OrderProvider>().setFilterDate(picked);
                  },
                ),
                if (_selectedDate != null || _selectedSource != null || _selectedStatus != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSource = null;
                        _selectedStatus = null;
                        _selectedDate = null;
                      });
                      context.read<OrderProvider>().clearFilters();
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),

          // Filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Source filter
                ...AppConstants.orderSources.map((s) {
                  final isSelected = _selectedSource == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6, top: 8),
                    child: FilterChip(
                      label: Text(s),
                      selected: isSelected,
                      onSelected: (v) {
                        setState(() => _selectedSource = v ? s : null);
                        context
                            .read<OrderProvider>()
                            .setFilterSource(v ? s : null);
                      },
                      selectedColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  );
                }),
                const VerticalDivider(width: 12),
                // Status filter
                ...AppConstants.orderStatuses.take(4).map((s) {
                  final isSelected = _selectedStatus == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6, top: 8),
                    child: FilterChip(
                      label: Text(s),
                      selected: isSelected,
                      onSelected: (v) {
                        setState(() => _selectedStatus = v ? s : null);
                        context
                            .read<OrderProvider>()
                            .setFilterStatus(v ? s : null);
                      },
                      selectedColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Date selected indicator
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 13),
                  const SizedBox(width: 6),
                  Text(
                    'Filtered: ${AppFormatters.date(_selectedDate!)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

          // Orders list
          Expanded(
            child: orderProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : orderProvider.filteredOrders.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No orders found',
                        subtitle: _selectedSource != null ||
                                _selectedStatus != null ||
                                _selectedDate != null
                            ? 'Try clearing filters'
                            : 'Tap + to create your first order',
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<OrderProvider>().loadOrders(),
                        child: ListView.builder(
                          itemCount: orderProvider.filteredOrders.length,
                          itemBuilder: (ctx, i) {
                            final order = orderProvider.filteredOrders[i];
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
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Order Status',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...AppConstants.orderStatuses.map((s) => ListTile(
                  title: Text(s),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<OrderProvider>().updateOrderStatus(orderId, s);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
