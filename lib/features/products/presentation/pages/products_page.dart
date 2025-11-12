import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/data/mock_data.dart' as data;
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.onAddProduct});

  final VoidCallback onAddProduct;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  ProductStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = data.products.where((product) {
      final matchesSearch = product.name.contains(_searchController.text);
      final matchesCategory = _selectedCategory == 'الكل' || product.category == _selectedCategory;
      final matchesStatus = _selectedStatus == null || product.status == _selectedStatus;
      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();

    final categories = {
      'الكل',
      ...data.products.map((e) => e.category),
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
              onPressed: widget.onAddProduct,
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
                      onSelected: (value) => setState(() => _selectedCategory = value),
                    ),
                    _FilterChip<ProductStatus?>(
                      label: 'الحالة',
                      value: _selectedStatus,
                      items: const [null, ProductStatus.available, ProductStatus.lowStock, ProductStatus.outOfStock],
                      itemBuilder: (status) => switch (status) {
                        null => 'جميع الحالات',
                        ProductStatus.available => 'متوفر',
                        ProductStatus.lowStock => 'مخزون منخفض',
                        ProductStatus.outOfStock => 'نافذ',
                      },
                      onSelected: (value) => setState(() => _selectedStatus = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final product in filtered)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.asset(
                        product.image,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              _ProductMenu(product: product),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'SKU: ${product.sku}',
                            style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            children: [
                              BadgeChip(label: product.category),
                              BadgeChip(
                                label: _statusLabel(product.status),
                                tone: switch (product.status) {
                                  ProductStatus.available => BadgeTone.success,
                                  ProductStatus.lowStock => BadgeTone.warning,
                                  ProductStatus.outOfStock => BadgeTone.danger,
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Text(
                                'ج${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: AppSpacing.xl),
                              Row(
                                children: [
                                  const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.mutedForeground),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    '${product.stock} قطعة',
                                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '${product.sales} مبيعة',
                                style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
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
        ],
      ),
    );
  }

  String _statusLabel(ProductStatus status) {
    return switch (status) {
      ProductStatus.available => 'متوفر',
      ProductStatus.lowStock => 'مخزون منخفض',
      ProductStatus.outOfStock => 'نافذ',
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
            child: Text(itemBuilder == null ? item.toString() : itemBuilder!(item)),
          ),
      ],
    );
  }
}

class _ProductMenu extends StatelessWidget {
  const _ProductMenu({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz, color: Colors.white54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('عرض'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('تعديل'),
            ],
          ),
        ),
        const PopupMenuItem(
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('قريباً - خيار ($value) للمنتج ${product.name}')),
        );
      },
    );
  }
}

