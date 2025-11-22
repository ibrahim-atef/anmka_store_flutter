import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/response/order_response.dart';
import '../../domain/entities/order.dart';
import '../../logic/cubit/orders_cubit.dart';
import '../../logic/states/orders_state.dart';
import 'add_order_wrapper_page.dart';
import 'order_details_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderResponse? _selectedOrder;

  void _openAddOrder() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => Directionality(
          textDirection: TextDirection.rtl,
          child: AddOrderWrapperPage(
            onBack: () => Navigator.of(routeContext).pop(true),
          ),
        ),
      ),
    );
    // Refresh orders list after returning from add order page
    if (mounted && result == true) {
      context.read<OrdersCubit>().getOrders();
    }
  }

  void _openOrderDetails(OrderResponse orderResponse) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: OrderDetailsPage(orderResponse: orderResponse),
        ),
      ),
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

  void _showStatusSheet(OrderResponse order) async {
    final newStatus = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AppCard(
            margin: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'تحديث حالة الطلب',
                  subtitle: 'اختر الحالة الجديدة للطلب',
                ),
                for (final status in [
                  'newOrder',
                  'inProgress',
                  'completed',
                  'cancelled'
                ])
                  RadioListTile<String>(
                    value: status,
                    groupValue: order.status,
                    onChanged: (value) => Navigator.of(ctx).pop(value),
                    title: Text(_statusLabel(status)),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (newStatus != null && newStatus != order.status) {
      context.read<OrdersCubit>().updateOrderStatus(order.id, newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (ordersList) {
            final orders = ordersList.orders;
            if (_selectedOrder == null && orders.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _selectedOrder = orders.first);
              });
            }

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
                          onPressed: _openAddOrder,
                          icon: const Icon(Icons.add),
                          label: const Text('طلب جديد'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildOrdersList(context, orders)),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                                child: _buildOrderDetails(
                                    context, _selectedOrder)),
                          ],
                        )
                      else ...[
                        _buildOrdersList(context, orders),
                        const SizedBox(height: AppSpacing.lg),
                        _buildOrderDetails(context, _selectedOrder),
                      ],
                    ],
                  ),
                );
              },
            );
          },
          orderLoaded: (order) =>
              const Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('خطأ: $message'),
                ElevatedButton(
                  onPressed: () => context.read<OrdersCubit>().getOrders(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderResponse> orders) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'الطلبات الأخيرة',
            subtitle: 'أحدث العمليات خلال الأيام الماضية',
          ),
          if (orders.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('لا توجد طلبات'),
              ),
            )
          else
            for (final order in orders)
              GestureDetector(
                onTap: () {
                  setState(() => _selectedOrder = order);
                  final isWide = MediaQuery.of(context).size.width > 840;
                  if (!isWide) {
                    _openOrderDetails(order);
                  }
                },
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
                            '#${order.id}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          BadgeChip(
                            label: _statusLabel(order.status),
                            tone: switch (order.status) {
                              'newOrder' => BadgeTone.info,
                              'inProgress' => BadgeTone.warning,
                              'completed' => BadgeTone.success,
                              'cancelled' => BadgeTone.danger,
                              _ => BadgeTone.neutral,
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
                        '${order.customerName} • ج${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: AppColors.mutedForeground, fontSize: 12),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: AppColors.mutedForeground),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            order.date,
                            style: const TextStyle(
                                color: AppColors.mutedForeground, fontSize: 12),
                          ),
                          const Spacer(),
                          BadgeChip(
                            label: _paymentLabel(order.paymentStatus),
                            tone: order.paymentStatus == 'paid'
                                ? BadgeTone.success
                                : order.paymentStatus == 'pending'
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

  Widget _buildOrderDetails(BuildContext context, OrderResponse? order) {
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
            title: 'تفاصيل #${order.id}',
            subtitle: 'معلومات الطلب وسير العمل',
            trailing: BadgeChip(
              label: _shippingLabel(order.shippingStatus),
              tone: switch (order.shippingStatus) {
                'preparing' => BadgeTone.info,
                'inTransit' => BadgeTone.warning,
                'delivered' => BadgeTone.success,
                _ => BadgeTone.neutral,
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _infoRow('العميل', order.customerName),
          _infoRow('المجموع', 'ج${order.total.toStringAsFixed(2)}'),
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
              title: Text(item.name ?? ''),
              subtitle: Text('${item.quantity} قطعة'),
              trailing:
                  Text('ج${(item.price * item.quantity).toStringAsFixed(2)}'),
            ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('حالة الشحن'),
            subtitle: Text(_shippingTimelineSubtitle(order.shippingStatus)),
            trailing: Icon(
              switch (order.shippingStatus) {
                'preparing' => Icons.local_shipping_outlined,
                'inTransit' => Icons.airport_shuttle_outlined,
                'delivered' => Icons.check_circle_outline,
                _ => Icons.local_shipping_outlined,
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
                      const SnackBar(
                          content: Text('ميزة طباعة الفاتورة قادمة قريباً')),
                    );
                  },
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('طباعة الفاتورة'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _showStatusSheet(order),
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

  String _statusLabel(String status) {
    return switch (status) {
      'newOrder' => 'جديد',
      'inProgress' => 'جاري التنفيذ',
      'completed' => 'مكتمل',
      'cancelled' => 'ملغي',
      _ => status,
    };
  }

  String _paymentLabel(String status) {
    return switch (status) {
      'pending' => 'بانتظار الدفع',
      'paid' => 'مدفوع',
      'refunded' => 'مسترد',
      _ => status,
    };
  }

  String _shippingLabel(String status) {
    return switch (status) {
      'preparing' => 'قيد التجهيز',
      'inTransit' => 'في الطريق',
      'delivered' => 'تم التسليم',
      _ => status,
    };
  }

  String _shippingTimelineSubtitle(String status) {
    return switch (status) {
      'preparing' => 'يتم تجهيز الطلب للشحن',
      'inTransit' => 'الطلب خرج للتسليم',
      'delivered' => 'تم تسليم الطلب إلى العميل',
      _ => status,
    };
  }
}
