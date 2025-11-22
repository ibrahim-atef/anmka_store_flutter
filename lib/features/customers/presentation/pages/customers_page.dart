import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/response/customer_response.dart';
import '../../logic/cubit/customers_cubit.dart';
import '../../logic/states/customers_state.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersCubit, CustomersState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (customersList) {
            final customers = customersList.customers;

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
                  if (customers.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Text('لا يوجد عملاء'),
                      ),
                    )
                  else
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
                              backgroundImage: customer.avatar != null
                                  ? NetworkImage(customer.avatar!)
                                  : null,
                              child: customer.avatar == null
                                  ? Text(
                                      customer.name.characters.firstOrNull ?? 'أ',
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  : null,
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
                                  if (customer.phone != null) ...[
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      customer.phone!,
                                      style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                                    ),
                                  ],
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
                              value: '${customer.totalOrders ?? 0}',
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _MetricTile(
                              title: 'إجمالي الإنفاق',
                              value: 'ج${(customer.totalSpent ?? 0).toStringAsFixed(0)}',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          children: [
                            if (customer.tier != null)
                              BadgeChip(
                                label: _tierLabel(customer.tier!),
                                tone: switch (customer.tier) {
                                  'vip' => BadgeTone.success,
                                  'loyal' => BadgeTone.info,
                                  'newCustomer' => BadgeTone.warning,
                                  _ => BadgeTone.neutral,
                                },
                              ),
                            if (customer.tags != null)
                              for (final tag in customer.tags!) BadgeChip(label: tag),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.mutedForeground),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              customer.lastActive != null
                                  ? 'آخر نشاط: ${customer.lastActive}'
                                  : 'لا يوجد نشاط',
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
          },
          customerLoaded: (customer) => const Center(child: Text('Customer loaded')),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('خطأ: $message'),
                ElevatedButton(
                  onPressed: () => context.read<CustomersCubit>().getCustomers(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _tierLabel(String tier) {
    return switch (tier) {
      'newCustomer' => 'عميل جديد',
      'loyal' => 'عميل وفي',
      'vip' => 'عميل VIP',
      _ => tier,
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

