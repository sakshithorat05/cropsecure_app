import 'dart:core';

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

  factory FarmHistoryModel.fromMap(Map<String, dynamic> map) {
    return FarmHistoryModel(
      id: map['_id']?.toHexString() ?? '',
      uid: map['uid'] as String? ?? '',
      createdAt: map['createdAt'] ?? DateTime.now(),
      type: map['type'] == 'treatment' ? FarmHistoryType.treatment : FarmHistoryType.scan,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata'] as Map) : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'createdAt': DateTime.now(), // MongoDB will store this as ISODate
      'type': type == FarmHistoryType.treatment ? 'treatment' : 'scan',
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }
}
