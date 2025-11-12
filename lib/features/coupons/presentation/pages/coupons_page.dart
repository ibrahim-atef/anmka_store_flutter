import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  late final List<_Coupon> _coupons;

  @override
  void initState() {
    super.initState();
    _coupons = [
      _Coupon(
        code: 'WELCOME20',
        discountLabel: 'خصم 20%',
        usage: 42,
        maxUsage: 100,
        validUntil: DateTime(2025, 12, 31),
        type: _CouponType.percent,
      ),
      _Coupon(
        code: 'FREESHIP',
        discountLabel: 'شحن مجاني',
        usage: 28,
        maxUsage: 60,
        validUntil: DateTime(2026, 1, 15),
        type: _CouponType.freeShipping,
      ),
      _Coupon(
        code: 'VIP50',
        discountLabel: 'خصم ج50',
        usage: 10,
        maxUsage: 30,
        validUntil: DateTime(2026, 2, 10),
        type: _CouponType.fixed,
      ),
    ];
  }

  Future<void> _openCouponForm({int? couponIndex}) async {
    final index = couponIndex;
    final isEdit = index != null;
    final coupon = index != null ? _coupons[index] : null;

    final codeController = TextEditingController(text: coupon?.code ?? '');
    final discountController = TextEditingController(text: coupon?.discountLabel ?? '');
    final maxUsageController =
        TextEditingController(text: coupon != null ? coupon.maxUsage.toString() : '');
    _CouponType selectedType = coupon?.type ?? _CouponType.percent;
    DateTime? selectedDate = coupon?.validUntil;
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
                          decoration: const InputDecoration(labelText: 'رمز الكوبون'),
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'الرمز مطلوب' : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<_CouponType>(
                          value: selectedType,
                          decoration: const InputDecoration(labelText: 'نوع الكوبون'),
                          items: const [
                            DropdownMenuItem(
                              value: _CouponType.percent,
                              child: Text('خصم نسبة مئوية'),
                            ),
                            DropdownMenuItem(
                              value: _CouponType.fixed,
                              child: Text('خصم ثابت'),
                            ),
                            DropdownMenuItem(
                              value: _CouponType.freeShipping,
                              child: Text('شحن مجاني'),
                            ),
                          ],
                          onChanged: (value) => setModalState(() {
                            selectedType = value ?? _CouponType.percent;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: discountController,
                          decoration: const InputDecoration(labelText: 'قيمة الخصم / الوصف'),
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'قيمة الخصم مطلوبة' : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: maxUsageController,
                          decoration: const InputDecoration(labelText: 'الحد الأقصى للاستخدام'),
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
                                ? intl.DateFormat('d MMMM yyyy', 'ar').format(selectedDate!)
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
                                    const SnackBar(content: Text('يرجى اختيار تاريخ الانتهاء.')),
                                  );
                                  return;
                                }
                                Navigator.of(ctx).pop(true);
                              }
                            },
                            child: Text(isEdit ? 'حفظ التعديلات' : 'إنشاء الكوبون'),
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
      if (!mounted) return;
      final maxUsage = int.parse(maxUsageController.text.trim());
      final newCoupon = _Coupon(
        code: codeController.text.trim(),
        discountLabel: discountController.text.trim(),
        usage: coupon?.usage ?? 0,
        maxUsage: maxUsage,
        validUntil: selectedDate ?? DateTime.now(),
        type: selectedType,
      );

      setState(() {
        if (index != null) {
          _coupons[index] = newCoupon;
        } else {
          _coupons.add(newCoupon);
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit
              ? 'تم تحديث الكوبون ${newCoupon.code}.'
              : 'تم إنشاء الكوبون ${newCoupon.code}.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'الكوبونات والعروض',
            subtitle: 'إدارة حملات الخصم والترويج',
            trailing: FilledButton.icon(
              onPressed: () => _openCouponForm(),
              icon: const Icon(Icons.local_activity_outlined),
              label: const Text('إنشاء كوبون'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                for (final coupon in _coupons) ...[
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
                        BadgeChip(
                          label: coupon.typeLabel,
                          tone: BadgeTone.info,
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'الخصم: ${coupon.discountLabel}',
                          style: const TextStyle(color: AppColors.mutedForeground),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        LinearProgressIndicator(
                          value: coupon.maxUsage == 0
                              ? 0
                              : coupon.usage.clamp(0, coupon.maxUsage) / coupon.maxUsage,
                          backgroundColor: AppColors.surfaceSecondary,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${coupon.usage}/${coupon.maxUsage} استخدام • صالح حتى ${coupon.expiryLabel}',
                          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: 'تعديل الكوبون',
                      onPressed: () => _openCouponForm(couponIndex: _coupons.indexOf(coupon)),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ),
                  if (coupon != _coupons.last)
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

enum _CouponType { percent, fixed, freeShipping }

class _Coupon {
  const _Coupon({
    required this.code,
    required this.discountLabel,
    required this.usage,
    required this.maxUsage,
    required this.validUntil,
    required this.type,
  });

  final String code;
  final String discountLabel;
  final int usage;
  final int maxUsage;
  final DateTime validUntil;
  final _CouponType type;

  String get typeLabel {
    return switch (type) {
      _CouponType.percent => 'خصم نسبة',
      _CouponType.fixed => 'خصم ثابت',
      _CouponType.freeShipping => 'شحن مجاني',
    };
  }

  String get expiryLabel => intl.DateFormat('d MMMM yyyy', 'ar').format(validUntil);
}

