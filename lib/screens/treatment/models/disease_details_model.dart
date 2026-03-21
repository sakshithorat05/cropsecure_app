class DiseaseDetailsModel {
  final String id;
  final String cropAffected;
  final String diseaseName;
  final String diseaseType;
  final String causalOrganism;
  final String scientificName;
  final List<String> stages;
  final List<String> images;
  final List<DiseaseSymptomModel> symptoms;
  final List<String> causes;
  final List<DiseaseTreatmentModel> organicTreatments;
  final List<DiseaseTreatmentModel> chemicalTreatments;
  final List<String> preventiveMeasures;

  DiseaseDetailsModel({
    required this.id,
    required this.cropAffected,
    required this.diseaseName,
    required this.diseaseType,
    required this.causalOrganism,
    required this.scientificName,
    required this.stages,
    required this.images,
    required this.symptoms,
    required this.causes,
    required this.organicTreatments,
    required this.chemicalTreatments,
    required this.preventiveMeasures,
  });

  factory DiseaseDetailsModel.fromJson(Map<String, dynamic>? jsonInput, String documentId) {
    final json = jsonInput ?? {};
    List<String> parsedStages = [];
    if (json['stage'] is List) {
      parsedStages = List<String>.from(json['stage']);
    } else if (json['stage'] is String) {
      parsedStages = [json['stage'] as String];
    }

    return DiseaseDetailsModel(
      id: documentId,
      cropAffected: json['cropAffected'] as String? ?? '',
      diseaseName: json['diseaseName'] as String? ?? '',
      diseaseType: json['diseaseType'] as String? ?? '',
      causalOrganism: json['causalOrganism'] as String? ?? '',
      scientificName: json['scientificName'] as String? ?? '',
      stages: parsedStages,
      images: json['images'] != null ? List<String>.from(json['images'] as Iterable) : [],
      causes: json['causes'] != null ? List<String>.from(json['causes'] as Iterable) : [],
      preventiveMeasures: json['preventiveMeasures'] != null ? List<String>.from(json['preventiveMeasures'] as Iterable) : [],
      symptoms: json['symptoms'] != null 
          ? (json['symptoms'] as List).map((i) => DiseaseSymptomModel.fromJson(i as Map<String, dynamic>? ?? {})).toList() 
          : [],
      organicTreatments: json['organicTreatments'] != null 
          ? (json['organicTreatments'] as List).map((i) => DiseaseTreatmentModel.fromJson(i as Map<String, dynamic>? ?? {})).toList() 
          : [],
      chemicalTreatments: json['chemicalTreatments'] != null 
          ? (json['chemicalTreatments'] as List).map((i) => DiseaseTreatmentModel.fromJson(i as Map<String, dynamic>? ?? {})).toList() 
          : [],
    );
  }
}

class DiseaseSymptomModel {
  final String title;
  final String iconName;
  final List<String> bullets;

  DiseaseSymptomModel({
    required this.title,
    required this.iconName,
    required this.bullets,
  });

  factory DiseaseSymptomModel.fromJson(Map<String, dynamic> json) {
    return DiseaseSymptomModel(
      title: json['title'] ?? '',
      iconName: json['iconName'] ?? '',
      bullets: json['bullets'] != null ? List<String>.from(json['bullets']) : [],
    );
  }
}

class DiseaseTreatmentModel {
  final String title;
  final String type;
  final String use;
  final String dose;
  final String benefit;

  DiseaseTreatmentModel({
    required this.title,
    required this.type,
    required this.use,
    required this.dose,
    required this.benefit,
  });

  factory DiseaseTreatmentModel.fromJson(Map<String, dynamic> json) {
    return DiseaseTreatmentModel(
      title: json['title'] ?? json['medicineName'] ?? '',
      type: json['type'] ?? '',
      use: json['use'] ?? '',
      dose: json['dose'] ?? '',
      benefit: json['benefit'] ?? json['description'] ?? '',
    );
  }
}
