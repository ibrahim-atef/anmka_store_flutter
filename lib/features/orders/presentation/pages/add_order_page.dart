import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class AddOrderPage extends StatelessWidget {
  const AddOrderPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'إنشاء طلب جديد',
            subtitle: 'أدخل بيانات العميل والمنتجات لإتمام الطلب',
            trailing: TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              label: const Text('رجوع'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(label: 'اسم العميل'),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'البريد الإلكتروني'),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'رقم الهاتف'),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'المنتجات',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'اسم المنتج'),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _buildTextField(label: 'الكمية', hint: '1')),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: _buildTextField(label: 'السعر', hint: '0.00')),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildTextField(label: 'ملاحظات إضافية', maxLines: 3),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إنشاء الطلب (محاكاة).')),
                    );
                    onBack();
                  },
                  child: const Text('حفظ الطلب'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, String? hint, int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}

