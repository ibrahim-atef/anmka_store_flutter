import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../domain/entities/product.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
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
                        child: Image.asset(
                          product.image,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: [
                                BadgeChip(label: product.category),
                                BadgeChip(
                                  label: product.status == ProductStatus.available
                                      ? 'متوفر'
                                      : product.status == ProductStatus.lowStock
                                          ? 'مخزون منخفض'
                                          : 'نافذ',
                                  tone: switch (product.status) {
                                    ProductStatus.available => BadgeTone.success,
                                    ProductStatus.lowStock => BadgeTone.warning,
                                    ProductStatus.outOfStock => BadgeTone.danger,
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
                              style: const TextStyle(color: AppColors.mutedForeground),
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

