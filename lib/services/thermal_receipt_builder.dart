import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import '../data/db_types.dart';
import '../utils/constants.dart';

class ThermalReceiptBuilder {
  static final DateFormat _dtFmt = DateFormat('dd MMM yyyy, hh:mm a');
  static final NumberFormat _currFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: 'Rs. ',
    decimalDigits: 2,
  );

  static String _fmt(double v) => _currFmt.format(v);

  /// Builds ESC/POS bytes for an order receipt
  static Future<List<int>> buildOrderReceipt({
    required Order order,
    required List<OrderItem> items,
    required BusinessSetting business,
    required TaxSetting taxSettings,
    bool is80mm = false,
  }) async {
    final profile = await CapabilityProfile.load();
    final paperSize = is80mm ? PaperSize.mm80 : PaperSize.mm58;
    final generator = Generator(paperSize, profile);
    final List<int> bytes = [];

    // Reset printer & align center
    bytes.addAll(generator.reset());

    // ── HEADER: BUSINESS NAME & DETAILS ──
    final bName = business.businessName.isNotEmpty
        ? business.businessName
        : AppConstants.appName;
    bytes.addAll(generator.text(
      bName.toUpperCase(),
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));

    if (business.phone.isNotEmpty) {
      bytes.addAll(generator.text(
        'Ph: ${business.phone}',
        styles: const PosStyles(align: PosAlign.center),
      ));
    }

    if (business.address.isNotEmpty) {
      bytes.addAll(generator.text(
        business.address,
        styles: const PosStyles(align: PosAlign.center),
      ));
    }

    if (business.gstId.isNotEmpty) {
      bytes.addAll(generator.text(
        'GSTIN: ${business.gstId}',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ));
    }

    bytes.addAll(generator.hr(ch: '='));

    // ── ORDER DETAILS ──
    bytes.addAll(generator.text(
      'ORDER #${order.orderNumber}',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ));

    bytes.addAll(generator.text(
      'Date: ${_dtFmt.format(order.createdAt)}',
      styles: const PosStyles(align: PosAlign.center),
    ));

    final sourceStr = _sourceDisplay(order);
    bytes.addAll(generator.text(
      'Type: $sourceStr',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ));

    if (order.customerPhone != null && order.customerPhone!.isNotEmpty) {
      bytes.addAll(generator.text(
        'Customer: ${order.customerPhone}',
        styles: const PosStyles(align: PosAlign.center),
      ));
    }

    if (order.deliveryAddress != null && order.deliveryAddress!.isNotEmpty) {
      bytes.addAll(generator.text(
        'Address: ${order.deliveryAddress}',
        styles: const PosStyles(align: PosAlign.center),
      ));
    }

    bytes.addAll(generator.hr(ch: '-'));

    // ── ITEMS TABLE ──
    // 58mm total width is 12 columns in esc_pos_utils_plus PosColumn grid
    // For 58mm: Item (6), Qty (2), Total (4)
    // For 80mm: Item (6), Qty (2), Price (2), Total (2)
    if (is80mm) {
      bytes.addAll(generator.row([
        PosColumn(
          text: 'ITEM',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'PRICE',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
        PosColumn(
          text: 'TOTAL',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]));
    } else {
      bytes.addAll(generator.row([
        PosColumn(
          text: 'ITEM',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'TOTAL',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]));
    }

    bytes.addAll(generator.hr(ch: '-'));

    for (final item in items) {
      final lineTotalStr = _fmt(item.quantity * item.priceAtOrder);
      if (is80mm) {
        bytes.addAll(generator.row([
          PosColumn(text: item.itemName, width: 6),
          PosColumn(
            text: '${item.quantity}',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: _fmt(item.priceAtOrder),
            width: 2,
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: lineTotalStr,
            width: 2,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]));
      } else {
        bytes.addAll(generator.row([
          PosColumn(text: item.itemName, width: 6),
          PosColumn(
            text: '${item.quantity}',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: lineTotalStr,
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]));
      }

      if (item.specialInstructions.isNotEmpty) {
        bytes.addAll(generator.text(
          ' * ${item.specialInstructions}',
          styles: const PosStyles(align: PosAlign.left),
        ));
      }
    }

    bytes.addAll(generator.hr(ch: '-'));

    // ── BILLING SUMMARY ──
    final isDelivery = order.orderSource != AppConstants.sourceOffline;

    if (!isDelivery) {
      bytes.addAll(
          _buildSummaryRow(generator, 'Subtotal', _fmt(order.subtotal)));

      if (taxSettings.taxEnabled) {
        if (taxSettings.taxMode == AppConstants.taxModeSplit) {
          bytes.addAll(_buildSummaryRow(generator,
              'SGST (${taxSettings.sgstPct}%)', _fmt(order.sgstAmount)));
          bytes.addAll(_buildSummaryRow(generator,
              'CGST (${taxSettings.cgstPct}%)', _fmt(order.cgstAmount)));
        } else {
          bytes.addAll(_buildSummaryRow(generator,
              'IGST (${taxSettings.igstPct}%)', _fmt(order.taxAmount)));
        }
      }

      if (order.discountAmount > 0) {
        bytes.addAll(_buildSummaryRow(
            generator, 'Discount', '-${_fmt(order.discountAmount)}'));
      }

      if (order.deliveryFee > 0) {
        bytes.addAll(_buildSummaryRow(
            generator, 'Delivery Fee', _fmt(order.deliveryFee)));
      }

      bytes.addAll(generator.hr(ch: '='));

      // Total in bold
      bytes.addAll(generator.row([
        PosColumn(
          text: 'TOTAL AMOUNT:',
          width: 6,
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: _fmt(order.finalTotal),
          width: 6,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
      ]));

      bytes.addAll(generator.text(
        'Payment: ${order.paymentMethod.toUpperCase()} (${order.paymentStatus})',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ));
    } else {
      // Delivery / aggregator order
      bytes.addAll(
          _buildSummaryRow(generator, 'Subtotal', _fmt(order.subtotal)));
      if (order.deliveryFee > 0) {
        bytes.addAll(_buildSummaryRow(
            generator, 'Delivery Fee', _fmt(order.deliveryFee)));
      }
      bytes.addAll(
          _buildSummaryRow(generator, 'Gross Amount', _fmt(order.grossAmount)));
      bytes.addAll(_buildSummaryRow(
          generator, 'Platform Comm.', '-${_fmt(order.platformFee)}'));

      bytes.addAll(generator.hr(ch: '='));

      bytes.addAll(generator.row([
        PosColumn(
          text: 'NET EARNINGS:',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: _fmt(order.netEarnings),
          width: 6,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]));
    }

    // ── FOOTER ──
    bytes.addAll(generator.text(
      'Thank you! Visit again.',
      styles: const PosStyles(align: PosAlign.center),
    ));

    // Small ~1cm feed for clean tear off
    bytes.addAll(generator.feed(1));

    return bytes;
  }

  /// Builds ESC/POS bytes for a test receipt
  static Future<List<int>> buildTestReceipt({
    required BusinessSetting business,
    bool is80mm = false,
  }) async {
    final profile = await CapabilityProfile.load();
    final paperSize = is80mm ? PaperSize.mm80 : PaperSize.mm58;
    final generator = Generator(paperSize, profile);
    final List<int> bytes = [];

    bytes.addAll(generator.reset());

    final bName = business.businessName.isNotEmpty
        ? business.businessName
        : AppConstants.appName;
    bytes.addAll(generator.text(
      bName.toUpperCase(),
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));

    bytes.addAll(generator.text(
      '*** PRINTER TEST ***',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ));

    bytes.addAll(generator.hr(ch: '='));

    bytes.addAll(generator.text(
      'Bluetooth Thermal Printer connected successfully!',
      styles: const PosStyles(align: PosAlign.center),
    ));

    bytes.addAll(generator.text(
      'Paper Size: ${is80mm ? "80mm (Wide)" : "58mm (Standard)"}',
      styles: const PosStyles(align: PosAlign.center),
    ));

    bytes.addAll(generator.text(
      'Date: ${_dtFmt.format(DateTime.now())}',
      styles: const PosStyles(align: PosAlign.center),
    ));

    bytes.addAll(generator.hr(ch: '-'));

    bytes.addAll(generator.row([
      PosColumn(text: 'Test Item 1', width: 6),
      PosColumn(
          text: '1', width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: 'Rs. 25.00',
          width: 4,
          styles: const PosStyles(align: PosAlign.right)),
    ]));

    bytes.addAll(generator.row([
      PosColumn(text: 'Test Item 2', width: 6),
      PosColumn(
          text: '2', width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: 'Rs. 50.00',
          width: 4,
          styles: const PosStyles(align: PosAlign.right)),
    ]));

    bytes.addAll(generator.hr(ch: '='));

    bytes.addAll(generator.row([
      PosColumn(
          text: 'TEST TOTAL:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
          text: 'Rs. 75.00',
          width: 6,
          styles: const PosStyles(bold: true, align: PosAlign.right)),
    ]));

    bytes.addAll(generator.feed(1));

    return bytes;
  }

  static List<int> _buildSummaryRow(
    Generator generator,
    String label,
    String value,
  ) {
    return generator.row([
      PosColumn(
        text: label,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: value,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }

  static String _sourceDisplay(Order order) {
    if (order.deliveryAppName != null && order.deliveryAppName!.isNotEmpty) {
      return '${order.orderSource} (${order.deliveryAppName})';
    }
    return order.orderSource;
  }
}
