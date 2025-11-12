import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/data/mock_data.dart' as data;
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Order> _orders = data.recentOrders;
  Order? _selectedOrder;

  @override
  void initState() {
    super.initState();
    if (_orders.isNotEmpty) {
      _selectedOrder = _orders.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 840;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'الطلبات',
                subtitle: 'متابعة الطلبات الأخيرة وإدارتها',
                trailing: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('نموذج إضافة طلب جديد قيد التطوير')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('طلب جديد'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildOrdersList(context)),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(child: _buildOrderDetails(context, _selectedOrder)),
                  ],
                )
              else ...[
                _buildOrdersList(context),
                const SizedBox(height: AppSpacing.lg),
                _buildOrderDetails(context, _selectedOrder),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'الطلبات الأخيرة',
            subtitle: 'أحدث العمليات خلال الأيام الماضية',
          ),
          for (final order in _orders)
            GestureDetector(
              onTap: () => setState(() => _selectedOrder = order),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: order == _selectedOrder
                      ? AppColors.primary.withOpacity(0.12)
                      : AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: order == _selectedOrder
                        ? AppColors.primary.withOpacity(0.35)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.id,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        BadgeChip(
                          label: _statusLabel(order.status),
                          tone: switch (order.status) {
                            OrderStatus.newOrder => BadgeTone.info,
                            OrderStatus.inProgress => BadgeTone.warning,
                            OrderStatus.completed => BadgeTone.success,
                            OrderStatus.cancelled => BadgeTone.danger,
                          },
                        ),
                        const Spacer(),
                        Text(
                          'ج${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${order.customerName} • ${data.currencyFormatter.format(order.total)}',
                      style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppColors.mutedForeground),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          DateFormat('EEE d MMM', 'ar').format(order.date),
                          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                        ),
                        const Spacer(),
                        BadgeChip(
                          label: _paymentLabel(order.paymentStatus),
                          tone: order.paymentStatus == PaymentStatus.paid
                              ? BadgeTone.success
                              : order.paymentStatus == PaymentStatus.pending
                                  ? BadgeTone.warning
                                  : BadgeTone.info,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, Order? order) {
    if (order == null) {
      return AppCard(
        child: SizedBox(
          height: 220,
          child: Center(
            child: Text(
              'اختر طلباً لعرض التفاصيل',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'تفاصيل ${order.id}',
            subtitle: 'معلومات الطلب وسير العمل',
            trailing: BadgeChip(
              label: _shippingLabel(order.shippingStatus),
              tone: switch (order.shippingStatus) {
                ShippingStatus.preparing => BadgeTone.info,
                ShippingStatus.inTransit => BadgeTone.warning,
                ShippingStatus.delivered => BadgeTone.success,
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _infoRow('العميل', order.customerName),
          _infoRow('المجموع', data.currencyFormatter.format(order.total)),
          _infoRow(
            'طريقة الدفع',
            _paymentLabel(order.paymentStatus),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'المنتجات',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final item in order.items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.name),
              subtitle: Text('${item.quantity} قطعة'),
              trailing: Text('ج${(item.price * item.quantity).toStringAsFixed(2)}'),
            ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('حالة الشحن'),
            subtitle: Text(_shippingTimelineSubtitle(order.shippingStatus)),
            trailing: Icon(
              switch (order.shippingStatus) {
                ShippingStatus.preparing => Icons.local_shipping_outlined,
                ShippingStatus.inTransit => Icons.airport_shuttle_outlined,
                ShippingStatus.delivered => Icons.check_circle_outline,
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ميزة طباعة الفاتورة قادمة قريباً')),
                    );
                  },
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('طباعة الفاتورة'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث حالة الطلب بنجاح (محاكاة)')),
                    );
                  },
                  icon: const Icon(Icons.task_alt),
                  label: const Text('تحديث الحالة'),
                ),
              ),
            ],
          ),
        ],
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
      OrderStatus.inProgress => 'جاري التنفيذ',
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

  String _shippingTimelineSubtitle(ShippingStatus status) {
    return switch (status) {
      ShippingStatus.preparing => 'يتم تجهيز الطلب للشحن',
      ShippingStatus.inTransit => 'الطلب خرج للتسليم',
      ShippingStatus.delivered => 'تم تسليم الطلب إلى العميل',
    };
  }
}

