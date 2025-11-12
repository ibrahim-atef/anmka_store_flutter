class Order {
  const Order({
    required this.id,
    required this.customerName,
    required this.total,
    required this.status,
    required this.date,
    required this.items,
    required this.paymentStatus,
    required this.shippingStatus,
  });

  final String id;
  final String customerName;
  final double total;
  final OrderStatus status;
  final DateTime date;
  final List<OrderItem> items;
  final PaymentStatus paymentStatus;
  final ShippingStatus shippingStatus;
}

class OrderItem {
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final double price;
}

enum OrderStatus { newOrder, inProgress, completed, cancelled }

enum PaymentStatus { pending, paid, refunded }

enum ShippingStatus { preparing, inTransit, delivered }

