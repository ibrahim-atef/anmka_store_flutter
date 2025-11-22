import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/response/product_response.dart';
import '../../domain/entities/product.dart';
import '../../logic/cubit/products_cubit.dart';
import '../../logic/states/products_state.dart';
import 'add_product_page.dart';
import 'product_details_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, this.onAddProduct});

  final VoidCallback? onAddProduct;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  String? _selectedStatus;
  bool _isDeleting = false;

  Product _toProduct(ProductResponse response) {
    return Product(
      id: response.id,
      name: response.name,
      category: response.category,
      price: response.price,
      stock: response.stock,
      status: switch (response.status) {
        'available' => ProductStatus.available,
        'lowStock' => ProductStatus.lowStock,
        'outOfStock' => ProductStatus.outOfStock,
        _ => ProductStatus.available,
      },
      image: response.image,
      sku: response.sku,
      sales: response.sales ?? 0,
    );
  }

  void _openProductDetails(ProductResponse product) {
    final cubit = context.read<ProductsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ProductDetailsPage(product: _toProduct(product)),
          ),
        ),
      ),
    );
  }

  void _openProductForm({ProductResponse? product}) {
    final cubit = context.read<ProductsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: cubit,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ProductFormPage(
              initialProduct: product != null ? _toProduct(product) : null,
              onBack: () => Navigator.of(routeContext).pop(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          loaded: (productsList) {
            // Show success message if we just completed a deletion
            if (_isDeleting && context.mounted) {
              _isDeleting = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المنتج بنجاح'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
          productLoaded: (_) {},
          error: (message) {
            _isDeleting = false;
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ: $message'),
                  backgroundColor: AppColors.danger,
                ),
              );
            }
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (productsList) {
            final products = productsList.products;
            final filtered = products.where((product) {
              final matchesSearch =
                  product.name.contains(_searchController.text);
              final matchesCategory = _selectedCategory == 'الكل' ||
                  product.category == _selectedCategory;
              final matchesStatus = _selectedStatus == null ||
                  _selectedStatus!.isEmpty ||
                  product.status == _selectedStatus;
              return matchesSearch && matchesCategory && matchesStatus;
            }).toList();

            final categories = {
              'الكل',
              ...products.map((e) => e.category),
            }.toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'إدارة المنتجات',
                    subtitle: 'إدارة وتنظيم منتجات متجرك',
                    trailing: FilledButton.icon(
                      onPressed: () {
                        final callback = widget.onAddProduct;
                        if (callback != null) {
                          callback();
                        } else {
                          _openProductForm();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة منتج'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'البحث عن منتج...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            _FilterChip<String>(
                              label: 'الفئة',
                              value: _selectedCategory,
                              items: categories,
                              onSelected: (value) =>
                                  setState(() => _selectedCategory = value),
                            ),
                            _FilterChip<String?>(
                              label: 'الحالة',
                              value: _selectedStatus,
                              items: const [
                                null,
                                'available',
                                'lowStock',
                                'outOfStock'
                              ],
                              itemBuilder: (status) => switch (status) {
                                null => 'جميع الحالات',
                                'available' => 'متوفر',
                                'lowStock' => 'مخزون منخفض',
                                'outOfStock' => 'نافذ',
                                _ => 'جميع الحالات',
                              },
                              onSelected: (value) =>
                                  setState(() => _selectedStatus = value),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (filtered.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Text('لا توجد منتجات'),
                      ),
                    )
                  else
                    for (final product in filtered)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: InkWell(
                          onTap: () => _openProductDetails(product),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          child: AppCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  child: Image.network(
                                    product.image,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 72,
                                      height: 72,
                                      color: AppColors.surfaceSecondary,
                                      child: const Icon(Icons.image),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          _ProductMenu(
                                            product: product,
                                            onView: () =>
                                                _openProductDetails(product),
                                            onEdit: () => _openProductForm(
                                                product: product),
                                            onDelete: () async {
                                              final confirmed =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text('تأكيد الحذف'),
                                                  content: Text(
                                                      'هل أنت متأكد من حذف المنتج "${product.name}"؟'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text('إلغاء'),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      style: FilledButtonThemeData(
                                                              style: FilledButton.styleFrom())
                                                          .style
                                                          ?.copyWith(
                                                            backgroundColor:
                                                                WidgetStateProperty
                                                                    .all(AppColors
                                                                        .danger),
                                                          ),
                                                      child: const Text('حذف'),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirmed == true && context.mounted) {
                                                setState(() {
                                                  _isDeleting = true;
                                                });
                                                // The cubit will automatically refresh the products list
                                                // after successful deletion, and the listener will show success message
                                                await context
                                                    .read<ProductsCubit>()
                                                    .deleteProduct(product.id);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'SKU: ${product.sku}',
                                        style: const TextStyle(
                                            color: AppColors.mutedForeground,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Wrap(
                                        spacing: AppSpacing.sm,
                                        children: [
                                          BadgeChip(label: product.category),
                                          BadgeChip(
                                            label: _statusLabel(product.status),
                                            tone: switch (product.status) {
                                              'available' => BadgeTone.success,
                                              'lowStock' => BadgeTone.warning,
                                              'outOfStock' => BadgeTone.danger,
                                              _ => BadgeTone.neutral,
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Row(
                                        children: [
                                          Text(
                                            'ج${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(width: AppSpacing.xl),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.inventory_2_outlined,
                                                  size: 16,
                                                  color: AppColors
                                                      .mutedForeground),
                                              const SizedBox(
                                                  width: AppSpacing.xs),
                                              Text(
                                                '${product.stock} قطعة',
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .mutedForeground,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${product.sales ?? 0} مبيعة',
                                            style: const TextStyle(
                                                color:
                                                    AppColors.mutedForeground,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            );
          },
          productLoaded: (product) =>
              const Center(child: Text('Product loaded')),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('خطأ: $message'),
                ElevatedButton(
                  onPressed: () => context.read<ProductsCubit>().getProducts(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _statusLabel(String status) {
    return switch (status) {
      'available' => 'متوفر',
      'lowStock' => 'مخزون منخفض',
      'outOfStock' => 'نافذ',
      _ => status,
    };
  }
}

class _FilterChip<T> extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.items,
    required this.onSelected,
    this.itemBuilder,
  });

  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T> onSelected;
  final String Function(T value)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      onChanged: (v) {
        if (v != null) onSelected(v);
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      dropdownColor: AppColors.surface,
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: [
        for (final item in items)
          DropdownMenuItem(
            value: item,
            child: Text(
                itemBuilder == null ? item.toString() : itemBuilder!(item)),
          ),
      ],
    );
  }
}

class _ProductMenu extends StatelessWidget {
  const _ProductMenu({
    required this.product,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductResponse product;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz, color: Colors.white54),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('عرض'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('تعديل'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
              SizedBox(width: AppSpacing.sm),
              Text('حذف', style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            onView();
            break;
          case 2:
            onEdit();
            break;
          case 3:
            onDelete();
            break;
        }
      },
    );
  }
}
