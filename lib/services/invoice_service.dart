import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../data/db_types.dart';
import '../utils/constants.dart';

class InvoiceService {
  static final DateFormat _dtFmt = DateFormat('dd MMM yyyy, hh:mm a');
  static final NumberFormat _currFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String _fmt(double v) => _currFmt.format(v);

  /// Generate PDF invoice for an order and return the saved file path
  static Future<String> generateInvoice({
    required Order order,
    required List<OrderItem> items,
    required BusinessSetting businessSettings,
    required TaxSetting taxSettings,
  }) async {
    // Load Gujarati fonts with Latin fallback so Gujarati and English/₹ text render properly
    final gujaratiFontData =
        await rootBundle.load('assets/fonts/NotoSansGujarati-Regular.ttf');
    final gujaratiBoldData =
        await rootBundle.load('assets/fonts/NotoSansGujarati-Bold.ttf');
    final latinFontData =
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');

    final notoSansGujarati = pw.Font.ttf(gujaratiFontData);
    final notoSansGujaratiBold = pw.Font.ttf(gujaratiBoldData);
    final notoSansLatin = pw.Font.ttf(latinFontData);

    final pdf = pw.Document(
      title: 'Invoice ${order.orderNumber}',
      author: businessSettings.businessName,
      theme: pw.ThemeData.withFont(
        base: notoSansGujarati,
        bold: notoSansGujaratiBold,
        italic: notoSansGujarati,
        boldItalic: notoSansGujaratiBold,
        fontFallback: [notoSansGujarati, notoSansGujaratiBold, notoSansLatin],
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm, // 80mm width
          double.infinity,
          marginAll: 3 * PdfPageFormat.mm,
        ),
        build: (ctx) => _buildPage(
          ctx: ctx,
          order: order,
          items: items,
          business: businessSettings,
          taxSettings: taxSettings,
        ),
      ),
    );

    // Save to documents/invoices/
    final dir = await getApplicationDocumentsDirectory();
    final invoiceDir = Directory('${dir.path}/${AppConstants.invoiceDir}');
    if (!await invoiceDir.exists()) {
      await invoiceDir.create(recursive: true);
    }

    final dateStr = DateFormat('yyyyMMdd').format(order.createdAt);
    final fileName = 'ORDER_${order.orderNumber}_$dateStr.pdf';
    final file = File('${invoiceDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static pw.Widget _buildPage({
    required pw.Context ctx,
    required Order order,
    required List<OrderItem> items,
    required BusinessSetting business,
    required TaxSetting taxSettings,
  }) {
    final isDelivery = order.orderSource != AppConstants.sourceOffline;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // ── BUSINESS HEADER (-5% Fine-tuned) ──
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                business.businessName.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 40.5,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              if (business.phone.isNotEmpty)
                pw.Text(
                  'Ph: ${business.phone}',
                  style: const pw.TextStyle(fontSize: 25),
                ),
              if (business.address.isNotEmpty)
                pw.Text(
                  business.address,
                  style: const pw.TextStyle(fontSize: 24.5),
                  textAlign: pw.TextAlign.center,
                ),
              if (business.gstId.isNotEmpty)
                pw.Text(
                  'GSTIN: ${business.gstId}',
                  style: pw.TextStyle(
                    fontSize: 24.5,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),

        pw.SizedBox(height: 11),
        _divider(),
        pw.SizedBox(height: 11),

        // ── ORDER DETAILS ──
        pw.Text(
          'Order: #${order.orderNumber}',
          style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          'Date: ${_dtFmt.format(order.createdAt)}',
          style: pw.TextStyle(fontSize: 24.5, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 3),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Source: ${_sourceDisplay(order)}',
              style: const pw.TextStyle(fontSize: 25),
            ),
            if (order.customerPhone != null && order.customerPhone!.isNotEmpty)
              pw.Text(
                'Ph: ${order.customerPhone}',
                style: const pw.TextStyle(fontSize: 24.5),
              ),
          ],
        ),
        if (isDelivery &&
            order.deliveryAppOrderId != null &&
            order.deliveryAppOrderId!.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 3),
            child: pw.Text(
              'App Order ID: ${order.deliveryAppOrderId}',
              style: const pw.TextStyle(fontSize: 24.5),
            ),
          ),

        pw.SizedBox(height: 11),
        _divider(),
        pw.SizedBox(height: 5),

        // ── ITEMS TABLE HEADER ──
        pw.Row(
          children: [
            pw.Expanded(
              flex: 5,
              child: pw.Text(
                'Item',
                style: pw.TextStyle(fontSize: 24.5, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(
              width: 40,
              child: pw.Text(
                'Qty',
                style: pw.TextStyle(fontSize: 24.5, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(
              width: 70,
              child: pw.Text(
                'Price',
                style: pw.TextStyle(fontSize: 24.5, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.SizedBox(
              width: 74,
              child: pw.Text(
                'Total',
                style: pw.TextStyle(fontSize: 24.5, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),

        _divider(),

        // ── ITEMS ──
        ...items.map((OrderItem item) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 5,
                      child: pw.Text(
                        item.itemName,
                        style: const pw.TextStyle(fontSize: 22.5),
                      ),
                    ),
                    pw.SizedBox(
                      width: 40,
                      child: pw.Text(
                        '${item.quantity}',
                        style: const pw.TextStyle(fontSize: 22.5),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(
                      width: 70,
                      child: pw.Text(
                        _fmt(item.priceAtOrder),
                        style: const pw.TextStyle(fontSize: 22.5),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.SizedBox(
                      width: 74,
                      child: pw.Text(
                        _fmt(item.quantity * item.priceAtOrder),
                        style: const pw.TextStyle(fontSize: 22.5),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                if (item.specialInstructions.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 8, bottom: 3),
                    child: pw.Text(
                      '* ${item.specialInstructions}',
                      style: pw.TextStyle(
                        fontSize: 19,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            )),

        _divider(),
        pw.SizedBox(height: 9),

        // ── BILLING SUMMARY ──
        if (!isDelivery) ...[
          _summaryRow('Subtotal', _fmt(order.subtotal)),
          if (taxSettings.taxEnabled) ...[
            if (taxSettings.taxMode == AppConstants.taxModeSplit) ...[
              _summaryRow(
                  'SGST (${taxSettings.sgstPct}%)', _fmt(order.sgstAmount)),
              _summaryRow(
                  'CGST (${taxSettings.cgstPct}%)', _fmt(order.cgstAmount)),
            ] else ...[
              _summaryRow(
                  'IGST (${taxSettings.igstPct}%)', _fmt(order.taxAmount)),
            ],
          ],
          if (order.discountAmount > 0)
            _summaryRow('Discount', '-${_fmt(order.discountAmount)}'),
          if (order.deliveryFee > 0)
            _summaryRow('Delivery Fee', _fmt(order.deliveryFee)),
          _divider(),
          _summaryRow('TOTAL', _fmt(order.finalTotal), bold: true, large: true),
          pw.SizedBox(height: 4),
          _summaryRow(
            'Payment',
            '${order.paymentMethod.toUpperCase()} (${order.paymentStatus})',
            bold: false,
          ),
        ] else ...[
          _summaryRow('Item Subtotal', _fmt(order.subtotal)),
          if (order.deliveryFee > 0)
            _summaryRow('Delivery Fee', _fmt(order.deliveryFee)),
          _summaryRow('Gross Amount', _fmt(order.grossAmount)),
          _summaryRow(
            'Platform Fee (Commission)',
            '-${_fmt(order.platformFee)}',
          ),
          _divider(),
          _summaryRow('YOUR NET EARNINGS', _fmt(order.netEarnings),
              bold: true, large: true),
          pw.SizedBox(height: 4),
          _summaryRow('Status', 'PAID (via ${_sourceDisplay(order)})',
              bold: true),
        ],

        pw.SizedBox(height: 11),
        _divider(),
        pw.SizedBox(height: 9),

        // ── FOOTER ──
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'Thank you for your order!',
                style:
                    pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Order Ref: #${order.orderNumber}',
                style: const pw.TextStyle(fontSize: 24.5),
              ),
              pw.Text(
                'Generated: ${_dtFmt.format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 22),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Powered by ${AppConstants.appName}',
                style:
                    pw.TextStyle(fontSize: 17.5, fontStyle: pw.FontStyle.italic),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _divider() {
    return pw.Divider(thickness: 1.1, color: PdfColors.grey700);
  }

  static pw.Widget _summaryRow(String label, String value,
      {bool bold = false, bool large = false}) {
    final style = pw.TextStyle(
      fontSize: large ? 30 : 24.5,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  static String _sourceDisplay(Order order) {
    if (order.deliveryAppName != null && order.deliveryAppName!.isNotEmpty) {
      return '${order.orderSource} (${order.deliveryAppName})';
    }
    return order.orderSource;
  }
}
