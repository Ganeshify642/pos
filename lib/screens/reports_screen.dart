import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_models.dart';
import '../providers/report_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

import '../providers/settings_provider.dart';
import '../services/report_pdf_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadReport();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _downloadPdfReport() async {
    final reportProvider = context.read<ReportProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    if (reportProvider.report == null) return;

    setState(() => _isExporting = true);
    try {
      final filePath = await ReportPdfService.generatePdfReport(
        report: reportProvider.report!,
        items: reportProvider.filteredItemAnalytics,
        business: settingsProvider.businessSettings,
        dateRangeLabel: reportProvider.selectedRange,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF Report generated! Opening preview...'),
            backgroundColor: AppColors.primary,
          ),
        );
        await ReportPdfService.shareOrPrintPdf(filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report: $e'),
            backgroundColor: AppColors.outOfStock,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = context.watch<ReportProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Insights'),
        actions: [
          IconButton(
            icon: _isExporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            tooltip: 'Download PDF Report',
            onPressed: _isExporting ? null : _downloadPdfReport,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Revenue'),
            Tab(text: 'Orders'),
            Tab(text: 'Item Insights'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date range selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...AppConstants.dateRanges.take(4).map((r) {
                    final isSelected = report.selectedRange == r;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(r),
                        selected: isSelected,
                        onSelected: (_) =>
                            context.read<ReportProvider>().setRange(r),
                        selectedColor: AppColors.primary.withOpacity(0.15),
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primary : null,
                          fontWeight: isSelected ? FontWeight.w600 : null,
                        ),
                      ),
                    );
                  }),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month, size: 16),
                    label: const Text('Custom'),
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (range != null && context.mounted) {
                        context
                            .read<ReportProvider>()
                            .setCustomRange(range.start, range.end);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Tab views
          Expanded(
            child: report.isLoading
                ? const Center(child: CircularProgressIndicator())
                : report.report == null
                    ? const Center(child: Text('No data for this period'))
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _RevenueTab(report: report.report!),
                          _OrdersTab(report: report.report!),
                          const _ItemAnalyticsTab(),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Revenue Tab ──────────────────────────────────────────────────────────────

class _RevenueTab extends StatelessWidget {
  final DailyReport report;
  const _RevenueTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sourceEntries = report.bySource.entries.toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Total revenue highlight
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.revenueGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Revenue',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                AppFormatters.currency(report.totalRevenue),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Orders: ${report.totalOrders}  •  Avg/Order: ${AppFormatters.currency(report.avgOrderValue)}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Revenue by Order Type
        Text('Revenue by Order Type', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),

        // Pie chart — shows whenever there is any data
        if (report.totalRevenue > 0 && sourceEntries.isNotEmpty)
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sourceEntries.asMap().entries.map((e) {
                  final idx = e.key;
                  final source = e.value.key;
                  final stat = e.value.value;
                  final pct = report.totalRevenue > 0
                      ? (stat.grossRevenue / report.totalRevenue * 100)
                      : 0.0;
                  return PieChartSectionData(
                    value: stat.grossRevenue,
                    title: '${pct.toStringAsFixed(0)}%',
                    color: _sourceColor(source, idx),
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),

        if (report.totalRevenue > 0 && sourceEntries.isNotEmpty) ...[
          const SizedBox(height: 10),
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: sourceEntries.asMap().entries.map((e) {
              final idx = e.key;
              final source = e.value.key;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _sourceColor(source, idx),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(source, style: const TextStyle(fontSize: 12)),
                ],
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 16),

        // Source breakdown cards
        ...sourceEntries.asMap().entries.map((e) {
          final idx = e.key;
          final s = e.value.key;
          final stat = e.value.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _sourceColor(s, idx),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(s,
                            style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('${stat.orderCount} orders',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _RevenueMetric(
                            label: 'Gross Sales',
                            value: AppFormatters.currency(stat.grossRevenue),
                          ),
                        ),
                        Expanded(
                          child: _RevenueMetric(
                            label: 'Avg Order Value',
                            value: AppFormatters.currency(stat.avgOrderValue),
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        if (report.totalOrders == 0)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No orders for this period',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  // Color palette cycling for any order source
  Color _sourceColor(String s, int idx) {
    const palette = [
      Color(0xFF4F46E5), // Indigo — Counter/Dine-In
      Color(0xFFD97706), // Amber — Takeaway
      Color(0xFF059669), // Emerald — Delivery
      Color(0xFFDC2626), // Red
      Color(0xFF7C3AED), // Purple
      Color(0xFF0284C7), // Blue
    ];
    return switch (s) {
      AppConstants.sourceDineIn => const Color(0xFF4F46E5),
      AppConstants.sourceTakeaway => const Color(0xFFD97706),
      AppConstants.sourceDelivery => const Color(0xFF059669),
      AppConstants.sourceCounter => const Color(0xFFEA580C),
      _ => palette[idx % palette.length],
    };
  }
}

class _RevenueMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _RevenueMetric(
      {required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            )),
        Text(value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color ?? Theme.of(context).colorScheme.onSurface,
            )),
      ],
    );
  }
}

// ── Orders Tab ───────────────────────────────────────────────────────────────

class _OrdersTab extends StatelessWidget {
  final DailyReport report;
  const _OrdersTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Total orders highlight
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Orders',
                      style: theme.textTheme.bodySmall),
                  Text(
                    '${report.totalOrders}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Avg Order Value',
                      style: theme.textTheme.bodySmall),
                  Text(
                    AppFormatters.currency(report.avgOrderValue),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Orders by source (bar chart)
        if (report.bySource.isNotEmpty) ...[
          Text('Orders by Type', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: report.bySource.entries.toList().asMap().entries.map((e) {
                  final idx = e.key;
                  final source = e.value.value;
                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: source.orderCount.toDouble(),
                        color: _sourceColor(source.source),
                        width: 28,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final sources = report.bySource.keys.toList();
                        if (v.toInt() >= sources.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          sources[v.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _sourceColor(String s) {
    return switch (s) {
      AppConstants.sourceDineIn => const Color(0xFF4F46E5),
      AppConstants.sourceTakeaway => const Color(0xFFD97706),
      AppConstants.sourceDelivery => const Color(0xFF059669),
      _ => AppColors.primary,
    };
  }
}

// ── Detailed Item Analytics & Performance Tab ────────────────────────────────

class _ItemAnalyticsTab extends StatelessWidget {
  const _ItemAnalyticsTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ReportProvider>();
    final items = provider.filteredItemAnalytics;

    // Totals calculations
    final totalUnitsSold =
        items.fold(0, (sum, i) => sum + i.totalQtySold);
    final totalRevenue =
        items.fold(0.0, (sum, i) => sum + i.totalRevenue);
    final totalProfit =
        items.fold(0.0, (sum, i) => sum + i.totalProfit);
    final avgMarginPct =
        totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0.0;

    final maxQty = items.isEmpty
        ? 1.0
        : items
            .map((i) => i.totalQtySold)
            .reduce((a, b) => a > b ? a : b)
            .toDouble();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary KPI Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Item Performance Summary',
                  style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _KpiBox(
                      label: 'Units Sold',
                      value: '$totalUnitsSold',
                    ),
                  ),
                  Expanded(
                    child: _KpiBox(
                      label: 'Product Sales',
                      value: AppFormatters.currency(totalRevenue),
                    ),
                  ),
                  Expanded(
                    child: _KpiBox(
                      label: 'Gross Profit',
                      value: AppFormatters.currency(totalProfit),
                      valueColor: AppColors.inStock,
                    ),
                  ),
                  Expanded(
                    child: _KpiBox(
                      label: 'Avg Margin',
                      value: '${avgMarginPct.toStringAsFixed(1)}%',
                      valueColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Search & Sort bar
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search items or category...',
                  prefixIcon: Icon(Icons.search, size: 18),
                  isDense: true,
                ),
                onChanged: (q) => provider.setItemSearchQuery(q),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              initialValue: provider.itemSortBy,
              icon: const Icon(Icons.sort_rounded),
              tooltip: 'Sort By',
              onSelected: (v) => provider.setItemSortBy(v),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'qty', child: Text('Sort by Units Sold')),
                PopupMenuItem(value: 'revenue', child: Text('Sort by Revenue')),
                PopupMenuItem(value: 'profit', child: Text('Sort by Profit')),
                PopupMenuItem(value: 'margin', child: Text('Sort by Margin %')),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text('No item sales data for this period'),
            ),
          )
        else
          ...items.asMap().entries.map((e) {
            final rank = e.key + 1;
            final item = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: rank <= 3
                                  ? AppColors.primary.withOpacity(0.15)
                                  : theme.dividerColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '#$rank',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: rank <= 3
                                      ? AppColors.primary
                                      : theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.itemName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    )),
                                Text(
                                  '${item.categoryName}  •  Cost: ${AppFormatters.currency(item.costPrice)} | Price: ${AppFormatters.currency(item.sellingPrice)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _marginColor(item.profitMarginPct)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _marginColor(item.profitMarginPct)
                                    .withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              '${item.profitMarginPct.toStringAsFixed(0)}% margin',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _marginColor(item.profitMarginPct),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Units sold bar
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: item.totalQtySold / maxQty,
                              backgroundColor:
                                  theme.dividerColor.withOpacity(0.2),
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.primary),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${item.totalQtySold} sold',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      // Metrics row (Revenue, Cost, Profit, Orders)
                      Row(
                        children: [
                          Expanded(
                            child: _ItemStat(
                              label: 'Revenue',
                              value: AppFormatters.currency(item.totalRevenue),
                            ),
                          ),
                          Expanded(
                            child: _ItemStat(
                              label: 'Total Cost',
                              value: AppFormatters.currency(item.totalCost),
                            ),
                          ),
                          Expanded(
                            child: _ItemStat(
                              label: 'Net Profit',
                              value: AppFormatters.currency(item.totalProfit),
                              valueColor: AppColors.inStock,
                            ),
                          ),
                          Expanded(
                            child: _ItemStat(
                              label: 'Orders Count',
                              value: '${item.orderCount}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Color _marginColor(double pct) {
    if (pct >= 50) return AppColors.inStock;
    if (pct >= 25) return AppColors.lowStock;
    return AppColors.primary;
  }
}

class _KpiBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _KpiBox({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            )),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            )),
      ],
    );
  }
}

class _ItemStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ItemStat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            )),
        Text(value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            )),
      ],
    );
  }
}
