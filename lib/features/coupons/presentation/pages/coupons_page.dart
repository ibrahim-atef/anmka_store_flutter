import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/request/create_coupon_request.dart';
import '../../data/models/request/update_coupon_request.dart';
import '../../data/models/response/coupon_response.dart';
import '../../logic/cubit/coupons_cubit.dart';
import '../../logic/states/coupons_state.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  Future<void> _openCouponForm(
    BuildContext context,
    CouponsCubit cubit, {
    CouponResponse? coupon,
  }) async {
    final isEdit = coupon != null;

    final codeController = TextEditingController(text: coupon?.code ?? '');
    final discountValueController = TextEditingController(
        text: coupon != null ? coupon.discountValue.toString() : '');
    final maxUsageController = TextEditingController(
        text: coupon != null ? coupon.maxUsage.toString() : '');
    String selectedType = coupon?.type ?? 'percent';
    DateTime? selectedDate =
        coupon != null ? DateTime.tryParse(coupon.validUntil) : null;
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
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  Future<void> pickDateModal() async {
                    final now = DateTime.now();
                    final initial = selectedDate ?? now;
                    final DateTime? result = await showDatePicker(
                      context: ctx,
                      initialDate: initial.isBefore(now) ? now : initial,
                      firstDate: now,
                      lastDate: DateTime(now.year + 5),
                    );
                    if (result != null) {
                      setModalState(() {
                        selectedDate = result;
                      });
                    }
                  }

                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'تعديل الكوبون' : 'إنشاء كوبون جديد',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: codeController,
                          decoration:
                              const InputDecoration(labelText: 'رمز الكوبون'),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'الرمز مطلوب'
                                  : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<String>(
                          initialValue: selectedType,
                          decoration:
                              const InputDecoration(labelText: 'نوع الكوبون'),
                          items: const [
                            DropdownMenuItem(
                              value: 'percent',
                              child: Text('خصم نسبة مئوية'),
                            ),
                            DropdownMenuItem(
                              value: 'fixed',
                              child: Text('خصم ثابت'),
                            ),
                            DropdownMenuItem(
                              value: 'freeShipping',
                              child: Text('شحن مجاني'),
                            ),
                          ],
                          onChanged: (value) => setModalState(() {
                            selectedType = value ?? 'percent';
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: discountValueController,
                          decoration:
                              const InputDecoration(labelText: 'قيمة الخصم'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'قيمة الخصم مطلوبة';
                            }
                            final parsed = double.tryParse(value);
                            if (parsed == null || parsed <= 0) {
                              return 'يرجى إدخال رقم صحيح أكبر من صفر';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: maxUsageController,
                          decoration: const InputDecoration(
                              labelText: 'الحد الأقصى للاستخدام'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الحد الأقصى مطلوب';
                            }
                            final parsed = int.tryParse(value);
                            if (parsed == null || parsed <= 0) {
                              return 'يرجى إدخال رقم صحيح أكبر من صفر';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed: pickDateModal,
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            selectedDate != null
                                ? intl.DateFormat('d MMMM yyyy', 'ar')
                                    .format(selectedDate!)
                                : 'اختر تاريخ الانتهاء',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                if (selectedDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'يرجى اختيار تاريخ الانتهاء.')),
                                  );
                                  return;
                                }
                                Navigator.of(ctx).pop(true);
                              }
                            },
                            child: Text(
                                isEdit ? 'حفظ التعديلات' : 'إنشاء الكوبون'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final discountValue = double.parse(discountValueController.text.trim());
      final maxUsage = int.parse(maxUsageController.text.trim());
      final validUntil = selectedDate!.toUtc().toIso8601String();

      if (isEdit) {
        final request = UpdateCouponRequest(
          code: codeController.text.trim(),
          type: selectedType,
          discountValue: discountValue,
          maxUsage: maxUsage,
          validUntil: validUntil,
        );
        cubit.updateCoupon(coupon.id, request);
      } else {
        final request = CreateCouponRequest(
          code: codeController.text.trim(),
          type: selectedType,
          discountValue: discountValue,
          maxUsage: maxUsage,
          validUntil: validUntil,
        );
        cubit.createCoupon(request);
      }
    }
  }

  String _getTypeLabel(String type) {
    return switch (type) {
      'percent' => 'خصم نسبة',
      'fixed' => 'خصم ثابت',
      'freeShipping' => 'شحن مجاني',
      _ => type,
    };
  }

  BadgeTone _getTypeTone(String type) {
    return switch (type) {
      'percent' => BadgeTone.info,
      'fixed' => BadgeTone.success,
      'freeShipping' => BadgeTone.warning,
      _ => BadgeTone.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CouponsCubit, CouponsState>(
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
              SectionHeader(
                title: 'الكوبونات والعروض',
                subtitle: 'إدارة حملات الخصم والترويج',
                trailing: FilledButton.icon(
                  onPressed: () => _openCouponForm(
                    context,
                    context.read<CouponsCubit>(),
                  ),
                  icon: const Icon(Icons.local_activity_outlined),
                  label: const Text('إنشاء كوبون'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (couponsList) {
                  if (couponsList.coupons.isEmpty) {
                    return const AppCard(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            'لا توجد كوبونات',
                            style: TextStyle(
                              color: AppColors.mutedForeground,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return AppCard(
                    child: Column(
                      children: [
                        for (final coupon in couponsList.coupons) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    coupon.code,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                BadgeChip(
                                  label: _getTypeLabel(coupon.type),
                                  tone: _getTypeTone(coupon.type),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'الخصم: ${coupon.discountLabel}',
                                  style: const TextStyle(
                                      color: AppColors.mutedForeground),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                LinearProgressIndicator(
                                  value: coupon.maxUsage == 0
                                      ? 0
                                      : coupon.usage.clamp(0, coupon.maxUsage) /
                                          coupon.maxUsage,
                                  backgroundColor: AppColors.surfaceSecondary,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '${coupon.usage}/${coupon.maxUsage} استخدام • صالح حتى ${_formatDate(coupon.validUntil)}',
                                  style: const TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'تعديل الكوبون',
                                  onPressed: () => _openCouponForm(
                                    context,
                                    context.read<CouponsCubit>(),
                                    coupon: coupon,
                                  ),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  tooltip: 'حذف الكوبون',
                                  onPressed: () {
                                    context
                                        .read<CouponsCubit>()
                                        .deleteCoupon(coupon.id);
                                  },
                                  icon: const Icon(Icons.delete_outlined),
                                ),
                              ],
                            ),
                          ),
                          if (coupon != couponsList.coupons.last)
                            Divider(color: AppColors.border.withOpacity(0.6)),
                        ],
                      ],
                    ),
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return intl.DateFormat('d MMMM yyyy', 'ar').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
