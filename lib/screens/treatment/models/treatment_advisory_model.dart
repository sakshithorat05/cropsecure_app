import 'disease_details_model.dart';

class TreatmentModel {
  final String label;
  final String medicineName;
  final String type; // "Chemical" or "Organic"
  final String description;
  final String successRate;

  TreatmentModel({
    required this.label,
    required this.medicineName,
    required this.type,
    required this.description,
    required this.successRate,
  });
}

class RiskModel {
  final String humidity;
  final String rainChance;
  final String riskLevel;
  final String warning;

  RiskModel({
    required this.humidity,
    required this.rainChance,
    required this.riskLevel,
    required this.warning,
  });
}

class TreatmentAdvisoryData {
  final String cropName;
  final String diseaseName;
  final String severity;
  final String detectionTime;
  final String diseaseDetails; 
  final DiseaseDetailsModel fullDiseaseDetails; 
  final List<DiseaseTreatmentModel> treatments;
  final RiskModel diseaseRiskToday;

  TreatmentAdvisoryData({
    required this.cropName,
    required this.diseaseName,
    required this.severity,
    required this.detectionTime,
    required this.diseaseDetails,
    required this.fullDiseaseDetails,
    required this.treatments,
    required this.diseaseRiskToday,
  });
}

