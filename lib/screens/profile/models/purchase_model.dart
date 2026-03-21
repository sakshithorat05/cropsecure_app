import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory PurchaseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return PurchaseModel(
      id: doc.id,
      uid: data['uid'] as String? ?? '',
      productName: data['productName'] as String? ?? 'Unknown Product',
      productCategory: data['productCategory'] as String? ?? 'Inputs',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      purchaseDate: (data['purchaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] as String? ?? 'Completed',
      imageUrl: data['imageUrl'] as String?,
    );
  }
}
