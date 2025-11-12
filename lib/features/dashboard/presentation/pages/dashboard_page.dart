import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/data/mock_data.dart' as data;
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.userName});

  final String userName;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  SalesPeriod _period = SalesPeriod.daily;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildWelcomeHero(context),
          const SizedBox(height: AppSpacing.lg),
          _buildStatsGrid(),
          const SizedBox(height: AppSpacing.lg),
          _buildSalesChart(context),
          const SizedBox(height: AppSpacing.lg),
          _buildTwoColumnSection(
            left: _buildTopProducts(),
            right: _buildTrafficSources(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHero(BuildContext context) {
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
              'مرحباً ${widget.userName}!',
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
                  'ج8,502',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(width: AppSpacing.md),
                const BadgeChip(
                  label: '+12.5%',
                  tone: BadgeTone.success,
                  icon: Icons.trending_up,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final chunks = List.generate(
      (data.dashboardStats.length / 2).ceil(),
      (index) => data.dashboardStats.skip(index * 2).take(2).toList(),
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

  Widget _buildSalesChart(BuildContext context) {
    final series = switch (_period) {
      SalesPeriod.daily => data.dailySales,
      SalesPeriod.weekly => data.weeklySales,
      SalesPeriod.monthly => data.monthlySales,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'تطور المبيعات',
            trailing: ToggleButtons(
              borderRadius: BorderRadius.circular(AppRadius.md),
              isSelected: SalesPeriod.values.map((e) => e == _period).toList(),
              onPressed: (index) {
                setState(() => _period = SalesPeriod.values[index]);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('يومي'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('أسبوعي'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('شهري'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.transparent,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2000,
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
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            series[index].label,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.mutedForeground),
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
                        if (value % 4000 != 0) return const SizedBox.shrink();
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
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                        FlSpot(i.toDouble(), series[i].orders.toDouble() * 400),
                    ],
                    isCurved: true,
                    color: AppColors.chartBlue,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    final topProducts = data.products.take(3).toList();

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
                  child: Image.asset(
                    product.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
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
                        style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${product.price.toStringAsFixed(0)} ج',
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

  Widget _buildTrafficSources() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'مصادر الزيارات',
            subtitle: 'أهم القنوات التي تجلب العملاء',
          ),
          const SizedBox(height: AppSpacing.md),
          for (final source in data.trafficSources) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        flex: source.percentage.round(),
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100 - source.percentage.round(),
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
                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'النشاط الأخير',
            subtitle: 'آخر التحديثات في متجرك',
          ),
          const SizedBox(height: AppSpacing.md),
          for (final activity in data.recentActivities) ...[
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
                          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
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

  final data.DashboardStat stat;

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
        Row(
          children: [
            Icon(
              stat.changeIsPositive ? Icons.trending_up : Icons.trending_down,
              size: 16,
              color: stat.changeIsPositive ? AppColors.success : AppColors.danger,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              stat.change,
              style: TextStyle(
                color: stat.changeIsPositive ? AppColors.success : AppColors.danger,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum SalesPeriod { daily, weekly, monthly }

