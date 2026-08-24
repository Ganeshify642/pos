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

  const InvoicePreviewScreen({
    super.key,
    required this.orderId,
    this.invoicePath,
  });

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  bool _sharing = false;
  bool _isPrintingThermal = false;

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
      appBar: AppBar(
        title: const Text('Invoice Generated'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              printer.isConnected
                  ? Icons.print_rounded
                  : Icons.print_outlined,
              color: printer.isConnected ? AppColors.inStock : null,
            ),
            tooltip: printer.isConnected
                ? 'Printer Connected (${printer.connectedPrinter?.name ?? "Thermal Printer"})'
                : 'Manage Thermal Printer',
            onPressed: () => PrinterDialog.show(context),
          ),
          if (path != null)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: _sharing ? null : _shareInvoice,
              tooltip: 'Share Invoice',
            ),
          TextButton(
            onPressed: _goHome,
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Success banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.accent.withValues(alpha: 0.1),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Created Successfully!',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (path != null)
                        Text(
                          'Invoice saved to device',
                          style: TextStyle(
                            color: AppColors.accent.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Quick Thermal Printer Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: printer.isConnected
                  ? AppColors.inStock.withValues(alpha: 0.08)
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              border: Border(
                bottom: BorderSide(
                  color: printer.isConnected
                      ? AppColors.inStock.withValues(alpha: 0.2)
                      : theme.dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  printer.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_searching,
                  size: 16,
                  color: printer.isConnected
                      ? AppColors.inStock
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    printer.isConnected
                        ? 'Connected: ${printer.connectedPrinter?.name ?? "Thermal Printer"}'
                        : 'Thermal Printer not connected',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: printer.isConnected
                          ? AppColors.inStock
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => PrinterDialog.show(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(
                      printer.isConnected ? 'Change' : 'Connect',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PDF Preview
          Expanded(
            child: path != null
                ? PdfPreview(
                    build: (_) => File(path).readAsBytes(),
                    allowPrinting: true,
                    allowSharing: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    pdfFileName: 'Invoice_${widget.orderId}.pdf',
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Invoice could not be generated',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
          ),

          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Primary Thermal Print Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isPrintingThermal ? null : _printThermal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isPrintingThermal
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.print_rounded, size: 20),
                    label: Text(
                      _isPrintingThermal
                          ? 'Printing Thermal Receipt...'
                          : printer.isConnected
                              ? 'Print Thermal Receipt (${printer.paperSize})'
                              : 'Connect & Print Thermal Receipt',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => OrderDetailsScreen(
                                    orderId: widget.orderId))),
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('View Order'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _sharing ? null : _shareInvoice,
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: _sharing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ))
                            : const Text('Share PDF'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
