import '../data/db_types.dart';
import '../utils/constants.dart';

/// Handles all financial and order calculations for offline POS
class CalculationService {
  // ─── TAX CALCULATIONS ─────────────────────────────────────────────────

  /// Calculate SGST + CGST on subtotal
  static double calculateSgst(double subtotal, double sgstPct) {
    return (subtotal * sgstPct) / 100;
  }

  static double calculateCgst(double subtotal, double cgstPct) {
    return (subtotal * cgstPct) / 100;
  }

  static double calculateIgst(double subtotal, double igstPct) {
    return (subtotal * igstPct) / 100;
  }

  /// Calculate total tax based on mode
  static ({double taxAmount, double sgst, double cgst}) calculateTax({
    required double subtotal,
    required TaxSetting taxSettings,
  }) {
    if (!taxSettings.taxEnabled) {
      return (taxAmount: 0, sgst: 0, cgst: 0);
    }

    if (taxSettings.taxMode == AppConstants.taxModeSplit) {
      final sgst = calculateSgst(subtotal, taxSettings.sgstPct);
      final cgst = calculateCgst(subtotal, taxSettings.cgstPct);
      return (taxAmount: sgst + cgst, sgst: sgst, cgst: cgst);
    } else {
      final igst = calculateIgst(subtotal, taxSettings.igstPct);
      return (taxAmount: igst, sgst: 0, cgst: 0);
    }
  }

  // ─── ORDER TOTALS ─────────────────────────────────────────────────────

  static ({
    double subtotal,
    double taxAmount,
    double sgst,
    double cgst,
    double finalTotal,
  }) calculateOfflineOrderTotal({
    required List<({int qty, double price})> items,
    required TaxSetting taxSettings,
    double discountAmount = 0,
    double deliveryFee = 0,
  }) {
    final subtotal =
        items.fold(0.0, (sum, item) => sum + (item.qty * item.price));
    final taxResult = calculateTax(subtotal: subtotal, taxSettings: taxSettings);
    final finalTotal =
        (subtotal + taxResult.taxAmount + deliveryFee - discountAmount).clamp(0, double.infinity);

    return (
      subtotal: subtotal,
      taxAmount: taxResult.taxAmount,
      sgst: taxResult.sgst,
      cgst: taxResult.cgst,
      finalTotal: finalTotal.toDouble(),
    );
  }

  // ─── ORDER NUMBER ─────────────────────────────────────────────────────

  static String generateOrderNumber(int sequence, [DateTime? date]) {
    final d = date ?? DateTime.now();
    final dateStr = '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
    return 'ORD-$dateStr-${sequence.toString().padLeft(3, '0')}';
  }

  // ─── DISCOUNT ─────────────────────────────────────────────────────────

  static double calculatePercentageDiscount(
      double subtotal, double discountPct) {
    return (subtotal * discountPct) / 100;
  }
}
