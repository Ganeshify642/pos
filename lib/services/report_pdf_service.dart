import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/db_types.dart';
import '../models/app_models.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class ReportPdfService {
  static Future<String> generatePdfReport({
    required DailyReport report,
    required List<ItemAnalytics> items,
    required BusinessSetting? business,
    required String dateRangeLabel,
  }) async {
    // Load NotoSans Gujarati and Latin fonts for Gujarati & ₹ (Rupee) symbol support
    final gujaratiFontData = await rootBundle.load('assets/fonts/NotoSansGujarati-Regular.ttf');
    final gujaratiBoldData = await rootBundle.load('assets/fonts/NotoSansGujarati-Bold.ttf');
    final latinFontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');

    final notoSansGujarati = pw.Font.ttf(gujaratiFontData);
    final notoSansGujaratiBold = pw.Font.ttf(gujaratiBoldData);
    final notoSansLatin = pw.Font.ttf(latinFontData);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: notoSansGujarati,
        bold: notoSansGujaratiBold,
        italic: notoSansGujarati,
        boldItalic: notoSansGujaratiBold,
        fontFallback: [notoSansGujarati, notoSansGujaratiBold, notoSansLatin],
      ),
    );

    final businessName = business?.businessName ?? AppConstants.appName;
    final phone = business?.phone ?? '';
    final address = business?.address ?? '';
    final gstId = business?.gstId ?? '';

    final primaryColor = PdfColor.fromHex('#EA580C'); // Gopal Vadapav Amber/Orange
    final headerBg = PdfColor.fromHex('#FFF7ED');
    final textColor = PdfColor.fromHex('#1E293B');
    final mutedText = PdfColor.fromHex('#64748B');
    final borderClr = PdfColor.fromHex('#E2E8F0');
    final greenColor = PdfColor.fromHex('#166534');

    // Totals
    final totalUnitsSold = items.fold(0, (sum, i) => sum + i.totalQtySold);
    final totalRevenue = report.totalRevenue;
    final totalProfit = items.fold(0.0, (sum, i) => sum + i.totalProfit);
    final avgMarginPct = totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0.0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      businessName,
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    if (address.isNotEmpty)
                      pw.Text(address, style: pw.TextStyle(fontSize: 9, color: mutedText)),
                    if (phone.isNotEmpty || gstId.isNotEmpty)
                      pw.Text(
                        'Phone: $phone ${gstId.isNotEmpty ? '| GSTIN: $gstId' : ''}',
                        style: pw.TextStyle(fontSize: 9, color: mutedText),
                      ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: headerBg,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Text(
                        'SALES & PERFORMANCE REPORT',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Period: $dateRangeLabel', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Generated: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}', style: pw.TextStyle(fontSize: 8, color: mutedText)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(color: borderClr, thickness: 1),
            pw.SizedBox(height: 10),
          ],
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Gopal Vadapav POS — Easy Offline Billing', style: pw.TextStyle(fontSize: 8, color: mutedText)),
            pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: pw.TextStyle(fontSize: 8, color: mutedText)),
          ],
        ),
        build: (context) => [
          // KPI Summary Cards Grid
          pw.Row(
            children: [
              _buildKpiCard('TOTAL SALES', AppFormatters.currency(totalRevenue), primaryColor),
              pw.SizedBox(width: 10),
              _buildKpiCard('TOTAL ORDERS', '${report.totalOrders}', PdfColor.fromHex('#0284C7')),
              pw.SizedBox(width: 10),
              _buildKpiCard('UNITS SOLD', '$totalUnitsSold', PdfColor.fromHex('#7C3AED')),
              pw.SizedBox(width: 10),
              _buildKpiCard('NET PROFIT', AppFormatters.currency(totalProfit), greenColor),
            ],
          ),

          pw.SizedBox(height: 16),

          // Secondary Metrics
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F8FAFC'),
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: borderClr),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text('Avg Order Value: ${AppFormatters.currency(report.avgOrderValue)}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: textColor)),
                pw.Text('|', style: pw.TextStyle(color: borderClr)),
                pw.Text('Overall Profit Margin: ${avgMarginPct.toStringAsFixed(1)}%', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: greenColor)),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Detailed Item Table Header
          pw.Text('Detailed Item Performance Breakdown', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: textColor)),
          pw.SizedBox(height: 8),

          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: borderClr, width: 0.5),
            headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: pw.BoxDecoration(color: primaryColor),
            rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 8),
            headerHeight: 22,
            cellHeight: 20,
            headers: [
              '#',
              'Item Name',
              'Category',
              'Qty Sold',
              'Price',
              'Cost',
              'Revenue',
              'Profit',
              'Margin %',
            ],
            data: items.asMap().entries.map((e) {
              final idx = e.key + 1;
              final item = e.value;
              return [
                '$idx',
                item.itemName,
                item.categoryName,
                '${item.totalQtySold}',
                AppFormatters.currency(item.sellingPrice),
                AppFormatters.currency(item.costPrice),
                AppFormatters.currency(item.totalRevenue),
                AppFormatters.currency(item.totalProfit),
                '${item.profitMarginPct.toStringAsFixed(0)}%',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final reportsFolder = Directory('${outputDir.path}/${AppConstants.reportDir}');
    if (!await reportsFolder.exists()) {
      await reportsFolder.create(recursive: true);
    }

    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${reportsFolder.path}/sales_report_$dateStr.pdf');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static pw.Widget _buildKpiCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#F8FAFC'),
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: color, width: 1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex('#64748B'), fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  static Future<void> shareOrPrintPdf(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bytes,
        name: 'Gopal_Vadapav_Sales_Report.pdf',
      );
    }
  }
}
