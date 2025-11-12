import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      const _NotificationItem(
        title: 'طلب جديد #1234',
        description: 'استلمت طلباً جديداً بقيمة ج125.00',
        time: 'منذ 3 دقائق',
        category: 'الطلبات',
        tone: BadgeTone.success,
      ),
      const _NotificationItem(
        title: 'دفعة مكتملة',
        description: 'تم تحويل مبلغ ج89.50 إلى حسابك البنكي',
        time: 'منذ ساعة',
        category: 'المدفوعات',
        tone: BadgeTone.info,
      ),
      const _NotificationItem(
        title: 'تنبيه مخزون منخفض',
        description: 'تي شيرت قطني أزرق: متبقي 3 قطع في المخزون',
        time: 'منذ يوم',
        category: 'المخزون',
        tone: BadgeTone.warning,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SectionHeader(
            title: 'مركز الإشعارات',
            subtitle: 'تابع كل التحديثات المهمة في متجرك',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                for (final item in notifications) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Expanded(child: Text(item.title)),
                        BadgeChip(label: item.category, tone: item.tone),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          item.description,
                          style: const TextStyle(color: AppColors.mutedForeground),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          item.time,
                          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم تعليم "${item.title}" كمقروء (محاكاة).')),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                    ),
                  ),
                  if (item != notifications.last)
                    Divider(color: AppColors.border.withOpacity(0.7)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.tone,
  });

  final String title;
  final String description;
  final String time;
  final String category;
  final BadgeTone tone;
}

