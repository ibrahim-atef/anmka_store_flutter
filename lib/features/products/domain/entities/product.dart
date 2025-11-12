class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.image,
    required this.sku,
    required this.sales,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final ProductStatus status;
  final String image;
  final String sku;
  final int sales;
}

enum ProductStatus {
  available,
  lowStock,
  outOfStock,
}

