import 'package:intl/intl.dart';

import '../../features/customers/domain/entities/customer.dart';
import '../../features/orders/domain/entities/order.dart';
import '../../features/products/domain/entities/product.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'ar_EG',
  symbol: 'ج',
  decimalDigits: 0,
);

class DashboardStat {
  const DashboardStat({
    required this.title,
    required this.value,
    required this.change,
    required this.changeIsPositive,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final bool changeIsPositive;
  final String icon;
}

class SalesPoint {
  const SalesPoint({
    required this.label,
    required this.sales,
    required this.orders,
  });

  final String label;
  final double sales;
  final int orders;
}

class TrafficSource {
  const TrafficSource({
    required this.name,
    required this.value,
    required this.percentage,
  });

  final String name;
  final double value;
  final double percentage;
}

class ActivityEntry {
  const ActivityEntry({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagTone,
  });

  final String title;
  final String subtitle;
  final String tag;
  final String tagTone;
}

final dashboardStats = <DashboardStat>[
  const DashboardStat(
    title: 'إجمالي المبيعات',
    value: 'ج8,502',
    change: '+12.5%',
    changeIsPositive: true,
    icon: 'money',
  ),
  const DashboardStat(
    title: 'الطلبات الجديدة',
    value: '24',
    change: '+8.2%',
    changeIsPositive: true,
    icon: 'cart',
  ),
  const DashboardStat(
    title: 'العملاء الجدد',
    value: '12',
    change: '+15.3%',
    changeIsPositive: true,
    icon: 'users',
  ),
  const DashboardStat(
    title: 'منتجات نافذة',
    value: '5',
    change: '-2',
    changeIsPositive: false,
    icon: 'alert',
  ),
  const DashboardStat(
    title: 'الزيارات اليوم',
    value: '1,234',
    change: '+18.7%',
    changeIsPositive: true,
    icon: 'eye',
  ),
  const DashboardStat(
    title: 'إجمالي المنتجات',
    value: '156',
    change: '+3',
    changeIsPositive: true,
    icon: 'box',
  ),
];

final dailySales = <SalesPoint>[
  const SalesPoint(label: 'السبت', sales: 2400, orders: 12),
  const SalesPoint(label: 'الأحد', sales: 1398, orders: 8),
  const SalesPoint(label: 'الاثنين', sales: 9800, orders: 24),
  const SalesPoint(label: 'الثلاثاء', sales: 3908, orders: 18),
  const SalesPoint(label: 'الأربعاء', sales: 4800, orders: 22),
  const SalesPoint(label: 'الخميس', sales: 3800, orders: 16),
  const SalesPoint(label: 'الجمعة', sales: 4300, orders: 20),
];

final weeklySales = <SalesPoint>[
  const SalesPoint(label: 'الأسبوع 1', sales: 24000, orders: 120),
  const SalesPoint(label: 'الأسبوع 2', sales: 18000, orders: 95),
  const SalesPoint(label: 'الأسبوع 3', sales: 32000, orders: 156),
  const SalesPoint(label: 'الأسبوع 4', sales: 28000, orders: 142),
];

final monthlySales = <SalesPoint>[
  const SalesPoint(label: 'يناير', sales: 85000, orders: 420),
  const SalesPoint(label: 'فبراير', sales: 92000, orders: 465),
  const SalesPoint(label: 'مارس', sales: 78000, orders: 385),
  const SalesPoint(label: 'أبريل', sales: 105000, orders: 520),
  const SalesPoint(label: 'مايو', sales: 118000, orders: 580),
  const SalesPoint(label: 'يونيو', sales: 125000, orders: 625),
];

final trafficSources = <TrafficSource>[
  const TrafficSource(name: 'إعلانات جوجل', value: 4500, percentage: 38),
  const TrafficSource(name: 'السوشيال ميديا', value: 3200, percentage: 27),
  const TrafficSource(name: 'البحث العضوي', value: 2800, percentage: 23),
  const TrafficSource(name: 'قوائم البريد', value: 1200, percentage: 10),
  const TrafficSource(name: 'شركاء', value: 600, percentage: 5),
];

final recentActivities = <ActivityEntry>[
  const ActivityEntry(
    title: 'طلب جديد #1234',
    subtitle: 'من محمد أحمد - ج125.00',
    tag: 'جديد',
    tagTone: 'success',
  ),
  const ActivityEntry(
    title: 'دفعة مكتملة',
    subtitle: 'الطلب #1233 - ج89.50',
    tag: 'مكتمل',
    tagTone: 'info',
  ),
  const ActivityEntry(
    title: 'تنبيه مخزون',
    subtitle: 'تي شيرت أزرق - 3 قطع متبقية',
    tag: 'تحذير',
    tagTone: 'danger',
  ),
];

final products = <Product>[
  const Product(
    id: 1,
    name: 'تي شيرت قطني أزرق',
    category: 'ملابس',
    price: 25.99,
    stock: 45,
    status: ProductStatus.available,
    image: 'assets/images/blue-cotton-t-shirt.png',
    sku: 'TS001',
    sales: 145,
  ),
  const Product(
    id: 2,
    name: 'جينز أسود كلاسيكي',
    category: 'ملابس',
    price: 49.99,
    stock: 23,
    status: ProductStatus.available,
    image: 'assets/images/black-classic-jeans.png',
    sku: 'JN002',
    sales: 128,
  ),
  const Product(
    id: 3,
    name: 'حذاء رياضي أبيض',
    category: 'أحذية',
    price: 79.99,
    stock: 12,
    status: ProductStatus.lowStock,
    image: 'assets/images/white-sports-shoes.png',
    sku: 'SH003',
    sales: 98,
  ),
  const Product(
    id: 4,
    name: 'سترة شتوية رمادية',
    category: 'ملابس',
    price: 89.99,
    stock: 0,
    status: ProductStatus.outOfStock,
    image: 'assets/images/gray-winter-jacket.png',
    sku: 'JK004',
    sales: 87,
  ),
  const Product(
    id: 5,
    name: 'قميص أبيض رسمي',
    category: 'ملابس',
    price: 35.99,
    stock: 67,
    status: ProductStatus.available,
    image: 'assets/images/white-formal-shirt.png',
    sku: 'SH005',
    sales: 76,
  ),
];

final recentOrders = <Order>[
  Order(
    id: '#1234',
    customerName: 'محمد أحمد',
    total: 125.00,
    status: OrderStatus.newOrder,
    paymentStatus: PaymentStatus.pending,
    shippingStatus: ShippingStatus.preparing,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    items: const [
      OrderItem(name: 'تي شيرت قطني أزرق', quantity: 1, price: 25.99),
      OrderItem(name: 'جينز أسود كلاسيكي', quantity: 1, price: 49.99),
    ],
  ),
  Order(
    id: '#1233',
    customerName: 'محمود علي',
    total: 89.50,
    status: OrderStatus.completed,
    paymentStatus: PaymentStatus.paid,
    shippingStatus: ShippingStatus.delivered,
    date: DateTime.now().subtract(const Duration(days: 1)),
    items: const [
      OrderItem(name: 'حذاء رياضي أبيض', quantity: 1, price: 79.99),
    ],
  ),
  Order(
    id: '#1232',
    customerName: 'سارة محمد',
    total: 210.00,
    status: OrderStatus.inProgress,
    paymentStatus: PaymentStatus.paid,
    shippingStatus: ShippingStatus.inTransit,
    date: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
    items: const [
      OrderItem(name: 'سترة شتوية رمادية', quantity: 1, price: 89.99),
      OrderItem(name: 'قميص أبيض رسمي', quantity: 2, price: 35.99),
    ],
  ),
];

final customers = <Customer>[
  Customer(
    id: 'CUS001',
    name: 'محمد أحمد',
    avatar: 'assets/images/placeholder-user.jpg',
    email: 'm.ahmed@example.com',
    phone: '+201234567890',
    tier: CustomerTier.vip,
    totalOrders: 42,
    totalSpent: 14520,
    lastActive: DateTime.now().subtract(const Duration(hours: 6)),
    tags: const ['VIP', 'متجر رياضات'],
  ),
  Customer(
    id: 'CUS002',
    name: 'سارة علي',
    avatar: 'assets/images/placeholder-user.jpg',
    email: 'sara@example.com',
    phone: '+201009875432',
    tier: CustomerTier.loyal,
    totalOrders: 18,
    totalSpent: 6230,
    lastActive: DateTime.now().subtract(const Duration(days: 1)),
    tags: const ['مهتم بالأزياء'],
  ),
  Customer(
    id: 'CUS003',
    name: 'أحمد سمير',
    avatar: 'assets/images/placeholder-user.jpg',
    email: 'ahmed.samir@example.com',
    phone: '+201556789012',
    tier: CustomerTier.newCustomer,
    totalOrders: 3,
    totalSpent: 950,
    lastActive: DateTime.now().subtract(const Duration(days: 3)),
    tags: const ['حملات جوجل'],
  ),
];

