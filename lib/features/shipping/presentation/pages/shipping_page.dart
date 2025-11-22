import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/request/create_shipping_zone_request.dart';
import '../../data/models/request/update_shipping_zone_request.dart';
import '../../data/models/response/shipping_zone_response.dart';
import '../../data/models/response/tracking_update_response.dart';
import '../../logic/cubit/shipping_cubit.dart';
import '../../logic/states/shipping_state.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  Future<void> _openZoneForm(
    BuildContext context,
    ShippingCubit cubit, {
    ShippingZoneResponse? zone,
  }) async {
    final isEdit = zone != null;

    final nameController = TextEditingController(text: zone?.name ?? '');
    final timeController =
        TextEditingController(text: zone?.deliveryTime ?? '');
    final costController =
        TextEditingController(text: zone != null ? zone.cost.toString() : '');
    final coverageController =
        TextEditingController(text: zone?.coverage ?? '');
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
                      decoration:
                          const InputDecoration(labelText: 'اسم المنطقة'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'اسم المنطقة مطلوب'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: timeController,
                      decoration:
                          const InputDecoration(labelText: 'مدة التوصيل'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'مدة التوصيل مطلوبة'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: costController,
                      decoration:
                          const InputDecoration(labelText: 'تكلفة الشحن'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'تكلفة الشحن مطلوبة';
                        }
                        final parsed = double.tryParse(value);
                        if (parsed == null || parsed < 0) {
                          return 'يرجى إدخال رقم صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: coverageController,
                      maxLines: 2,
                      decoration:
                          const InputDecoration(labelText: 'نطاق التغطية'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'نطاق التغطية مطلوب'
                              : null,
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
      if (!context.mounted) return;
      final cost = double.parse(costController.text.trim());

      if (isEdit) {
        final request = UpdateShippingZoneRequest(
          name: nameController.text.trim(),
          deliveryTime: timeController.text.trim(),
          cost: cost,
          coverage: coverageController.text.trim(),
        );
        cubit.updateShippingZone(zone.id, request);
      } else {
        final request = CreateShippingZoneRequest(
          name: nameController.text.trim(),
          deliveryTime: timeController.text.trim(),
          cost: cost,
          coverage: coverageController.text.trim(),
        );
        cubit.createShippingZone(request);
      }
    }
  }

  BadgeTone _getStatusTone(String status) {
    return switch (status.toLowerCase()) {
      'تم التسليم' || 'delivered' => BadgeTone.success,
      'في الطريق' || 'in transit' || 'intransit' => BadgeTone.warning,
      'قيد التجهيز' || 'preparing' => BadgeTone.info,
      _ => BadgeTone.info,
    };
  }

  String _formatTime(String timeString) {
    try {
      final date = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'الآن';
      } else if (difference.inMinutes < 60) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        return intl.DateFormat('d MMMM yyyy', 'ar').format(date);
      }
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShippingCubit, ShippingState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      builder: (context, state) {
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
              state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (zonesList, trackingUpdates) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 820;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildZonesCard(context, zonesList.zones),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: _buildTrackingCard(
                                  trackingUpdates?.updates ?? []),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _buildZonesCard(context, zonesList.zones),
                          const SizedBox(height: AppSpacing.lg),
                          _buildTrackingCard(trackingUpdates?.updates ?? []),
                        ],
                      );
                    },
                  );
                },
                error: (message) => AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: AppColors.danger),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            message,
                            style: const TextStyle(color: AppColors.danger),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZonesCard(
      BuildContext context, List<ShippingZoneResponse> zones) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'مناطق الشحن',
            trailing: TextButton.icon(
              onPressed: () => _openZoneForm(
                context,
                context.read<ShippingCubit>(),
              ),
              icon: const Icon(Icons.add),
              label: const Text('إضافة منطقة'),
            ),
          ),
          if (zones.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'لا توجد مناطق شحن',
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            for (final zone in zones) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(zone.name,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      zone.coverage,
                      style: const TextStyle(
                          color: AppColors.mutedForeground, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        BadgeChip(
                            label: zone.deliveryTime, tone: BadgeTone.info),
                        const SizedBox(width: AppSpacing.sm),
                        BadgeChip(
                            label: 'ج${zone.cost}', tone: BadgeTone.success),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'تعديل المنطقة',
                      onPressed: () => _openZoneForm(
                        context,
                        context.read<ShippingCubit>(),
                        zone: zone,
                      ),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'حذف المنطقة',
                      onPressed: () {
                        context
                            .read<ShippingCubit>()
                            .deleteShippingZone(zone.id);
                      },
                      icon: const Icon(Icons.delete_outlined),
                    ),
                  ],
                ),
              ),
              if (zone != zones.last)
                Divider(color: AppColors.border.withOpacity(0.6)),
            ],
        ],
      ),
    );
  }

  Widget _buildTrackingCard(List<TrackingUpdateResponse> updates) {
    return AppCard(
      child: Column(
        children: [
          const SectionHeader(
            title: 'تتبع الشحنات',
            subtitle: 'آخر التحديثات لحالات الشحن',
          ),
          if (updates.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'لا توجد تحديثات',
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            for (final update in updates) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.surfaceSecondary,
                  child:
                      Icon(Icons.local_shipping_outlined, color: Colors.white),
                ),
                title: Text(update.orderId,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _formatTime(update.time),
                      style: const TextStyle(
                          color: AppColors.mutedForeground, fontSize: 12),
                    ),
                    if (update.location != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        update.location!,
                        style: const TextStyle(
                            color: AppColors.mutedForeground, fontSize: 12),
                      ),
                    ],
                  ],
                ),
                trailing: BadgeChip(
                    label: update.status, tone: _getStatusTone(update.status)),
              ),
              if (update != updates.last)
                Divider(color: AppColors.border.withOpacity(0.7)),
            ],
        ],
      ),
    );
  }
}
