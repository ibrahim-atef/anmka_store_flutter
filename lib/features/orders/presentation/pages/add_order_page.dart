import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/request/create_order_request.dart';
import '../../data/models/request/order_item_request.dart';
import '../../logic/cubit/orders_cubit.dart';
import '../../logic/states/orders_state.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _productIdController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shippingAddressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _productIdController.dispose();
    _quantityController.dispose();
    _shippingAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitOrder(BuildContext context, OrdersCubit cubit) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final productId = int.parse(_productIdController.text.trim());
      final quantity = int.parse(_quantityController.text.trim());

      if (productId <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('معرف المنتج يجب أن يكون أكبر من صفر')),
        );
        return;
      }

      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الكمية يجب أن تكون أكبر من صفر')),
        );
        return;
      }

      final request = CreateOrderRequest(
        customerName: _customerNameController.text.trim(),
        customerEmail: _customerEmailController.text.trim(),
        customerPhone: _customerPhoneController.text.trim(),
        items: [
          OrderItemRequest(
            productId: productId,
            quantity: quantity,
          ),
        ],
        shippingAddress: _shippingAddressController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      cubit.createOrder(request);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في البيانات: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء الطلب بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: $message'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'إنشاء طلب جديد',
                subtitle: 'أدخل بيانات العميل والمنتجات لإتمام الطلب',
                trailing: TextButton.icon(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(false),
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
                      const Text(
                        'بيانات العميل',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _customerNameController,
                        label: 'اسم العميل',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال اسم العميل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _customerEmailController,
                        label: 'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@')) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _customerPhoneController,
                        label: 'رقم الهاتف',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Text(
                        'تفاصيل الطلب',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _productIdController,
                        label: 'معرف المنتج (Product ID)',
                        hint: '1',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال معرف المنتج';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'يرجى إدخال رقم صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _quantityController,
                        label: 'الكمية',
                        hint: '1',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الكمية';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'يرجى إدخال رقم صحيح';
                          }
                          if (int.parse(value.trim()) <= 0) {
                            return 'الكمية يجب أن تكون أكبر من صفر';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _shippingAddressController,
                        label: 'عنوان الشحن',
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال عنوان الشحن';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _notesController,
                        label: 'ملاحظات إضافية (اختياري)',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading
                              ? null
                              : () => _submitOrder(
                                  context, context.read<OrdersCubit>()),
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
                              : const Text('حفظ الطلب'),
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
    String? hint,
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
