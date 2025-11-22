import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/network/dependency_injection.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../data/repositories/products_repository.dart';
import '../../domain/entities/product.dart';
import '../../logic/cubit/products_cubit.dart';
import 'add_product_page.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  void _openEditPage(BuildContext detailsContext, ProductsCubit cubit) {
    Navigator.of(detailsContext).push(
      MaterialPageRoute(
        builder: (editRouteContext) => BlocProvider.value(
          value: cubit,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ProductFormPage(
              initialProduct: product,
              onBack: () {
                // Close the edit page first
                Navigator.of(editRouteContext).pop();
                // Then close the details page after a microtask
                // to ensure the edit page is fully closed
                Future.microtask(() {
                  if (detailsContext.mounted) {
                    Navigator.of(detailsContext).pop();
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Builder(
            builder: (builderContext) {
              // Try to get ProductsCubit from context
              try {
                final cubit = builderContext.read<ProductsCubit>();
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'تعديل المنتج',
                  onPressed: () => _openEditPage(builderContext, cubit),
                );
              } catch (e) {
                // If ProductsCubit is not in context, use getIt
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'تعديل المنتج',
                  onPressed: () {
                    final cubit = ProductsCubit(
                      getIt<ProductsRepository>(),
                    );
                    _openEditPage(builderContext, cubit);
                  },
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        child: Image.network(
                          product.image == ''
                              ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_hWubOwCUsUchCRvVuMya7QQXwsSTuuhpHA&s'
                              : product.image,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 120,
                            height: 120,
                            color: AppColors.surfaceSecondary,
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: [
                                BadgeChip(label: product.category),
                                BadgeChip(
                                  label: product.status ==
                                          ProductStatus.available
                                      ? 'متوفر'
                                      : product.status == ProductStatus.lowStock
                                          ? 'مخزون منخفض'
                                          : 'نافذ',
                                  tone: switch (product.status) {
                                    ProductStatus.available =>
                                      BadgeTone.success,
                                    ProductStatus.lowStock => BadgeTone.warning,
                                    ProductStatus.outOfStock =>
                                      BadgeTone.danger,
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'سعر البيع: ج${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'المخزون المتوفر: ${product.stock} قطعة',
                              style: const TextStyle(
                                  color: AppColors.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'وصف المنتج',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'هذا النص مجرد مثال لعرض وصف المنتج. يمكنك استبداله بوصف المنتج الحقيقي عند ربط التطبيق بواجهة برمجية.',
                    style: TextStyle(color: AppColors.mutedForeground),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Divider(color: AppColors.border.withOpacity(0.7)),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined),
                      const SizedBox(width: AppSpacing.sm),
                      Text('رمز SKU: ${product.sku}'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.bar_chart_outlined),
                      const SizedBox(width: AppSpacing.sm),
                      Text('عدد المبيعات: ${product.sales} قطعة'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
