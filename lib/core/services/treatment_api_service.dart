import 'package:flutter/material.dart';
import '../../screens/treatment/models/disease_details_model.dart';
import '../../screens/treatment/models/treatment_advisory_model.dart';
import 'database_service.dart';

class TreatmentApiService {
  final DatabaseService _db = DatabaseService();

  Future<TreatmentAdvisoryData> fetchTreatmentAdvisory() async {
    // 1. Fetch all diseases and pick the first one as "Latest Advisory" for demo
    // In a real app, this would be based on the user's latest scan result.
    final allDiseases = await _db.getAllDiseases();
    
    if (allDiseases.isEmpty) {
      throw Exception('No diseases in database');
    }

    final disease = allDiseases.first;

    // 2. Map the disease model to the advisory model
    // Note: TreatmentAdvisoryData expects TreatmentModel, but DiseaseDetailsModel 
    // uses DiseaseTreatmentModel. We'll convert them.
    
    List<TreatmentModel> mappedTreatments = [
      ...disease.organicTreatments.map((t) => TreatmentModel(
        label: 'ECO-FRIENDLY',
        medicineName: t.title,
        type: 'Organic',
        description: '${t.use}. Dose: ${t.dose}. ${t.benefit}',
        successRate: '85%',
      )),
      ...disease.chemicalTreatments.map((t) => TreatmentModel(
        label: 'FAST ACTING',
        medicineName: t.title,
        type: 'Chemical',
        description: '${t.use}. Dose: ${t.dose}. ${t.benefit}',
        successRate: '92%',
      )),
    ];

    return TreatmentAdvisoryData(
      cropName: disease.cropAffected,
      diseaseName: disease.diseaseName,
      severity: 'Medium Severity', // Could be dynamic from some latest report
      detectionTime: 'Updated just now',
      diseaseDetails: disease.causes.isNotEmpty ? disease.causes.first : '',
      fullDiseaseDetails: disease,
      diseaseRiskToday: RiskModel(
        humidity: 'High',
        rainChance: '20%',
        riskLevel: 'Moderate',
        warning: 'Good time for application.',
      ),
      treatments: mappedTreatments,
    );
  }
}

