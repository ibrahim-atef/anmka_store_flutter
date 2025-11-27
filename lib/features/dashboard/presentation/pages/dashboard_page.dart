import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/response/dashboard_stats_response.dart';
import '../../domain/entities/dashboard_models.dart';
import '../../logic/cubit/dashboard_cubit.dart';
import '../../logic/states/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.userName});

  final String userName;
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'ar_EG',
    symbol: 'ج',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (stats, sales, period, topProducts, traffic, activities,
                  isSalesLoading) =>
              SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _buildWelcomeHero(context, stats),
                const SizedBox(height: AppSpacing.lg),
                _buildStatsGrid(stats),
                const SizedBox(height: AppSpacing.lg),
                _buildSalesChart(
                  context,
                  sales: sales,
                  period: period,
                  isLoading: isSalesLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildTwoColumnSection(
                  left: _buildTopProducts(topProducts),
                  right: _buildTrafficSources(traffic),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildRecentActivity(activities),
              ],
            ),
          ),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('خطأ: $message'),
                ElevatedButton(
                  onPressed: () =>
                      context.read<DashboardCubit>().loadDashboard(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHero(BuildContext context, DashboardStatsResponse stats) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً $userName!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'إليك نظرة سريعة على أداء متجرك اليوم',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  _currencyFormatter
                      .format((stats.totalSales ?? stats.revenue) ?? 0),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(width: AppSpacing.md),
                BadgeChip(
                  label: _formatChange(stats.salesChange ?? stats.growth),
                  tone: (stats.salesChange ?? stats.growth ?? 0) >= 0
                      ? BadgeTone.success
                      : BadgeTone.danger,
                  icon: (stats.salesChange ?? stats.growth ?? 0) >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(DashboardStatsResponse stats) {
    final cards = [
      _StatTileData(
        icon: 'money',
        title: 'إجمالي المبيعات',
        value: _currencyFormatter.format(stats.totalSales ?? 0),
        change: _formatChange(stats.salesChange ?? stats.growth),
        changeIsPositive: (stats.salesChange ?? stats.growth ?? 0) >= 0,
      ),
      _StatTileData(
        icon: 'cart',
        title: 'عدد الطلبات',
        value: '${stats.totalOrders ?? stats.newOrders ?? 0}',
        change: _formatChange(stats.ordersChange),
        changeIsPositive: (stats.ordersChange ?? 0) >= 0,
      ),
      _StatTileData(
        icon: 'users',
        title: 'عدد العملاء',
        value: '${stats.totalCustomers ?? stats.newCustomers ?? 0}',
        change: _formatChange(stats.customersChange),
        changeIsPositive: (stats.customersChange ?? 0) >= 0,
      ),
      _StatTileData(
        icon: 'inventory',
        title: 'عدد المنتجات',
        value: '${stats.totalProducts ?? 0}',
        change: stats.outOfStockProducts != null
            ? '${stats.outOfStockProducts} منتجات منخفضة'
            : '',
        changeIsPositive: false,
      ),
    ];

    final chunks = List.generate(
      (cards.length / 2).ceil(),
      (index) => cards.skip(index * 2).take(2).toList(),
    );

    return Column(
      children: [
        for (final row in chunks) ...[
          Row(
            children: [
              for (final stat in row) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: AppCard(
                      child: _StatTile(stat: stat),
                    ),
                  ),
                ),
              ],
              if (row.length == 1)
                const Expanded(
                  child: SizedBox.shrink(),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSalesChart(
    BuildContext context, {
    required List<DashboardSalesPoint> sales,
    required DashboardSalesPeriod period,
    required bool isLoading,
  }) {
    final series = sales.isEmpty
        ? const [
            DashboardSalesPoint(label: 'لا توجد بيانات', sales: 0, orders: 0),
          ]
        : sales;
    final maxSales = series
        .map((e) => e.sales)
        .fold<double>(0, (prev, value) => value > prev ? value : prev);
    final maxOrders = series
        .map((e) => e.orders.toDouble())
        .fold<double>(0, (prev, value) => value > prev ? value : prev);
    final orderScale = maxOrders == 0 ? 1 : maxSales / maxOrders;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'تطور المبيعات',
            trailing: ToggleButtons(
              borderRadius: BorderRadius.circular(AppRadius.md),
              isSelected:
                  DashboardSalesPeriod.values.map((e) => e == period).toList(),
              onPressed: (index) {
                context
                    .read<DashboardCubit>()
                    .changePeriod(DashboardSalesPeriod.values[index]);
              },
              children: [
                for (final filter in DashboardSalesPeriod.values)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(filter.displayLabel),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 260,
            child: Stack(
              children: [
                LineChart(
                  LineChartData(
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: _suggestedInterval(series),
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= series.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSpacing.sm),
                              child: Text(
                                series[index].label,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppColors.mutedForeground),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (value, meta) {
                            if (value % _suggestedInterval(series) != 0) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              value.toInt().toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.mutedForeground),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (series.length - 1).toDouble(),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < series.length; i++)
                            FlSpot(i.toDouble(), series[i].sales),
                        ],
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.primary,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            );
                          },
                        ),
                      ),
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < series.length; i++)
                            FlSpot(
                              i.toDouble(),
                              series[i].orders.toDouble() * orderScale,
                            ),
                        ],
                        isCurved: true,
                        color: AppColors.chartBlue,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    color: AppColors.surface.withOpacity(0.7),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts(List<DashboardTopProduct> topProducts) {
    if (topProducts.isEmpty) {
      return const _EmptySection(
        title: 'أفضل المنتجات أداءً',
        message: 'لا توجد بيانات منتجات مميزة حتى الآن.',
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'أفضل المنتجات أداءً',
            subtitle: 'أكثر المنتجات مبيعاً خلال الأسبوع',
          ),
          const SizedBox(height: AppSpacing.md),
          for (final product in topProducts) ...[
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: product.image != null && product.image!.isNotEmpty
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.jpg',
                            image: product.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'تم بيع ${product.sales} قطعة',
                        style: const TextStyle(
                            color: AppColors.mutedForeground, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  _currencyFormatter.format(product.price),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (product != topProducts.last)
              Divider(
                color: AppColors.border.withOpacity(0.6),
                height: AppSpacing.xl,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrafficSources(List<DashboardTrafficSourceEntry> sources) {
    if (sources.isEmpty) {
      return const _EmptySection(
        title: 'مصادر الزيارات',
        message: 'لا توجد بيانات زيارات في الفترة الحالية.',
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'مصادر الزيارات',
            subtitle: 'أهم القنوات التي تجلب العملاء',
          ),
          const SizedBox(height: AppSpacing.md),
          for (final source in sources) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        flex: source.percentage.round().clamp(0, 100).toInt(),
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: (100 - source.percentage.round())
                            .clamp(0, 100)
                            .toInt(),
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${source.value.toStringAsFixed(0)} زيارة • ${source.percentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: AppColors.mutedForeground, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<DashboardActivityEntry> activities) {
    if (activities.isEmpty) {
      return const _EmptySection(
        title: 'النشاط الأخير',
        message: 'لا توجد أنشطة حديثة.',
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'النشاط الأخير',
            subtitle: 'آخر التحديثات في متجرك',
          ),
          const SizedBox(height: AppSpacing.md),
          for (final activity in activities) ...[
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _tagToneToColor(activity.tagTone),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          activity.subtitle,
                          style: const TextStyle(
                              color: AppColors.mutedForeground, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  BadgeChip(
                    label: activity.tag,
                    tone: _tagToneToBadge(activity.tagTone),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTwoColumnSection({required Widget left, required Widget right}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 720;
        if (isWide) {
          return Row(
            children: [
              Expanded(child: left),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: right),
            ],
          );
        }
        return Column(
          children: [
            left,
            const SizedBox(height: AppSpacing.lg),
            right,
          ],
        );
      },
    );
  }

  Color _tagToneToColor(String tone) {
    return switch (tone) {
      'success' => AppColors.success,
      'danger' => AppColors.danger,
      'info' => AppColors.info,
      _ => AppColors.muted,
    };
  }

  BadgeTone _tagToneToBadge(String tone) {
    return switch (tone) {
      'success' => BadgeTone.success,
      'danger' => BadgeTone.danger,
      'info' => BadgeTone.info,
      _ => BadgeTone.neutral,
    };
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final _StatTileData stat;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (stat.icon) {
      case 'money':
        icon = Icons.payments_outlined;
        break;
      case 'cart':
        icon = Icons.shopping_bag_outlined;
        break;
      case 'users':
        icon = Icons.people_outline;
        break;
      case 'alert':
        icon = Icons.warning_amber_outlined;
        break;
      case 'eye':
        icon = Icons.visibility_outlined;
        break;
      default:
        icon = Icons.inventory_2_outlined;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          stat.title,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.mutedForeground),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          stat.value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (stat.change.isNotEmpty)
          Row(
            children: [
              Icon(
                stat.changeIsPositive ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: stat.changeIsPositive
                    ? AppColors.success
                    : AppColors.danger,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                stat.change,
                style: TextStyle(
                  color: stat.changeIsPositive
                      ? AppColors.success
                      : AppColors.danger,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _StatTileData {
  const _StatTileData({
    required this.title,
    required this.value,
    required this.change,
    required this.changeIsPositive,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final bool changeIsPositive;
  final String icon;
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

double _suggestedInterval(List<DashboardSalesPoint> series) {
  if (series.isEmpty) return 1000;
  final maxValue = series
      .map((e) => e.sales)
      .fold<double>(0, (prev, value) => value > prev ? value : prev);
  if (maxValue <= 1000) return 200;
  if (maxValue <= 5000) return 500;
  if (maxValue <= 10000) return 1000;
  if (maxValue <= 20000) return 2000;
  if (maxValue <= 50000) return 5000;
  return 10000;
}

String _formatChange(double? value) {
  final change = value ?? 0;
  final sign = change > 0 ? '+' : '';
  return '$sign${change.toStringAsFixed(1)}%';
}
