import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Generated'),
        automaticallyImplyLeading: false,
        actions: [
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
            color: AppColors.accent.withOpacity(0.1),
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
                            color: AppColors.accent.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
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
                            color: theme.colorScheme.onSurface.withOpacity(0.3)),
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
            child: Row(
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
                  child: ElevatedButton.icon(
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
          ),
        ],
      ),
    );
  }
}
