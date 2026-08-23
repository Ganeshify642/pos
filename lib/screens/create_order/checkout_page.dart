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

          // Order Type selector (only when modes enabled in Settings)
          if (sp.orderModesEnabled)
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
                      children: [
                        AppConstants.sourceCounter,
                        AppConstants.sourceDineIn,
                        AppConstants.sourceTakeaway,
                        AppConstants.sourceDelivery,
                      ].map((source) {
                        final isSelected = op.selectedSource == source;
                        return ChoiceChip(
                          label: Text(source),
                          selected: isSelected,
                          onSelected: (_) =>
                              context.read<OrderProvider>().setOrderSource(source),
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
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
                  const SizedBox(height: 14),
                  Text('Payment Method', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: AppConstants.paymentMethods.map((method) {
                      final isSelected = op.paymentMethod == method;
                      return ChoiceChip(
                        label: Text(method),
                        selected: isSelected,
                        onSelected: (_) => context
                            .read<OrderProvider>()
                            .setPaymentMethod(method),
                        selectedColor: AppColors.primary.withOpacity(0.15),
                      );
                    }).toList(),
                  ),
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
