class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.phone,
    required this.tier,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastActive,
    required this.tags,
  });

  final String id;
  final String name;
  final String avatar;
  final String email;
  final String phone;
  final CustomerTier tier;
  final int totalOrders;
  final double totalSpent;
  final DateTime lastActive;
  final List<String> tags;
}

enum CustomerTier { newCustomer, loyal, vip }

