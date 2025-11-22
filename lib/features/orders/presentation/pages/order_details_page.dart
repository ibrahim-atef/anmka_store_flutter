import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/response/order_response.dart';
import '../../domain/entities/order.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.orderResponse});

  final OrderResponse orderResponse;

  Order get order => _convertToOrder(orderResponse);

  Order _convertToOrder(OrderResponse response) {
    return Order(
      id: response.id,
      customerName: response.customerName,
      total: response.total,
      status: _parseOrderStatus(response.status),
      date: DateTime.parse(response.date),
      items: response.items
          .map((item) => OrderItem(
                name: item.name ?? 'منتج غير معروف',
                quantity: item.quantity,
                price: item.price,
              ))
          .toList(),
      paymentStatus: _parsePaymentStatus(response.paymentStatus),
      shippingStatus: _parseShippingStatus(response.shippingStatus),
    );
  }

  OrderStatus _parseOrderStatus(String status) {
    return switch (status) {
      'newOrder' => OrderStatus.newOrder,
      'inProgress' => OrderStatus.inProgress,
      'completed' => OrderStatus.completed,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.newOrder,
    };
  }

  PaymentStatus _parsePaymentStatus(String status) {
    return switch (status) {
      'pending' => PaymentStatus.pending,
      'paid' => PaymentStatus.paid,
      'refunded' => PaymentStatus.refunded,
      _ => PaymentStatus.pending,
    };
  }

  ShippingStatus _parseShippingStatus(String status) {
    return switch (status) {
      'preparing' => ShippingStatus.preparing,
      'inTransit' => ShippingStatus.inTransit,
      'delivered' => ShippingStatus.delivered,
      _ => ShippingStatus.preparing,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب #${orderResponse.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'معلومات الطلب',
                    subtitle: 'بيانات العميل والطلب',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _infoRow('رقم الطلب', '#${orderResponse.id}'),
                  _infoRow('تاريخ الطلب', _formatDate(orderResponse.date)),
                  _infoRow('المبلغ الكلي',
                      'ج${orderResponse.total.toStringAsFixed(2)}'),
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
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'معلومات العميل',
                    subtitle: 'بيانات الاتصال بالعميل',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _infoRow('اسم العميل', orderResponse.customerName),
                  if (orderResponse.customerEmail != null &&
                      orderResponse.customerEmail!.isNotEmpty)
                    _infoRow('البريد الإلكتروني', orderResponse.customerEmail!),
                  if (orderResponse.customerPhone != null &&
                      orderResponse.customerPhone!.isNotEmpty)
                    _infoRow('رقم الهاتف', orderResponse.customerPhone!),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'عنوان الشحن',
                    subtitle: 'عنوان تسليم الطلب',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (orderResponse.shippingAddress != null &&
                      orderResponse.shippingAddress!.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Text(
                        orderResponse.shippingAddress!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Text(
                        'لا يوجد عنوان شحن',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  if (orderResponse.notes != null &&
                      orderResponse.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.note_outlined,
                          size: 20,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ملاحظات',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColors.mutedForeground,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                orderResponse.notes!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عناصر الطلب',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final item in orderResponse.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text(
                          item.name ?? 'منتج غير معروف',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                            '${item.quantity} قطعة × ج${item.price.toStringAsFixed(2)}'),
                        trailing: Text(
                          'ج${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الإجمالي',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        Text(
                          'ج${orderResponse.total.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('yyyy/MM/dd - HH:mm', 'ar');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
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
