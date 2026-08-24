import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/calculation_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class CheckoutPage extends StatefulWidget {
  final VoidCallback onBack;
  final Future<void> Function() onSubmit;

  const CheckoutPage({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _discountController = TextEditingController();
  bool _discountIsPercent = false;
  bool _submitting = false;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _applyDiscount(OrderProvider op, SettingsProvider sp) {
    final raw = double.tryParse(_discountController.text) ?? 0;
    if (_discountIsPercent) {
      op.setDiscount(
          CalculationService.calculatePercentageDiscount(op.cartSubtotal, raw));
    } else {
      op.setDiscount(raw);
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _submitting = true);
    await widget.onSubmit();
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final op = context.watch<OrderProvider>();
    final sp = context.watch<SettingsProvider>();

    final cartLineItems = op.cartItems
        .map((c) => (qty: c.quantity, price: c.price))
        .toList();

    final tax = sp.taxSettings;
    late double subtotal, taxAmt, finalTotal, sgst, cgst;

    if (tax != null) {
      final calc = CalculationService.calculateOfflineOrderTotal(
        items: cartLineItems,
        taxSettings: tax,
        discountAmount: op.discountAmount,
        deliveryFee: op.deliveryFee,
      );
      subtotal = calc.subtotal;
      taxAmt = calc.taxAmount;
      sgst = calc.sgst;
      cgst = calc.cgst;
      finalTotal = calc.finalTotal;
    } else {
      subtotal = op.cartSubtotal;
      taxAmt = 0;
      sgst = 0;
      cgst = 0;
      finalTotal = (subtotal + op.deliveryFee - op.discountAmount)
          .clamp(0, double.infinity);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),

          // Items list
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Selected Items', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      Text('${op.cartItemCount} items', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...op.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text('${item.quantity}×',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(width: 6),
                            Expanded(child: Text(item.itemName)),
                            Text(
                              AppFormatters.currency(item.lineTotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
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

          // Order Type selector
          // Order Type
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Type', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppConstants.sourceCounter,
                      AppConstants.sourceDineIn,
                      AppConstants.sourceTakeaway,
                      AppConstants.sourceDelivery,
                      AppConstants.sourceStaff,
                    ].map((source) {
                      final isSelected = op.selectedSource == source;
                      return _OptionChip(
                        label: source,
                        isSelected: isSelected,
                        onTap: () =>
                            context.read<OrderProvider>().setOrderSource(source),
                        icon: _getSourceIcon(source),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Billing Breakdown', style: theme.textTheme.titleMedium),
                  const Divider(height: 20),
                  _SummaryRow(
                      label: 'Subtotal',
                      value: AppFormatters.currency(subtotal)),
                  if (taxAmt > 0) ...[
                    if (sp.taxMode == AppConstants.taxModeSplit) ...[
                      _SummaryRow(
                          label: 'SGST (${sp.defaultSgstPct}%)',
                          value: AppFormatters.currency(sgst)),
                      _SummaryRow(
                          label: 'CGST (${sp.defaultCgstPct}%)',
                          value: AppFormatters.currency(cgst)),
                    ] else
                      _SummaryRow(
                          label: 'IGST (${sp.defaultIgstPct}%)',
                          value: AppFormatters.currency(taxAmt)),
                  ],
                  if (op.deliveryFee > 0)
                    _SummaryRow(
                        label: 'Delivery Charge',
                        value: AppFormatters.currency(op.deliveryFee)),
                  if (op.discountAmount > 0)
                    _SummaryRow(
                        label: 'Discount',
                        value: '-${AppFormatters.currency(op.discountAmount)}',
                        valueColor: AppColors.inStock),
                  const Divider(height: 16),
                  _SummaryRow(
                    label: 'Total Payable',
                    value: AppFormatters.currency(finalTotal),
                    bold: true,
                    valueFontSize: 18,
                    valueColor: AppColors.accent,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Discount & Payment Method
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discount & Offers', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _discountController,
                          decoration: InputDecoration(
                            labelText: _discountIsPercent
                                ? 'Discount %'
                                : 'Discount ₹',
                            prefixIcon: const Icon(Icons.local_offer_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            _applyDiscount(
                                context.read<OrderProvider>(),
                                context.read<SettingsProvider>());
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ToggleButtons(
                        isSelected: [!_discountIsPercent, _discountIsPercent],
                        onPressed: (i) {
                          setState(() => _discountIsPercent = i == 1);
                          _applyDiscount(context.read<OrderProvider>(),
                              context.read<SettingsProvider>());
                        },
                        borderRadius: BorderRadius.circular(8),
                        children: const [Text('₹'), Text('%')],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (op.selectedSource == AppConstants.sourceStaff)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.badge_outlined,
                              color: Color(0xFF7C3AED), size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Staff Meal / Internal Consumption',
                                  style: TextStyle(
                                    color: Color(0xFF7C3AED),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Payment method not required. Order logged under Staff.',
                                  style: TextStyle(
                                    color: Color(0xFF7C3AED),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Text('Payment Method', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.paymentMethods.map((method) {
                        final isSelected = op.paymentMethod == method;
                        return _OptionChip(
                          label: method,
                          isSelected: isSelected,
                          onTap: () => context
                              .read<OrderProvider>()
                              .setPaymentMethod(method),
                          icon: _getPaymentIcon(method),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('← Back'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.accent,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 18),
                            SizedBox(width: 8),
                            Text('Complete Order',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final double valueFontSize;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueFontSize = 14,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: bold
                  ? null
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ── CUSTOM ACTIVE CHIP WIDGET ────────────────────────────────────────────────

class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : theme.dividerColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_circle, size: 16, color: Colors.white),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(icon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _getSourceIcon(String source) {
  switch (source) {
    case AppConstants.sourceCounter:
      return Icons.storefront_outlined;
    case AppConstants.sourceDineIn:
      return Icons.restaurant_outlined;
    case AppConstants.sourceTakeaway:
      return Icons.takeout_dining_outlined;
    case AppConstants.sourceDelivery:
      return Icons.delivery_dining_outlined;
    case AppConstants.sourceStaff:
      return Icons.badge_outlined;
    default:
      return Icons.receipt_long_outlined;
  }
}

IconData _getPaymentIcon(String method) {
  switch (method) {
    case AppConstants.paymentCash:
      return Icons.payments_outlined;
    case AppConstants.paymentUPI:
      return Icons.qr_code_scanner_outlined;
    case AppConstants.paymentCard:
      return Icons.credit_card_outlined;
    case AppConstants.paymentOnline:
      return Icons.language_outlined;
    default:
      return Icons.payment_outlined;
  }
}
