import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database/app_database.dart';
import '../providers/inventory_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/order_provider.dart';
import '../providers/printer_provider.dart';
import '../providers/report_provider.dart';
import '../providers/settings_provider.dart';
import '../services/mock_data_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/printer_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Business form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();

  // Tax controllers
  final _sgstController = TextEditingController();
  final _cgstController = TextEditingController();
  final _igstController = TextEditingController();

  bool _initialized = false;
  bool _loadingMockData = false;

  Future<void> _handleLoadMockData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Load Demo Menu?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content: const Text(
          'This will populate sample menu items and categories for your shop. Existing items will be refreshed.',
          style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Load Data'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loadingMockData = true);

    try {
      final db = context.read<AppDatabase>();
      await MockDataService.loadVadapavMockData(db);

      if (mounted) {
        await context.read<SettingsProvider>().loadSettings();
        await context.read<MenuProvider>().loadAll();
        await context.read<InventoryProvider>().loadInventoryStatus();
        await context.read<OrderProvider>().loadOrders();
        await context.read<ReportProvider>().loadReport();

        // Update controllers
        final s = context.read<SettingsProvider>();
        _nameController.text = s.businessSettings?.businessName ?? '';
        _phoneController.text = s.businessSettings?.phone ?? '';
        _addressController.text = s.businessSettings?.address ?? '';
        _gstController.text = s.businessSettings?.gstId ?? '';

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo menu loaded successfully'),
            backgroundColor: AppColors.inStock,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load mock data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMockData = false);
    }
  }

  Future<void> _handleClearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Data?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content: const Text(
          'Delete all menu items, stock inventory, and orders? This action cannot be undone.',
          style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Clear Everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loadingMockData = true);

    try {
      final db = context.read<AppDatabase>();
      await MockDataService.clearAllData(db);

      if (mounted) {
        await context.read<MenuProvider>().loadAll();
        await context.read<InventoryProvider>().loadInventoryStatus();
        await context.read<OrderProvider>().loadOrders();
        await context.read<ReportProvider>().loadReport();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMockData = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final settings = context.read<SettingsProvider>();
      _nameController.text = settings.businessSettings?.businessName ?? '';
      _phoneController.text = settings.businessSettings?.phone ?? '';
      _addressController.text = settings.businessSettings?.address ?? '';
      _gstController.text = settings.businessSettings?.gstId ?? '';
      _sgstController.text = '${settings.defaultSgstPct}';
      _cgstController.text = '${settings.defaultCgstPct}';
      _igstController.text = '${settings.defaultIgstPct}';
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    _sgstController.dispose();
    _cgstController.dispose();
    _igstController.dispose();
    super.dispose();
  }

  InputDecoration _minimalInputDecoration(String label, {String? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      suffixText: suffix,
      suffixStyle: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // ── BUSINESS INFO ──────────────────────────────────────────
          _sectionLabel('STORE INFORMATION'),
          _GroupedCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: _minimalInputDecoration('Store / Business Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: _minimalInputDecoration('Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: _minimalInputDecoration('Address'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _gstController,
                      decoration: _minimalInputDecoration('GSTIN (Optional)'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          await settings.saveBusinessSettings(
                            businessName: _nameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            gstId: _gstController.text,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Store information saved'),
                                backgroundColor: AppColors.inStock,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Save Store Info', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── ORDER MODES ────────────────────────────────────────────
          _sectionLabel('ORDER MODES'),
          _GroupedCard(
            children: [
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                value: settings.orderModesEnabled,
                onChanged: (v) => settings.setOrderModesEnabled(v),
                activeTrackColor: AppColors.primary,
                title: const Text(
                  'Multi-mode Fulfillment',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                ),
                subtitle: const Text(
                  'Enable Dine-In, Takeaway, and Delivery at checkout',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── TAX SETTINGS ───────────────────────────────────────────
          _sectionLabel('TAX CONFIGURATION'),
          _GroupedCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tax Type',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        ),
                        SegmentedButton<String>(
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            selectedBackgroundColor: const Color(0xFFFFF0ED),
                            selectedForegroundColor: AppColors.primary,
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          selected: {settings.taxMode},
                          onSelectionChanged: (v) {
                            settings.saveTaxSettings(
                              sgstPct: double.tryParse(_sgstController.text) ?? AppConstants.defaultSgstPct,
                              cgstPct: double.tryParse(_cgstController.text) ?? AppConstants.defaultCgstPct,
                              igstPct: double.tryParse(_igstController.text) ?? AppConstants.defaultIgstPct,
                              taxMode: v.first,
                              taxEnabled: settings.taxEnabled,
                            );
                          },
                          segments: const [
                            ButtonSegment(
                              value: 'SGST+CGST',
                              label: Text('SGST+CGST', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                            ButtonSegment(
                              value: 'IGST',
                              label: Text('IGST', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (settings.taxMode == AppConstants.taxModeSplit) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _sgstController,
                              decoration: _minimalInputDecoration('SGST Rate', suffix: '%'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _cgstController,
                              decoration: _minimalInputDecoration('CGST Rate', suffix: '%'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      TextField(
                        controller: _igstController,
                        decoration: _minimalInputDecoration('IGST Rate', suffix: '%'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: settings.taxEnabled,
                      onChanged: (v) => settings.saveTaxSettings(
                        sgstPct: double.tryParse(_sgstController.text) ?? AppConstants.defaultSgstPct,
                        cgstPct: double.tryParse(_cgstController.text) ?? AppConstants.defaultCgstPct,
                        igstPct: double.tryParse(_igstController.text) ?? AppConstants.defaultIgstPct,
                        taxMode: settings.taxMode,
                        taxEnabled: v,
                      ),
                      activeTrackColor: AppColors.primary,
                      title: const Text(
                        'Apply Tax on Checkout',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await settings.saveTaxSettings(
                            sgstPct: double.tryParse(_sgstController.text) ?? AppConstants.defaultSgstPct,
                            cgstPct: double.tryParse(_cgstController.text) ?? AppConstants.defaultCgstPct,
                            igstPct: double.tryParse(_igstController.text) ?? AppConstants.defaultIgstPct,
                            taxMode: settings.taxMode,
                            taxEnabled: settings.taxEnabled,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tax rates updated'),
                                backgroundColor: AppColors.inStock,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F172A),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Save Tax Rates', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── THERMAL PRINTER ────────────────────────────────────────
          _sectionLabel('THERMAL PRINTER'),
          Consumer<PrinterProvider>(
            builder: (context, printer, _) {
              final isConnected = printer.isConnected;
              final isBtOn = printer.isBluetoothEnabled;

              return _GroupedCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !isBtOn
                                ? Colors.red
                                : isConnected
                                    ? AppColors.inStock
                                    : Colors.amber.shade700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                !isBtOn
                                    ? 'Bluetooth Disabled'
                                    : isConnected
                                        ? (printer.connectedPrinter?.name ?? 'Connected Printer')
                                        : 'No Printer Connected',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                !isBtOn
                                    ? 'Turn on Bluetooth'
                                    : isConnected
                                        ? 'Ready for receipts'
                                        : 'Tap to connect printer',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => PrinterDialog.show(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            visualDensity: VisualDensity.compact,
                          ),
                          child: Text(isConnected ? 'Manage' : 'Connect', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  if (isConnected) ...[
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: printer.isPrinting
                                  ? null
                                  : () async {
                                      if (settings.businessSettings != null) {
                                        final ok = await printer.printTestReceipt(
                                          business: settings.businessSettings!,
                                        );
                                        if (context.mounted && ok) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Test receipt printed'),
                                              backgroundColor: AppColors.inStock,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0F172A),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              icon: printer.isPrinting
                                  ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.receipt_outlined, size: 15),
                              label: Text(
                                printer.isPrinting ? 'Printing...' : 'Test Print',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => printer.disconnect(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text('Disconnect', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Paper Size',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        ),
                        SegmentedButton<String>(
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            selectedBackgroundColor: const Color(0xFFFFF0ED),
                            selectedForegroundColor: AppColors.primary,
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          selected: {printer.paperSize},
                          onSelectionChanged: (set) => printer.setPaperSize(set.first),
                          segments: const [
                            ButtonSegment(
                              value: '58mm',
                              label: Text('58mm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                            ButtonSegment(
                              value: '80mm',
                              label: Text('80mm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    value: printer.autoPrintOnOrder,
                    onChanged: (v) => printer.setAutoPrintOnOrder(v),
                    activeTrackColor: AppColors.primary,
                    title: const Text(
                      'Auto-print on checkout',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // ── DATA MANAGEMENT ────────────────────────────────────────
          _sectionLabel('DATA MANAGEMENT'),
          _GroupedCard(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: const Text('Load Demo Menu Items', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                subtitle: const Text('Populate demo categories and items', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                trailing: _loadingMockData
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : TextButton(
                        onPressed: _loadingMockData ? null : _handleLoadMockData,
                        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                        child: const Text('Load', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: Text('Clear All Data', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red.shade600)),
                subtitle: const Text('Delete all products, stock & orders', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                trailing: TextButton(
                  onPressed: _loadingMockData ? null : _handleClearAllData,
                  style: TextButton.styleFrom(foregroundColor: Colors.red.shade600),
                  child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── ABOUT ──────────────────────────────────────────────────
          _sectionLabel('ABOUT'),
          _GroupedCard(
            children: [
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: Text('Version', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
                trailing: Text('1.0.0', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: const Text('Developed By', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
                trailing: Text(
                  'DevamJyot Infotech & Ganeshify',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF94A3B8),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _GroupedCard extends StatelessWidget {
  final List<Widget> children;

  const _GroupedCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _DeliveryAppCard extends StatefulWidget {
  final dynamic app;
  const _DeliveryAppCard({required this.app});

  @override
  State<_DeliveryAppCard> createState() => _DeliveryAppCardState();
}

class _DeliveryAppCardState extends State<_DeliveryAppCard> {
  late TextEditingController _commissionController;
  late TextEditingController _feeController;

  @override
  void initState() {
    super.initState();
    _commissionController =
        TextEditingController(text: '${widget.app.commissionPct}');
    _feeController = TextEditingController(text: '${widget.app.fixedFee}');
  }

  @override
  void dispose() {
    _commissionController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.app.appName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commissionController,
                  decoration: const InputDecoration(
                    labelText: 'Commission %',
                    isDense: true,
                    suffix: Text('%'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _feeController,
                  decoration: const InputDecoration(
                    labelText: 'Fee ₹',
                    isDense: true,
                    prefix: Text('₹'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  context.read<SettingsProvider>().saveDeliveryAppSettings(
                        widget.app.appName,
                        double.tryParse(_commissionController.text) ??
                            AppConstants.defaultCommissionPct,
                        double.tryParse(_feeController.text) ?? 0,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved'), behavior: SnackBarBehavior.floating),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
