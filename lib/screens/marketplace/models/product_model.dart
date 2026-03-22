class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final bool isOrganic;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.rating = 4.5,
    this.isOrganic = false,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id']?.toHexString() ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'General',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 4.5).toDouble(),
      isOrganic: map['isOrganic'] ?? false,
    );
  }
}
