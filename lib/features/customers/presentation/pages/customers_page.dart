import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/data/mock_data.dart' as data;
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/customer.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = data.customers;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'العملاء',
            subtitle: 'تعرف على عملاء متجرك وتابع نشاطهم',
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: [
              for (final customer in customers)
                SizedBox(
                  width: 320,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(customer.avatar),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    customer.email,
                                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    customer.phone,
                                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            _MetricTile(
                              title: 'عدد الطلبات',
                              value: customer.totalOrders.toString(),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _MetricTile(
                              title: 'إجمالي الإنفاق',
                              value: 'ج${customer.totalSpent.toStringAsFixed(0)}',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          children: [
                            BadgeChip(
                              label: _tierLabel(customer.tier),
                              tone: switch (customer.tier) {
                                CustomerTier.vip => BadgeTone.success,
                                CustomerTier.loyal => BadgeTone.info,
                                CustomerTier.newCustomer => BadgeTone.warning,
                              },
                            ),
                            for (final tag in customer.tags) BadgeChip(label: tag),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.mutedForeground),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'آخر نشاط: ${DateFormat('d MMM', 'ar').format(customer.lastActive)}',
                              style: const TextStyle(
                                  color: AppColors.mutedForeground, fontSize: 12),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('عرض ملف ${customer.name} قريباً')),
                                );
                              },
                              child: const Text('عرض الملف'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _tierLabel(CustomerTier tier) {
    return switch (tier) {
      CustomerTier.newCustomer => 'عميل جديد',
      CustomerTier.loyal => 'عميل وفي',
      CustomerTier.vip => 'عميل VIP',
    };
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

