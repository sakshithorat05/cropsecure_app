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
}
