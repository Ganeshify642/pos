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
        title: const Row(
          children: [
            Icon(Icons.fastfood_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Expanded(child: Text('Load Vadapav Shop Data?')),
          ],
        ),
        content: const Text(
          'This will populate:\n\n'
          '• 18+ Vadapav shop menu items (Classic, Cheese, Samosa Pav, Bhajiya, Chai & Combos)\n'
          '• 5 Categories (Vadapav Specials, Samosa & Puffs, Snacks, Beverages, Combos)\n'
          '• Daily stock & preparation inventory\n'
          '• 13+ sample orders with PDF invoices (Counter, Dine-In, Takeaway, Swiggy, Zomato)\n\n'
          'Existing items and orders will be replaced with fresh mock data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.fastfood, size: 16),
            label: const Text('Load Demo Data'),
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
            content: Text('Vadapav Shop Mock Data loaded successfully!'),
            backgroundColor: AppColors.inStock,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load mock data: $e'),
            backgroundColor: Colors.red,
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
        title: const Text('Clear All Data?'),
        content: const Text(
          'Are you sure you want to delete all menu items, inventory, and order history? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All'),
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
          const SnackBar(content: Text('All data cleared successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear data: $e'),
            backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Business Info ──────────────────────────────────────────
          _SectionHeader('Business Information'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Business Name',
                      prefixIcon: Icon(Icons.store_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _gstController,
                    decoration: const InputDecoration(
                      labelText: 'GSTIN',
                      prefixIcon: Icon(Icons.receipt_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                                content: Text('Business settings saved')),
                          );
                        }
                      },
                      child: const Text('Save Business Info'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Order Modes ────────────────────────────────────────────
          _SectionHeader('Order Modes'),
          Card(
            child: SwitchListTile(
              value: settings.orderModesEnabled,
              onChanged: (v) => settings.setOrderModesEnabled(v),
              title: const Text('Enable Dine-In / Takeaway / Delivery'),
              subtitle: const Text(
                  'When off, all orders are Counter orders. Turn on to choose Dine-In, Takeaway or Delivery at checkout.'),
              activeColor: AppColors.primary,
              secondary: Icon(
                settings.orderModesEnabled
                    ? Icons.restaurant_menu_rounded
                    : Icons.point_of_sale_rounded,
                color: settings.orderModesEnabled
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Tax Settings ───────────────────────────────────────────
          _SectionHeader('Tax Configuration'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tax mode toggle
                  Row(
                    children: [
                      Expanded(
                        child: Text('Tax Mode',
                            style: theme.textTheme.titleSmall),
                      ),
                      SegmentedButton<String>(
                        selected: {settings.taxMode},
                        onSelectionChanged: (v) {
                          settings.saveTaxSettings(
                            sgstPct: double.tryParse(_sgstController.text) ??
                                AppConstants.defaultSgstPct,
                            cgstPct: double.tryParse(_cgstController.text) ??
                                AppConstants.defaultCgstPct,
                            igstPct: double.tryParse(_igstController.text) ??
                                AppConstants.defaultIgstPct,
                            taxMode: v.first,
                            taxEnabled: settings.taxEnabled,
                          );
                        },
                        segments: const [
                          ButtonSegment(
                              value: 'SGST+CGST', label: Text('SGST+CGST')),
                          ButtonSegment(
                              value: 'IGST', label: Text('IGST')),
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
                            decoration: const InputDecoration(
                              labelText: 'SGST %',
                              suffix: Text('%'),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cgstController,
                            decoration: const InputDecoration(
                              labelText: 'CGST %',
                              suffix: Text('%'),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    TextField(
                      controller: _igstController,
                      decoration: const InputDecoration(
                        labelText: 'IGST %',
                        suffix: Text('%'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Enable Tax', style: theme.textTheme.titleSmall),
                      const Spacer(),
                      Switch.adaptive(
                        value: settings.taxEnabled,
                        onChanged: (v) => settings.saveTaxSettings(
                          sgstPct: double.tryParse(_sgstController.text) ??
                              AppConstants.defaultSgstPct,
                          cgstPct: double.tryParse(_cgstController.text) ??
                              AppConstants.defaultCgstPct,
                          igstPct: double.tryParse(_igstController.text) ??
                              AppConstants.defaultIgstPct,
                          taxMode: settings.taxMode,
                          taxEnabled: v,
                        ),
                        activeColor: AppColors.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await settings.saveTaxSettings(
                          sgstPct: double.tryParse(_sgstController.text) ??
                              AppConstants.defaultSgstPct,
                          cgstPct: double.tryParse(_cgstController.text) ??
                              AppConstants.defaultCgstPct,
                          igstPct: double.tryParse(_igstController.text) ??
                              AppConstants.defaultIgstPct,
                          taxMode: settings.taxMode,
                          taxEnabled: settings.taxEnabled,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tax settings saved')),
                          );
                        }
                      },
                      child: const Text('Save Tax Settings'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Thermal Printer (Bluetooth) ─────────────────────────────
          _SectionHeader('Bluetooth Thermal Printer'),
          Consumer<PrinterProvider>(
            builder: (context, printer, _) {
              final isConnected = printer.isConnected;
              final isBtOn = printer.isBluetoothEnabled;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Banner
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: !isBtOn
                                  ? Colors.red.withValues(alpha: 0.12)
                                  : isConnected
                                      ? AppColors.inStock.withValues(alpha: 0.12)
                                      : Colors.amber.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              !isBtOn
                                  ? Icons.bluetooth_disabled
                                  : isConnected
                                      ? Icons.check_circle_outline
                                      : Icons.print_disabled_outlined,
                              color: !isBtOn
                                  ? Colors.red
                                  : isConnected
                                      ? AppColors.inStock
                                      : Colors.amber.shade800,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  !isBtOn
                                      ? 'Bluetooth Disabled'
                                      : isConnected
                                          ? (printer.connectedPrinter?.name ??
                                              'Thermal Printer')
                                          : 'No Printer Connected',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  !isBtOn
                                      ? 'Turn ON Bluetooth to connect printer'
                                      : isConnected
                                          ? 'Ready for receipt printing'
                                          : 'Connect your ESC/POS thermal printer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => PrinterDialog.show(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isConnected
                                  ? theme.colorScheme.surfaceContainerHighest
                                  : AppColors.primary,
                              foregroundColor: isConnected
                                  ? theme.colorScheme.onSurface
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                            ),
                            child: Text(isConnected ? 'Manage' : 'Connect'),
                          ),
                        ],
                      ),

                      if (isConnected) ...[
                        const Divider(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: printer.isPrinting
                                    ? null
                                    : () async {
                                        if (settings.businessSettings != null) {
                                          final ok = await printer
                                              .printTestReceipt(
                                            business:
                                                settings.businessSettings!,
                                          );
                                          if (context.mounted && ok) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Test receipt printed successfully!'),
                                                backgroundColor:
                                                    AppColors.inStock,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                icon: printer.isPrinting
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.receipt_long, size: 16),
                                label: Text(printer.isPrinting
                                    ? 'Printing...'
                                    : 'Print Test Receipt'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => printer.disconnect(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Disconnect'),
                            ),
                          ],
                        ),
                      ],

                      const Divider(height: 24),

                      // Paper Size Selection
                      Row(
                        children: [
                          Text('Paper Size',
                              style: theme.textTheme.titleSmall),
                          const Spacer(),
                          SegmentedButton<String>(
                            selected: {printer.paperSize},
                            onSelectionChanged: (set) =>
                                printer.setPaperSize(set.first),
                            segments: const [
                              ButtonSegment(
                                value: '58mm',
                                label: Text('58mm (Small)'),
                              ),
                              ButtonSegment(
                                value: '80mm',
                                label: Text('80mm'),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Auto-print switch
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Auto-print New Orders',
                            style: TextStyle(fontSize: 14)),
                        subtitle: const Text(
                          'Automatically print receipt when order checkout completes',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: printer.autoPrintOnOrder,
                        onChanged: (v) => printer.setAutoPrintOnOrder(v),
                        activeTrackColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ── Appearance ────────────────────────────────────────────
          _SectionHeader('Appearance'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text('Dark Mode', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  Switch.adaptive(
                    value: settings.themeMode == ThemeMode.dark,
                    onChanged: (v) => settings.setThemeMode(
                        v ? ThemeMode.dark : ThemeMode.light),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Testing & Demo Data ─────────────────────────────────────
          _SectionHeader('Testing & Demo Data'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.fastfood_rounded,
                            color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vadapav Shop Mock Data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Populate realistic items, stock & orders for testing',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loads 18+ menu items (Classic Vadapav, Cheese Burst, Samosa Pav, Bhajiya, Masala Chai & Combos), 5 categories, daily stock inventory, and 13+ sample orders with PDF invoices for quick billing, reporting & thermal printer testing.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _loadingMockData ? null : _handleLoadMockData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: _loadingMockData
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.download_rounded, size: 18),
                          label: Text(_loadingMockData
                              ? 'Loading Data...'
                              : 'Load Vadapav Mock Data'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed:
                            _loadingMockData ? null : _handleClearAllData,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── About ──────────────────────────────────────────────────
          _SectionHeader('About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  trailing: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.wifi_off, color: AppColors.accent),
                  title: const Text('Offline Mode'),
                  subtitle: const Text('100% offline — no internet required'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 1,
        ),
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
    final (color, _) = _appStyle(widget.app.appName);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.app.appName,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _feeController,
                    decoration: const InputDecoration(
                      labelText: 'Fixed Fee ₹',
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
                      const SnackBar(content: Text('Saved')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _appStyle(String name) {
    return (AppColors.primary, name);
  }
}
