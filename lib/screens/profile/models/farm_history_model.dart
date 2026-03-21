import 'package:cloud_firestore/cloud_firestore.dart';

enum FarmHistoryType {
  scan,
  treatment,
}

class FarmHistoryModel {
  final String id;
  final String uid;
  final DateTime createdAt;
  final FarmHistoryType type;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final Map<String, dynamic> metadata;

  FarmHistoryModel({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.metadata = const {},
  });

  factory FarmHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return FarmHistoryModel(
      id: doc.id,
      uid: data['uid'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: data['type'] == 'treatment' ? FarmHistoryType.treatment : FarmHistoryType.scan,
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      metadata: data['metadata'] != null ? Map<String, dynamic>.from(data['metadata'] as Map) : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'type': type == FarmHistoryType.treatment ? 'treatment' : 'scan',
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }
}
