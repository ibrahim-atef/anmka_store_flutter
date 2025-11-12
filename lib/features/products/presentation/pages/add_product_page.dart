import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({
    super.key,
    required this.onBack,
    this.initialProduct,
  });

  final VoidCallback onBack;
  final Product? initialProduct;

  bool get isEditing => initialProduct != null;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _skuController;
  String? _category;

  @override
  void initState() {
    super.initState();
    final product = widget.initialProduct;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(
      text: product != null ? 'تفاصيل المنتج ${product.name}' : '',
    );
    _priceController = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '',
    );
    _stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    _skuController = TextEditingController(text: product?.sku ?? '');
    _category = product?.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing ? 'تم حفظ تعديلات المنتج (محاكاة).' : 'تم إنشاء المنتج (محاكاة).',
          ),
        ),
      );
      widget.onBack();
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
            title: widget.isEditing ? 'تعديل المنتج' : 'إضافة منتج جديد',
            subtitle: widget.isEditing
                ? 'قم بتعديل بيانات المنتج الحالي'
                : 'أدخل تفاصيل المنتج لإضافته إلى المتجر',
            trailing: TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              label: const Text('رجوع'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'اسم المنتج',
                    hint: 'مثل: تي شيرت قطني أزرق',
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'اسم المنتج مطلوب' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'الوصف',
                    hint: 'صف المنتج والمميزات الرئيسية',
                    maxLines: 4,
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'الوصف مطلوب' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'السعر',
                          hint: '0.00',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'السعر مطلوب';
                            }
                            return double.tryParse(value) == null ? 'صيغة السعر غير صحيحة' : null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildTextField(
                          controller: _stockController,
                          label: 'المخزون',
                          hint: 'عدد القطع المتوفرة',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'المخزون مطلوب';
                            }
                            return int.tryParse(value) == null ? 'صيغة المخزون غير صحيحة' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTextField(
                    controller: _skuController,
                    label: 'SKU',
                    hint: 'الرمز التعريفي للمنتج',
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'رمز SKU مطلوب' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'الفئة'),
                    items: const [
                      DropdownMenuItem(value: 'ملابس', child: Text('ملابس')),
                      DropdownMenuItem(value: 'أحذية', child: Text('أحذية')),
                      DropdownMenuItem(value: 'إكسسوارات', child: Text('إكسسوارات')),
                    ],
                    onChanged: (value) => setState(() => _category = value),
                    validator: (value) => value == null ? 'اختر الفئة' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      child: Text(widget.isEditing ? 'حفظ التعديلات' : 'حفظ المنتج'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}

