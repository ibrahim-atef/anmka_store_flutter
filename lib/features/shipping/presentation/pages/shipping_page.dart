import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  late List<_ShippingZone> _zones;
  late List<_TrackingUpdate> _updates;

  @override
  void initState() {
    super.initState();
    _zones = [
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
    _updates = [
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
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(child: _buildZonesCard()),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(child: _buildTrackingCard()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildZonesCard(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTrackingCard(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openZoneForm({int? zoneIndex}) async {
    final int? index = zoneIndex;
    final bool isEdit = index != null;
    final zone = index != null ? _zones[index] : null;

    final nameController = TextEditingController(text: zone?.name ?? '');
    final timeController = TextEditingController(text: zone?.deliveryTime ?? '');
    final costController = TextEditingController(text: zone?.cost ?? '');
    final coverageController = TextEditingController(text: zone?.coverage ?? '');
    final formKey = GlobalKey<FormState>();

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
            ),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'تعديل منطقة الشحن' : 'إضافة منطقة شحن',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'اسم المنطقة'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'اسم المنطقة مطلوب' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(labelText: 'مدة التوصيل'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'مدة التوصيل مطلوبة' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: costController,
                      decoration: const InputDecoration(labelText: 'تكلفة الشحن'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'تكلفة الشحن مطلوبة' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: coverageController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'نطاق التغطية'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'نطاق التغطية مطلوب' : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            Navigator.of(ctx).pop(true);
                          }
                        },
                        child: Text(isEdit ? 'حفظ التعديلات' : 'إضافة'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      final newZone = _ShippingZone(
        name: nameController.text.trim(),
        deliveryTime: timeController.text.trim(),
        cost: costController.text.trim(),
        coverage: coverageController.text.trim(),
      );
      setState(() {
        if (index != null) {
          _zones[index] = newZone;
        } else {
          _zones.add(newZone);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'تم تحديث المنطقة بنجاح.' : 'تمت إضافة المنطقة الجديدة.'),
        ),
      );
    }
  }

  Widget _buildZonesCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'مناطق الشحن',
            trailing: TextButton.icon(
              onPressed: () => _openZoneForm(),
              icon: const Icon(Icons.add),
              label: const Text('إضافة منطقة'),
            ),
          ),
          for (final zone in _zones) ...[
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
                tooltip: 'تعديل المنطقة',
                onPressed: () => _openZoneForm(zoneIndex: _zones.indexOf(zone)),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            if (zone != _zones.last) Divider(color: AppColors.border.withOpacity(0.6)),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingCard() {
    return AppCard(
      child: Column(
        children: [
          const SectionHeader(
            title: 'تتبع الشحنات',
            subtitle: 'آخر التحديثات لحالات الشحن',
          ),
          for (final update in _updates) ...[
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
            if (update != _updates.last) Divider(color: AppColors.border.withOpacity(0.7)),
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

