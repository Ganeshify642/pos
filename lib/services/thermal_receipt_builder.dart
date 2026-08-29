import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import '../data/db_types.dart';
import '../utils/constants.dart';

class ThermalReceiptBuilder {
  static final DateFormat _dtFmt = DateFormat('dd MMM yyyy, hh:mm a');
  static final NumberFormat _currFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String _fmt(double v) => _currFmt.format(v);

  /// Builds ESC/POS bytes for an order receipt using canvas raster bitmap
  /// to support Gujarati, Indic scripts, and Unicode without printer encoding errors.
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

    // Reset printer
    bytes.addAll(generator.reset());

    // Render receipt to high-contrast bitmap image
    final receiptImage = await _renderOrderReceiptToImage(
      order: order,
      items: items,
      business: business,
      taxSettings: taxSettings,
      is80mm: is80mm,
    );

    if (receiptImage != null) {
      bytes.addAll(generator.imageRaster(receiptImage));
    }

    // Feed & cut
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

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

    final testImage = await _renderTestReceiptToImage(
      business: business,
      is80mm: is80mm,
    );

    if (testImage != null) {
      bytes.addAll(generator.imageRaster(testImage));
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CANVAS RENDERER FOR ORDER RECEIPT
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<img.Image?> _renderOrderReceiptToImage({
    required Order order,
    required List<OrderItem> items,
    required BusinessSetting business,
    required TaxSetting taxSettings,
    required bool is80mm,
  }) async {
    final double canvasWidth = is80mm ? 576.0 : 384.0;
    final double padding = is80mm ? 10.0 : 5.0;
    final double contentWidth = canvasWidth - (padding * 2);

    // Pass 1: Measure total height
    final double totalHeight = _paintOrderReceipt(
      canvas: null,
      canvasWidth: canvasWidth,
      contentWidth: contentWidth,
      padding: padding,
      order: order,
      items: items,
      business: business,
      taxSettings: taxSettings,
      is80mm: is80mm,
    );

    // Pass 2: Draw on canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, canvasWidth, totalHeight),
    );

    // White background
    final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasWidth, totalHeight),
      bgPaint,
    );

    // Render contents
    _paintOrderReceipt(
      canvas: canvas,
      canvasWidth: canvasWidth,
      contentWidth: contentWidth,
      padding: padding,
      order: order,
      items: items,
      business: business,
      taxSettings: taxSettings,
      is80mm: is80mm,
    );

    final picture = recorder.endRecording();
    final uiImage = await picture.toImage(
      canvasWidth.toInt(),
      totalHeight.ceil(),
    );

    final ByteData? byteData =
        await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final Uint8List pngBytes = byteData.buffer.asUint8List();
    return img.decodePng(pngBytes);
  }

  static double _paintOrderReceipt({
    required Canvas? canvas,
    required double canvasWidth,
    required double contentWidth,
    required double padding,
    required Order order,
    required List<OrderItem> items,
    required BusinessSetting business,
    required TaxSetting taxSettings,
    required bool is80mm,
  }) {
    double y = 14.0;

    final bName = business.businessName.isNotEmpty
        ? business.businessName
        : AppConstants.appName;

    // ── 1. BUSINESS HEADER ──
    final bNameTp = _createTextPainter(
      text: bName.toUpperCase(),
      fontSize: is80mm ? 54.5 : 43.5,
      bold: true,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      bNameTp.paint(
        canvas,
        Offset(padding + (contentWidth - bNameTp.width) / 2, y),
      );
    }
    y += bNameTp.height + 5;

    if (business.phone.isNotEmpty) {
      final phoneTp = _createTextPainter(
        text: 'Ph: ${business.phone}',
        fontSize: is80mm ? 32 : 26,
        align: TextAlign.center,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        phoneTp.paint(
          canvas,
          Offset(padding + (contentWidth - phoneTp.width) / 2, y),
        );
      }
      y += phoneTp.height + 3;
    }

    if (business.address.isNotEmpty) {
      final addrTp = _createTextPainter(
        text: business.address,
        fontSize: is80mm ? 30.5 : 25,
        align: TextAlign.center,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        addrTp.paint(
          canvas,
          Offset(padding + (contentWidth - addrTp.width) / 2, y),
        );
      }
      y += addrTp.height + 3;
    }

    if (business.gstId.isNotEmpty) {
      final gstTp = _createTextPainter(
        text: 'GSTIN: ${business.gstId}',
        fontSize: is80mm ? 30.5 : 25,
        bold: true,
        align: TextAlign.center,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        gstTp.paint(
          canvas,
          Offset(padding + (contentWidth - gstTp.width) / 2, y),
        );
      }
      y += gstTp.height + 3;
    }

    // Double divider
    y += 6;
    y = _drawDivider(canvas, padding, y, contentWidth, isDouble: true);
    y += 8;

    // ── 2. ORDER DETAILS ──
    final orderNumTp = _createTextPainter(
      text: 'Order: #${order.orderNumber}',
      fontSize: is80mm ? 33.5 : 28.0,
      bold: true,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      orderNumTp.paint(canvas, Offset(padding, y));
    }
    y += orderNumTp.height + 3;

    final dateTp = _createTextPainter(
      text: 'Date: ${_dtFmt.format(order.createdAt)}',
      fontSize: is80mm ? 27.0 : 23.5,
      bold: true,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      dateTp.paint(canvas, Offset(padding, y));
    }
    y += dateTp.height + 4;

    final String custPhoneText =
        (order.customerPhone != null && order.customerPhone!.isNotEmpty)
            ? 'Ph: ${order.customerPhone}'
            : '';

    y = _drawRow(
      canvas: canvas,
      padding: padding,
      y: y,
      contentWidth: contentWidth,
      leftText: 'Source: ${_sourceDisplay(order)}',
      rightText: custPhoneText,
      fontSize: is80mm ? 32 : 25.5,
    );

    if (order.deliveryAppOrderId != null &&
        order.deliveryAppOrderId!.isNotEmpty) {
      final appOrderTp = _createTextPainter(
        text: 'App Order ID: ${order.deliveryAppOrderId}',
        fontSize: is80mm ? 32 : 25.5,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        appOrderTp.paint(canvas, Offset(padding, y));
      }
      y += appOrderTp.height + 3;
    }

    if (order.deliveryAddress != null && order.deliveryAddress!.isNotEmpty) {
      final addrTp = _createTextPainter(
        text: 'Address: ${order.deliveryAddress}',
        fontSize: is80mm ? 29 : 24,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        addrTp.paint(canvas, Offset(padding, y));
      }
      y += addrTp.height + 4;
    }

    // Divider
    y += 5;
    y = _drawDivider(canvas, padding, y, contentWidth);
    y += 8;

    // ── 3. ITEMS TABLE HEADER ──
    final double itemColWidth =
        is80mm ? contentWidth * 0.44 : contentWidth * 0.42;
    final double qtyColWidth =
        is80mm ? contentWidth * 0.12 : contentWidth * 0.13;
    final double priceColWidth =
        is80mm ? contentWidth * 0.22 : contentWidth * 0.225;
    final double totalColWidth =
        is80mm ? contentWidth * 0.22 : contentWidth * 0.225;

    final headerFontSize = is80mm ? 32.0 : 27.0;

    final headerItemTp = _createTextPainter(
      text: 'Item',
      fontSize: headerFontSize,
      bold: true,
      maxWidth: itemColWidth,
    );
    final headerQtyTp = _createTextPainter(
      text: 'Qty',
      fontSize: headerFontSize,
      bold: true,
      align: TextAlign.center,
      maxWidth: qtyColWidth,
    );
    final headerPriceTp = _createTextPainter(
      text: 'Rate',
      fontSize: headerFontSize,
      bold: true,
      align: TextAlign.right,
      maxWidth: priceColWidth,
    );
    final headerTotalTp = _createTextPainter(
      text: 'TOTAL',
      fontSize: headerFontSize,
      bold: true,
      align: TextAlign.right,
      maxWidth: totalColWidth,
    );

    if (canvas != null) {
      double curX = padding;
      headerItemTp.paint(canvas, Offset(curX, y));
      curX += itemColWidth;
      headerQtyTp.paint(
        canvas,
        Offset(curX + (qtyColWidth - headerQtyTp.width) / 2, y),
      );
      curX += qtyColWidth;
      headerPriceTp.paint(
        canvas,
        Offset(curX + (priceColWidth - headerPriceTp.width), y),
      );
      curX += priceColWidth;
      headerTotalTp.paint(
        canvas,
        Offset(curX + (totalColWidth - headerTotalTp.width), y),
      );
    }
    y += headerItemTp.height + 5;

    y = _drawDivider(canvas, padding, y, contentWidth);
    y += 6;

    // ── 4. ITEMS LIST ──
    final itemFontSize = is80mm ? 32.0 : 26.0;

    for (final item in items) {
      final lineTotalStr = _fmt(item.quantity * item.priceAtOrder);

      final itemTp = _createTextPainter(
        text: item.itemName,
        fontSize: itemFontSize,
        bold: true,
        maxWidth: itemColWidth - 4,
      );
      final qtyTp = _createTextPainter(
        text: '${item.quantity}',
        fontSize: itemFontSize,
        align: TextAlign.center,
        maxWidth: qtyColWidth,
      );
      final priceTp = _createTextPainter(
        text: _fmt(item.priceAtOrder),
        fontSize: itemFontSize,
        align: TextAlign.right,
        maxWidth: priceColWidth,
      );
      final totalTp = _createTextPainter(
        text: lineTotalStr,
        fontSize: itemFontSize,
        bold: true,
        align: TextAlign.right,
        maxWidth: totalColWidth,
      );

      final double rowHeight = [
        itemTp.height,
        qtyTp.height,
        priceTp.height,
        totalTp.height,
      ].reduce((a, b) => a > b ? a : b);

      if (canvas != null) {
        double curX = padding;
        itemTp.paint(canvas, Offset(curX, y));
        curX += itemColWidth;
        qtyTp.paint(
          canvas,
          Offset(curX + (qtyColWidth - qtyTp.width) / 2, y),
        );
        curX += qtyColWidth;
        priceTp.paint(
          canvas,
          Offset(curX + (priceColWidth - priceTp.width), y),
        );
        curX += priceColWidth;
        totalTp.paint(
          canvas,
          Offset(curX + (totalColWidth - totalTp.width), y),
        );
      }
      y += rowHeight + 4;

      if (item.specialInstructions.isNotEmpty) {
        final noteTp = _createTextPainter(
          text: ' * ${item.specialInstructions}',
          fontSize: is80mm ? 25 : 21.5,
          italic: true,
          maxWidth: contentWidth - 8,
        );
        if (canvas != null) {
          noteTp.paint(canvas, Offset(padding + 8, y));
        }
        y += noteTp.height + 3;
      }
    }

    y += 3;
    y = _drawDivider(canvas, padding, y, contentWidth);
    y += 8;

    // ── 5. BILLING SUMMARY ──
    final isDelivery = order.orderSource != AppConstants.sourceOffline;
    final summaryFontSize = is80mm ? 32.0 : 26.0;

    if (!isDelivery) {
      y = _drawRow(
        canvas: canvas,
        padding: padding,
        y: y,
        contentWidth: contentWidth,
        leftText: 'Subtotal',
        rightText: _fmt(order.subtotal),
        fontSize: summaryFontSize,
      );

      if (taxSettings.taxEnabled) {
        if (taxSettings.taxMode == AppConstants.taxModeSplit) {
          y = _drawRow(
            canvas: canvas,
            padding: padding,
            y: y,
            contentWidth: contentWidth,
            leftText: 'SGST (${taxSettings.sgstPct}%)',
            rightText: _fmt(order.sgstAmount),
            fontSize: summaryFontSize,
          );
          y = _drawRow(
            canvas: canvas,
            padding: padding,
            y: y,
            contentWidth: contentWidth,
            leftText: 'CGST (${taxSettings.cgstPct}%)',
            rightText: _fmt(order.cgstAmount),
            fontSize: summaryFontSize,
          );
        } else {
          y = _drawRow(
            canvas: canvas,
            padding: padding,
            y: y,
            contentWidth: contentWidth,
            leftText: 'IGST (${taxSettings.igstPct}%)',
            rightText: _fmt(order.taxAmount),
            fontSize: summaryFontSize,
          );
        }
      }

      if (order.discountAmount > 0) {
        y = _drawRow(
          canvas: canvas,
          padding: padding,
          y: y,
          contentWidth: contentWidth,
          leftText: 'Discount',
          rightText: '-${_fmt(order.discountAmount)}',
          fontSize: summaryFontSize,
        );
      }

      if (order.deliveryFee > 0) {
        y = _drawRow(
          canvas: canvas,
          padding: padding,
          y: y,
          contentWidth: contentWidth,
          leftText: 'Delivery Fee',
          rightText: _fmt(order.deliveryFee),
          fontSize: summaryFontSize,
        );
      }

      y += 5;
      y = _drawDivider(canvas, padding, y, contentWidth, isDouble: true);
      y += 8;

      // TOTAL AMOUNT (Large & Bold)
      y = _drawRow(
        canvas: canvas,
        padding: padding,
        y: y,
        contentWidth: contentWidth,
        leftText: 'TOTAL AMOUNT:',
        rightText: _fmt(order.finalTotal),
        fontSize: is80mm ? 33.5 : 26,
        leftBold: true,
        rightBold: true,
      );

      final payTp = _createTextPainter(
        text:
            'Payment: ${order.paymentMethod.toUpperCase()} (${order.paymentStatus})',
        fontSize: is80mm ? 29.5 : 25,
        bold: true,
        align: TextAlign.center,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        payTp.paint(
          canvas,
          Offset(padding + (contentWidth - payTp.width) / 2, y),
        );
      }
      y += payTp.height + 5;
    } else {
      // Aggregator / Delivery Order
      y = _drawRow(
        canvas: canvas,
        padding: padding,
        y: y,
        contentWidth: contentWidth,
        leftText: 'Item Subtotal',
        rightText: _fmt(order.subtotal),
        fontSize: summaryFontSize,
      );
      if (order.deliveryFee > 0) {
        y = _drawRow(
          canvas: canvas,
          padding: padding,
          y: y,
          contentWidth: contentWidth,
          leftText: 'Delivery Fee',
          rightText: _fmt(order.deliveryFee),
          fontSize: summaryFontSize,
        );
      }
      y = _drawRow(
        canvas: canvas,
        padding: padding,
        y: y,
        contentWidth: contentWidth,
        leftText: 'Gross Amount',
        rightText: _fmt(order.grossAmount),
        fontSize: summaryFontSize,
      );
      y = _drawRow(
        canvas: canvas,
        padding: padding,
        y: y,
        contentWidth: contentWidth,
        leftText: 'Platform Fee (Commission)',
        rightText: '-${_fmt(order.platformFee)}',
        fontSize: summaryFontSize,
      );

      y += 5;
      y = _drawDivider(canvas, padding, y, contentWidth, isDouble: true);
      y += 8;

      y = _drawRow(
        canvas: canvas,
        padding: padding,
        y: y,
        contentWidth: contentWidth,
        leftText: 'YOUR NET EARNINGS:',
        rightText: _fmt(order.netEarnings),
        fontSize: is80mm ? 43.5 : 36,
        leftBold: true,
        rightBold: true,
      );

      final statusTp = _createTextPainter(
        text: 'Status: PAID (via ${_sourceDisplay(order)})',
        fontSize: is80mm ? 29.5 : 25,
        bold: true,
        align: TextAlign.center,
        maxWidth: contentWidth,
      );
      if (canvas != null) {
        statusTp.paint(
          canvas,
          Offset(padding + (contentWidth - statusTp.width) / 2, y),
        );
      }
      y += statusTp.height + 5;
    }

    y += 5;
    y = _drawDivider(canvas, padding, y, contentWidth);
    y += 10;

    // ── 6. FOOTER ──
    final thankTp = _createTextPainter(
      text: 'Thank you for your order!',
      fontSize: is80mm ? 32 : 27,
      bold: true,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      thankTp.paint(
        canvas,
        Offset(padding + (contentWidth - thankTp.width) / 2, y),
      );
    }
    y += thankTp.height + 4;

    final refTp = _createTextPainter(
      text: 'Order Ref: #${order.orderNumber}',
      fontSize: is80mm ? 27 : 23.5,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      refTp.paint(
        canvas,
        Offset(padding + (contentWidth - refTp.width) / 2, y),
      );
    }
    y += refTp.height + 3;

    final powerTp = _createTextPainter(
      text: 'Powered by ${AppConstants.appName}',
      fontSize: is80mm ? 23.5 : 20.5,
      italic: true,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      powerTp.paint(
        canvas,
        Offset(padding + (contentWidth - powerTp.width) / 2, y),
      );
    }
    y += powerTp.height + 18; // bottom margin

    return y;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CANVAS RENDERER FOR TEST RECEIPT
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<img.Image?> _renderTestReceiptToImage({
    required BusinessSetting business,
    required bool is80mm,
  }) async {
    final double canvasWidth = is80mm ? 576.0 : 384.0;
    final double padding = is80mm ? 10.0 : 5.0;
    final double contentWidth = canvasWidth - (padding * 2);

    final double totalHeight = _paintTestReceipt(
      canvas: null,
      canvasWidth: canvasWidth,
      contentWidth: contentWidth,
      padding: padding,
      business: business,
      is80mm: is80mm,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, canvasWidth, totalHeight),
    );

    final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasWidth, totalHeight),
      bgPaint,
    );

    _paintTestReceipt(
      canvas: canvas,
      canvasWidth: canvasWidth,
      contentWidth: contentWidth,
      padding: padding,
      business: business,
      is80mm: is80mm,
    );

    final picture = recorder.endRecording();
    final uiImage = await picture.toImage(
      canvasWidth.toInt(),
      totalHeight.ceil(),
    );

    final ByteData? byteData =
        await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final Uint8List pngBytes = byteData.buffer.asUint8List();
    return img.decodePng(pngBytes);
  }

  static double _paintTestReceipt({
    required Canvas? canvas,
    required double canvasWidth,
    required double contentWidth,
    required double padding,
    required BusinessSetting business,
    required bool is80mm,
  }) {
    double y = 14.0;

    final bName = business.businessName.isNotEmpty
        ? business.businessName
        : AppConstants.appName;

    final bNameTp = _createTextPainter(
      text: bName.toUpperCase(),
      fontSize: is80mm ? 54.5 : 43.5,
      bold: true,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      bNameTp.paint(
        canvas,
        Offset(padding + (contentWidth - bNameTp.width) / 2, y),
      );
    }
    y += bNameTp.height + 5;

    final testHeaderTp = _createTextPainter(
      text: '*** PRINTER TEST ***',
      fontSize: is80mm ? 33.5 : 29,
      bold: true,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      testHeaderTp.paint(
        canvas,
        Offset(padding + (contentWidth - testHeaderTp.width) / 2, y),
      );
    }
    y += testHeaderTp.height + 6;

    y = _drawDivider(canvas, padding, y, contentWidth, isDouble: true);
    y += 6;

    final msgTp = _createTextPainter(
      text: 'Bluetooth Thermal Printer connected successfully!',
      fontSize: is80mm ? 30.5 : 25,
      align: TextAlign.center,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      msgTp.paint(
        canvas,
        Offset(padding + (contentWidth - msgTp.width) / 2, y),
      );
    }
    y += msgTp.height + 4;

    y = _drawRow(
      canvas: canvas,
      padding: padding,
      y: y,
      contentWidth: contentWidth,
      leftText: 'Paper Size:',
      rightText: is80mm ? '80mm (Wide)' : '58mm (Standard)',
      fontSize: is80mm ? 30.5 : 25,
      rightBold: true,
    );

    final testDateTp = _createTextPainter(
      text: 'Date: ${_dtFmt.format(DateTime.now())}',
      fontSize: is80mm ? 29.5 : 24.5,
      maxWidth: contentWidth,
    );
    if (canvas != null) {
      testDateTp.paint(canvas, Offset(padding, y));
    }
    y += testDateTp.height + 4;

    y += 5;
    y = _drawDivider(canvas, padding, y, contentWidth);
    y += 6;

    final double itemColWidth =
        is80mm ? contentWidth * 0.44 : contentWidth * 0.42;
    final double qtyColWidth =
        is80mm ? contentWidth * 0.12 : contentWidth * 0.13;
    final double priceColWidth =
        is80mm ? contentWidth * 0.22 : contentWidth * 0.225;
    final double totalColWidth =
        is80mm ? contentWidth * 0.22 : contentWidth * 0.225;
    final headerFontSize = is80mm ? 25.0 : 22.0;
    final itemFontSize = is80mm ? 25.0 : 22.0;

    final hItemTp = _createTextPainter(
      text: 'ITEM',
      fontSize: headerFontSize,
      bold: true,
      maxWidth: itemColWidth,
    );
    final hQtyTp = _createTextPainter(
      text: 'QTY',
      fontSize: headerFontSize,
      bold: true,
      align: TextAlign.center,
      maxWidth: qtyColWidth,
    );
    final hPriceTp = _createTextPainter(
      text: 'PRICE',
      fontSize: headerFontSize,
      bold: true,
      align: TextAlign.right,
      maxWidth: priceColWidth,
    );
    final hTotalTp = _createTextPainter(
      text: 'TOTAL',
      fontSize: headerFontSize,
      bold: true,
      align: TextAlign.right,
      maxWidth: totalColWidth,
    );

    if (canvas != null) {
      double curX = padding;
      hItemTp.paint(canvas, Offset(curX, y));
      curX += itemColWidth;
      hQtyTp.paint(canvas, Offset(curX + (qtyColWidth - hQtyTp.width) / 2, y));
      curX += qtyColWidth;
      hPriceTp.paint(
          canvas, Offset(curX + (priceColWidth - hPriceTp.width), y));
      curX += priceColWidth;
      hTotalTp.paint(
          canvas, Offset(curX + (totalColWidth - hTotalTp.width), y));
    }
    y += hItemTp.height + 5;
    y = _drawDivider(canvas, padding, y, contentWidth);
    y += 6;

    final testItems = [
      {
        'name': 'ટેસ્ટ આઇટમ ૧ (Test 1)',
        'qty': '1',
        'price': '₹25.00',
        'total': '₹25.00'
      },
      {
        'name': 'ટેસ્ટ આઇટમ ૨ (Test 2)',
        'qty': '2',
        'price': '₹25.00',
        'total': '₹50.00'
      },
    ];

    for (final tItem in testItems) {
      final itemTp = _createTextPainter(
        text: tItem['name']!,
        fontSize: itemFontSize,
        bold: true,
        maxWidth: itemColWidth - 4,
      );
      final qtyTp = _createTextPainter(
        text: tItem['qty']!,
        fontSize: itemFontSize,
        align: TextAlign.center,
        maxWidth: qtyColWidth,
      );
      final priceTp = _createTextPainter(
        text: tItem['price']!,
        fontSize: itemFontSize,
        align: TextAlign.right,
        maxWidth: priceColWidth,
      );
      final totalTp = _createTextPainter(
        text: tItem['total']!,
        fontSize: itemFontSize,
        bold: true,
        align: TextAlign.right,
        maxWidth: totalColWidth,
      );

      final double rowHeight = [
        itemTp.height,
        qtyTp.height,
        priceTp.height,
        totalTp.height,
      ].reduce((a, b) => a > b ? a : b);

      if (canvas != null) {
        double curX = padding;
        itemTp.paint(canvas, Offset(curX, y));
        curX += itemColWidth;
        qtyTp.paint(canvas, Offset(curX + (qtyColWidth - qtyTp.width) / 2, y));
        curX += qtyColWidth;
        priceTp.paint(
            canvas, Offset(curX + (priceColWidth - priceTp.width), y));
        curX += priceColWidth;
        totalTp.paint(
            canvas, Offset(curX + (totalColWidth - totalTp.width), y));
      }
      y += rowHeight + 4;
    }

    y += 5;
    y = _drawDivider(canvas, padding, y, contentWidth, isDouble: true);
    y += 8;

    y = _drawRow(
      canvas: canvas,
      padding: padding,
      y: y,
      contentWidth: contentWidth,
      leftText: 'TEST TOTAL:',
      rightText: '₹75.00',
      fontSize: is80mm ? 42 : 34,
      leftBold: true,
      rightBold: true,
    );

    y += 18;
    return y;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DRAWING HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static TextPainter _createTextPainter({
    required String text,
    required double fontSize,
    bool bold = false,
    bool italic = false,
    TextAlign align = TextAlign.left,
    double? maxWidth,
  }) {
    final span = TextSpan(
      text: text,
      style: TextStyle(
        color: const Color(0xFF000000),
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: 'NotoSansGujarati',
        fontFamilyFallback: const [
          'NotoSansGujarati',
          'NotoSans',
          'Roboto',
          'sans-serif',
        ],
      ),
    );
    final tp = TextPainter(
      text: span,
      textAlign: align,
      textDirection: ui.TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth ?? double.infinity);
    return tp;
  }

  static double _drawDivider(
    Canvas? canvas,
    double padding,
    double y,
    double contentWidth, {
    bool isDouble = false,
  }) {
    if (canvas != null) {
      final paint = Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = isDouble ? 2.6 : 1.6;

      canvas.drawLine(
        Offset(padding, y),
        Offset(padding + contentWidth, y),
        paint,
      );

      if (isDouble) {
        canvas.drawLine(
          Offset(padding, y + 4),
          Offset(padding + contentWidth, y + 4),
          paint,
        );
      }
    }
    return y + (isDouble ? 5.0 : 2.0);
  }

  static double _drawRow({
    required Canvas? canvas,
    required double padding,
    required double y,
    required double contentWidth,
    required String leftText,
    required String rightText,
    required double fontSize,
    bool leftBold = false,
    bool rightBold = false,
  }) {
    final rightTp = _createTextPainter(
      text: rightText,
      fontSize: fontSize,
      bold: rightBold,
      align: TextAlign.right,
      maxWidth: contentWidth * 0.50,
    );

    final leftMaxWidth = contentWidth - rightTp.width - 6;
    final leftTp = _createTextPainter(
      text: leftText,
      fontSize: fontSize,
      bold: leftBold,
      maxWidth: leftMaxWidth,
    );

    final rowHeight =
        leftTp.height > rightTp.height ? leftTp.height : rightTp.height;

    if (canvas != null) {
      leftTp.paint(canvas, Offset(padding, y));
      rightTp.paint(
        canvas,
        Offset(padding + contentWidth - rightTp.width, y),
      );
    }

    return y + rowHeight + 4;
  }

  static String _sourceDisplay(Order order) {
    if (order.deliveryAppName != null && order.deliveryAppName!.isNotEmpty) {
      return '${order.orderSource} (${order.deliveryAppName})';
    }
    return order.orderSource;
  }
}
