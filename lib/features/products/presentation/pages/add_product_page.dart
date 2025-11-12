import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'إضافة منتج جديد',
            subtitle: 'أدخل تفاصيل المنتج لإضافته إلى المتجر',
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
                _buildTextField(label: 'اسم المنتج', hint: 'مثل: تي شيرت قطني أزرق'),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'الوصف', hint: 'صف المنتج والمميزات الرئيسية', maxLines: 4),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(label: 'السعر', hint: '0.00'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildTextField(label: 'المخزون', hint: 'عدد القطع المتوفرة'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'SKU', hint: 'الرمز التعريفي للمنتج'),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'الفئة'),
                  items: const [
                    DropdownMenuItem(value: 'ملابس', child: Text('ملابس')),
                    DropdownMenuItem(value: 'أحذية', child: Text('أحذية')),
                    DropdownMenuItem(value: 'إكسسوارات', child: Text('إكسسوارات')),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إنشاء المنتج (محاكاة).')),
                    );
                    onBack();
                  },
                  child: const Text('حفظ المنتج'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}

