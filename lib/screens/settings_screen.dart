import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

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
