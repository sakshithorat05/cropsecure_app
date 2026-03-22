class ProductModel {
  final String id;
  final String name;
  final String brandName;
  final String category; // fungicide | fertiliser | pesticide
  final List<String> imageUrls;
  final double pricePerUnit;
  final String unitLabel; // "per kg", "per litre", "per packet"
  final double weightOrVolume;
  final String weightUnit;
  final bool inStock;
  final double rating;
  final int reviewCount;
  final List<String> alsoKnownAs;
  final List<String> targetDiseases;
  final String safetyInstructions;
  final double dosagePerAcre;
  final String dosageUnit;
  final List<String> relatedProductIds;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brandName,
    required this.category,
    required this.imageUrls,
    required this.pricePerUnit,
    required this.unitLabel,
    required this.weightOrVolume,
    required this.weightUnit,
    required this.inStock,
    required this.rating,
    required this.reviewCount,
    required this.alsoKnownAs,
    required this.targetDiseases,
    required this.safetyInstructions,
    required this.dosagePerAcre,
    required this.dosageUnit,
    required this.relatedProductIds,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      brandName: map['brandName'] ?? '',
      category: map['category'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      pricePerUnit: (map['pricePerUnit'] ?? 0).toDouble(),
      unitLabel: map['unitLabel'] ?? '',
      weightOrVolume: (map['weightOrVolume'] ?? 0).toDouble(),
      weightUnit: map['weightUnit'] ?? '',
      inStock: map['inStock'] ?? false,
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      alsoKnownAs: List<String>.from(map['alsoKnownAs'] ?? []),
      targetDiseases: List<String>.from(map['targetDiseases'] ?? []),
      safetyInstructions: map['safetyInstructions'] ?? '',
      dosagePerAcre: (map['dosagePerAcre'] ?? 0.0).toDouble(),
      dosageUnit: map['dosageUnit'] ?? '',
      relatedProductIds: List<String>.from(map['relatedProductIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brandName': brandName,
      'category': category,
      'imageUrls': imageUrls,
      'pricePerUnit': pricePerUnit,
      'unitLabel': unitLabel,
      'weightOrVolume': weightOrVolume,
      'weightUnit': weightUnit,
      'inStock': inStock,
      'rating': rating,
      'reviewCount': reviewCount,
      'alsoKnownAs': alsoKnownAs,
      'targetDiseases': targetDiseases,
      'safetyInstructions': safetyInstructions,
      'dosagePerAcre': dosagePerAcre,
      'dosageUnit': dosageUnit,
      'relatedProductIds': relatedProductIds,
    };
  }
}
