enum DashboardSalesPeriod { daily, weekly, monthly }

extension DashboardSalesPeriodMapper on DashboardSalesPeriod {
  String get apiValue => switch (this) {
        DashboardSalesPeriod.daily => 'daily',
        DashboardSalesPeriod.weekly => 'weekly',
        DashboardSalesPeriod.monthly => 'monthly',
      };

  String get displayLabel => switch (this) {
        DashboardSalesPeriod.daily => 'يومي',
        DashboardSalesPeriod.weekly => 'أسبوعي',
        DashboardSalesPeriod.monthly => 'شهري',
      };
}

class DashboardSalesPoint {
  const DashboardSalesPoint({
    required this.label,
    required this.sales,
    required this.orders,
  });

  final String label;
  final double sales;
  final int orders;
}

class DashboardTopProduct {
  const DashboardTopProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.sales,
    this.image,
  });

  final int id;
  final String name;
  final double price;
  final int sales;
  final String? image;
}

class DashboardTrafficSourceEntry {
  const DashboardTrafficSourceEntry({
    required this.name,
    required this.value,
    required this.percentage,
  });

  final String name;
  final double value;
  final double percentage;
}

class DashboardActivityEntry {
  const DashboardActivityEntry({
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

