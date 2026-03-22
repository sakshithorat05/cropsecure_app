class PurchaseModel {
  final String id;
  final String uid;
  final String productName;
  final String productCategory;
  final double price;
  final int quantity;
  final DateTime purchaseDate;
  final String status;
  final String? imageUrl;

  PurchaseModel({
    required this.id,
    required this.uid,
    required this.productName,
    required this.productCategory,
    required this.price,
    required this.quantity,
    required this.purchaseDate,
    required this.status,
    this.imageUrl,
  });

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      id: map['_id']?.toHexString() ?? '',
      uid: map['uid'] as String? ?? '',
      productName: map['productName'] as String? ?? 'Unknown Product',
      productCategory: map['productCategory'] as String? ?? 'Inputs',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      purchaseDate: map['purchaseDate'] ?? DateTime.now(),
      status: map['status'] as String? ?? 'Completed',
      imageUrl: map['imageUrl'] as String?,
    );
  }
}
