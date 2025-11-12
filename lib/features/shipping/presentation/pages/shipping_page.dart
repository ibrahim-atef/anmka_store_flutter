import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shippingZones = [
      const _ShippingZone(
        name: 'القاهرة',
        deliveryTime: '1-2 أيام',
        cost: 'ج25',
        coverage: 'جميع الأحياء داخل القاهرة الكبرى',
      ),
      const _ShippingZone(
        name: 'الإسكندرية',
        deliveryTime: '2-3 أيام',
        cost: 'ج35',
        coverage: 'الإسكندرية والبحيرة ومطروح',
      ),
      const _ShippingZone(
        name: 'الصعيد',
        deliveryTime: '3-5 أيام',
        cost: 'ج45',
        coverage: 'المنيا، أسيوط، سوهاج، قنا، الأقصر، أسوان',
      ),
    ];

    final trackingUpdates = [
      const _TrackingUpdate(
        orderId: '#1231',
        status: 'تم التسليم',
        time: 'اليوم - 11:30 صباحاً',
        tone: BadgeTone.success,
      ),
      const _TrackingUpdate(
        orderId: '#1230',
        status: 'في الطريق',
        time: 'أمس - 04:12 عصراً',
        tone: BadgeTone.warning,
      ),
      const _TrackingUpdate(
        orderId: '#1229',
        status: 'قيد التجهيز',
        time: 'أمس - 09:40 صباحاً',
        tone: BadgeTone.info,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'إدارة الشحن',
            subtitle: 'تتبع الطلبات وقم بإدارة مناطق وأسعار الشحن',
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 820;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildZonesCard(shippingZones)),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(child: _buildTrackingCard(trackingUpdates)),
                  ],
                );
              }
              return Column(
                children: [
                  _buildZonesCard(shippingZones),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTrackingCard(trackingUpdates),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildZonesCard(List<_ShippingZone> zones) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'مناطق الشحن',
            trailing: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('إضافة منطقة'),
            ),
          ),
          for (final zone in zones) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(zone.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    zone.coverage,
                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      BadgeChip(label: zone.deliveryTime, tone: BadgeTone.info),
                      const SizedBox(width: AppSpacing.sm),
                      BadgeChip(label: zone.cost, tone: BadgeTone.success),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            if (zone != zones.last) Divider(color: AppColors.border.withOpacity(0.6)),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingCard(List<_TrackingUpdate> updates) {
    return AppCard(
      child: Column(
        children: [
          const SectionHeader(
            title: 'تتبع الشحنات',
            subtitle: 'آخر التحديثات لحالات الشحن',
          ),
          for (final update in updates) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: AppColors.surfaceSecondary,
                child: Icon(Icons.local_shipping_outlined, color: Colors.white),
              ),
              title: Text(update.orderId, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    update.time,
                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                  ),
                ],
              ),
              trailing: BadgeChip(label: update.status, tone: update.tone),
            ),
            if (update != updates.last) Divider(color: AppColors.border.withOpacity(0.7)),
          ],
        ],
      ),
    );
  }
}

class _ShippingZone {
  const _ShippingZone({
    required this.name,
    required this.deliveryTime,
    required this.cost,
    required this.coverage,
  });

  final String name;
  final String deliveryTime;
  final String cost;
  final String coverage;
}

class _TrackingUpdate {
  const _TrackingUpdate({
    required this.orderId,
    required this.status,
    required this.time,
    required this.tone,
  });

  final String orderId;
  final String status;
  final String time;
  final BadgeTone tone;
}

