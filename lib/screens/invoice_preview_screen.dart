import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../models/app_models.dart';
import '../providers/order_provider.dart';
import '../providers/printer_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/printer_dialog.dart';
import 'home_screen.dart';
import 'order_details_screen.dart';

class InvoicePreviewScreen extends StatefulWidget {
  final int orderId;
  final String? invoicePath;
  final bool autoPrint;

  const InvoicePreviewScreen({
    super.key,
    required this.orderId,
    this.invoicePath,
    this.autoPrint = true,
  });

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  bool _sharing = false;
  bool _isPrintingThermal = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoPrint) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final printer = context.read<PrinterProvider>();
        if (printer.isConnected) {
          _printThermal();
        }
      });
    }
  }

  Future<void> _shareInvoice() async {
    if (widget.invoicePath == null) return;
    setState(() => _sharing = true);
    try {
      await Share.shareXFiles(
        [XFile(widget.invoicePath!)],
        subject: 'Invoice - Order #${widget.orderId}',
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _printThermal() async {
    final printer = context.read<PrinterProvider>();
    final settings = context.read<SettingsProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (!printer.isConnected) {
      // Prompt to connect printer
      await PrinterDialog.show(context);
      return;
    }

    if (settings.businessSettings == null || settings.taxSettings == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings not loaded. Please try again.')),
      );
      return;
    }

    setState(() => _isPrintingThermal = true);

    try {
      final OrderSummary? summary =
          await orderProvider.getOrderSummary(widget.orderId);

      if (summary == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not load order details for printing.')),
          );
        }
        return;
      }

      final success = await printer.printOrderReceipt(
        order: summary.order,
        items: summary.items,
        business: settings.businessSettings!,
        taxSettings: settings.taxSettings!,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receipt printed on thermal printer!'),
              backgroundColor: AppColors.inStock,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(printer.errorMessage ?? 'Thermal print failed. Check Bluetooth connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isPrintingThermal = false);
    }
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final path = widget.invoicePath;
    final printer = context.watch<PrinterProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Invoice #${widget.orderId}',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              printer.isConnected
                  ? Icons.print_rounded
                  : Icons.print_outlined,
              size: 20,
              color: printer.isConnected ? AppColors.inStock : const Color(0xFF64748B),
            ),
            tooltip: printer.isConnected
                ? 'Printer Connected (${printer.connectedPrinter?.name ?? "Thermal Printer"})'
                : 'Manage Thermal Printer',
            onPressed: () => PrinterDialog.show(context),
          ),
          if (path != null)
            IconButton(
              icon: _sharing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.share_outlined, size: 20, color: Color(0xFF64748B)),
              onPressed: _sharing ? null : _shareInvoice,
              tooltip: 'Share Invoice',
            ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 20, color: Color(0xFF64748B)),
            tooltip: 'View Order Details',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: widget.orderId)),
            ),
          ),
          const SizedBox(width: 6),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      body: Column(
        children: [
          // Minimalist Banner (Printer status + Order success)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: printer.isConnected ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
            child: Row(
              children: [
                Icon(
                  printer.isConnected ? Icons.check_circle_outline_rounded : Icons.bluetooth_searching,
                  size: 16,
                  color: printer.isConnected ? AppColors.inStock : const Color(0xFFB45309),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    printer.isConnected
                        ? 'Ready: ${printer.connectedPrinter?.name ?? "Thermal Printer"}'
                        : 'Thermal printer not connected',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: printer.isConnected ? const Color(0xFF065F46) : const Color(0xFF92400E),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => PrinterDialog.show(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      printer.isConnected ? 'Change' : 'Connect',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PDF Preview Area (Cleaned: removed bottom orange toolbar overlap)
          Expanded(
            child: path != null
                ? Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: PdfPreview(
                      build: (_) => File(path).readAsBytes(),
                      allowPrinting: false,
                      allowSharing: false,
                      canChangePageFormat: false,
                      canDebug: false,
                      canChangeOrientation: false,
                      pdfFileName: 'Invoice_${widget.orderId}.pdf',
                      loadingWidget: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 56,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Invoice could not be generated',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
          ),

          // Minimalist Bottom Bar: Done & Print buttons side-by-side
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Done button
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _goHome,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F172A),
                          side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                        label: const Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Print Thermal Receipt button
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: _isPrintingThermal ? null : _printThermal,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: _isPrintingThermal
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.print_rounded, size: 18),
                        label: Text(
                          _isPrintingThermal
                              ? 'Printing...'
                              : printer.isConnected
                                  ? 'Print Receipt (${printer.paperSize})'
                                  : 'Print Receipt',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
