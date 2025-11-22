import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/request/create_product_request.dart';
import '../../data/models/request/update_product_request.dart';
import '../../domain/entities/product.dart';
import '../../logic/cubit/products_cubit.dart';
import '../../logic/states/products_state.dart';

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
  bool _isSubmitting = false;

  static const List<String> _availableCategories = [
    'ملابس',
    'أحذية',
    'إكسسوارات',
  ];

  String? _getValidCategory(String? category) {
    if (category == null || category.isEmpty) {
      return null;
    }
    // Trim whitespace and check if category exists in available list
    final trimmedCategory = category.trim();
    // Check if the category is in the available list
    if (_availableCategories.contains(trimmedCategory)) {
      return trimmedCategory;
    }
    // If category is not valid, return null
    return null;
  }

  // Getter that always returns a valid category or null
  String? get _validCategory => _getValidCategory(_category);

  void _initializeCategory() {
    final product = widget.initialProduct;
    final category = _getValidCategory(product?.category);
    if (_category != category) {
      setState(() {
        _category = category;
      });
    }
  }

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
    // Initialize category - only set if it's in the available categories list
    _category = _getValidCategory(product?.category);
  }

  @override
  void didUpdateWidget(ProductFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initial product changed, update the category
    if (oldWidget.initialProduct != widget.initialProduct) {
      _initializeCategory();
    }
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final cubit = context.read<ProductsCubit>();

    if (widget.isEditing) {
      // Update existing product
      final product = widget.initialProduct!;
      final request = UpdateProductRequest(
        name: _nameController.text.trim(),
        price: double.tryParse(_priceController.text.trim()),
        stock: int.tryParse(_stockController.text.trim()),
        category: _category,
        description: _descriptionController.text.trim(),
      );
      cubit.updateProduct(product.id, request);
    } else {
      // Create new product
      final price = double.tryParse(_priceController.text.trim());
      final stock = int.tryParse(_stockController.text.trim());

      if (price == null || stock == null) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى التحقق من صحة البيانات المدخلة')),
        );
        return;
      }

      final request = CreateProductRequest(
        name: _nameController.text.trim(),
        category: _category!,
        price: price,
        stock: stock,
        sku: _skuController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      cubit.createProduct(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (_) {
            // Only navigate back if we submitted the form
            if (_isSubmitting && mounted) {
              setState(() {
                _isSubmitting = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.isEditing
                        ? 'تم حفظ تعديلات المنتج بنجاح'
                        : 'تم إنشاء المنتج بنجاح',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              // Use a small delay to ensure state is updated
              Future.microtask(() {
                if (mounted) {
                  widget.onBack();
                }
              });
            }
          },
          error: (message) {
            if (_isSubmitting && mounted) {
              setState(() {
                _isSubmitting = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ: $message'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
      builder: (context, state) {
        final isLoading = _isSubmitting &&
            state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

        // Ensure category is always valid before building the widget
        final currentCategory = _getValidCategory(_category);
        if (_category != currentCategory) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _category = currentCategory;
              });
            }
          });
        }

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
                  onPressed: isLoading ? null : widget.onBack,
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
                            value == null || value.trim().isEmpty
                                ? 'اسم المنتج مطلوب'
                                : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'الوصف',
                        hint: 'صف المنتج والمميزات الرئيسية',
                        maxLines: 4,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'الوصف مطلوب'
                                : null,
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
                                return double.tryParse(value) == null
                                    ? 'صيغة السعر غير صحيحة'
                                    : null;
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
                                return int.tryParse(value) == null
                                    ? 'صيغة المخزون غير صحيحة'
                                    : null;
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
                            value == null || value.trim().isEmpty
                                ? 'رمز SKU مطلوب'
                                : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        value: _validCategory,
                        decoration: const InputDecoration(labelText: 'الفئة'),
                        items: _availableCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                        validator: (value) =>
                            value == null ? 'اختر الفئة' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  widget.isEditing
                                      ? 'حفظ التعديلات'
                                      : 'حفظ المنتج',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
