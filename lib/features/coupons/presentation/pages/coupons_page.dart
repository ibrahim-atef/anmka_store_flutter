import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final coupons = [
      const _Coupon(
        code: 'WELCOME20',
        discount: '20%',
        usage: 42,
        maxUsage: 100,
        validUntil: '31 ديسمبر 2025',
        type: 'خصم نسبة',
      ),
      const _Coupon(
        code: 'FREESHIP',
        discount: 'شحن مجاني',
        usage: 28,
        maxUsage: 60,
        validUntil: '15 يناير 2026',
        type: 'شحن مجاني',
      ),
      const _Coupon(
        code: 'VIP50',
        discount: 'ج50',
        usage: 10,
        maxUsage: 30,
        validUntil: '10 فبراير 2026',
        type: 'خصم ثابت',
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'الكوبونات والعروض',
            subtitle: 'إدارة حملات الخصم والترويج',
            trailing: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('نموذج إنشاء كوبون جديد قيد التطوير')),
                );
              },
              icon: const Icon(Icons.local_activity_outlined),
              label: const Text('إنشاء كوبون'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                for (final coupon in coupons) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            coupon.code,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        BadgeChip(label: coupon.type, tone: BadgeTone.info),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'الخصم: ${coupon.discount}',
                          style: const TextStyle(color: AppColors.mutedForeground),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        LinearProgressIndicator(
                          value: coupon.usage / coupon.maxUsage,
                          backgroundColor: AppColors.surfaceSecondary,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${coupon.usage}/${coupon.maxUsage} استخدام • صالح حتى ${coupon.validUntil}',
                          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ),
                  if (coupon != coupons.last)
                    Divider(color: AppColors.border.withOpacity(0.6)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Coupon {
  const _Coupon({
    required this.code,
    required this.discount,
    required this.usage,
    required this.maxUsage,
    required this.validUntil,
    required this.type,
  });

  final String code;
  final String discount;
  final int usage;
  final int maxUsage;
  final String validUntil;
  final String type;
}

