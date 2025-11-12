import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/order.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل ${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'معلومات الطلب',
                subtitle: 'بيانات العميل والطلب',
              ),
              const SizedBox(height: AppSpacing.sm),
              _infoRow('رقم الطلب', order.id),
              _infoRow('اسم العميل', order.customerName),
              _infoRow('المبلغ الكلي', 'ج${order.total.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  BadgeChip(
                    label: _statusLabel(order.status),
                    tone: switch (order.status) {
                      OrderStatus.newOrder => BadgeTone.info,
                      OrderStatus.inProgress => BadgeTone.warning,
                      OrderStatus.completed => BadgeTone.success,
                      OrderStatus.cancelled => BadgeTone.danger,
                    },
                  ),
                  BadgeChip(
                    label: _paymentLabel(order.paymentStatus),
                    tone: order.paymentStatus == PaymentStatus.paid
                        ? BadgeTone.success
                        : order.paymentStatus == PaymentStatus.pending
                            ? BadgeTone.warning
                            : BadgeTone.info,
                  ),
                  BadgeChip(
                    label: _shippingLabel(order.shippingStatus),
                    tone: order.shippingStatus == ShippingStatus.delivered
                        ? BadgeTone.success
                        : order.shippingStatus == ShippingStatus.inTransit
                            ? BadgeTone.warning
                            : BadgeTone.info,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('عناصر الطلب', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final item in order.items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: Text(item.name),
                  subtitle: Text('${item.quantity} قطعة'),
                  trailing: Text('ج${(item.price * item.quantity).toStringAsFixed(2)}'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.mutedForeground),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(OrderStatus status) {
    return switch (status) {
      OrderStatus.newOrder => 'جديد',
      OrderStatus.inProgress => 'قيد التنفيذ',
      OrderStatus.completed => 'مكتمل',
      OrderStatus.cancelled => 'ملغي',
    };
  }

  String _paymentLabel(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.pending => 'بانتظار الدفع',
      PaymentStatus.paid => 'مدفوع',
      PaymentStatus.refunded => 'مسترد',
    };
  }

  String _shippingLabel(ShippingStatus status) {
    return switch (status) {
      ShippingStatus.preparing => 'قيد التجهيز',
      ShippingStatus.inTransit => 'في الطريق',
      ShippingStatus.delivered => 'تم التسليم',
    };
  }
}

