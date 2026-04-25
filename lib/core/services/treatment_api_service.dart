import '../../screens/treatment/models/disease_details_model.dart';
import '../../screens/treatment/models/treatment_advisory_model.dart';
import 'database_service.dart';

class TreatmentApiService {
  final DatabaseService _db = DatabaseService();

  Future<TreatmentAdvisoryData> fetchTreatmentAdvisory({String? cropName}) async {
    // 1. Fetch diseases (optionally filtered by crop)
    List<DiseaseDetailsModel> allDiseases = [];
    if (cropName != null) {
      allDiseases = await _db.getDiseasesByCrop(cropName);
    }
    
    // Fallback if no specific crop diseases or cropName is null
    if (allDiseases.isEmpty) {
      allDiseases = await _db.getAllDiseases();
    }
    
    if (allDiseases.isEmpty) {
      throw Exception('No diseases found in database.');
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

    final weather = await _db.getLatestWeather();
    
    String humidityStr = 'Normal';
    String riskLevelStr = 'Moderate';
    String warningStr = 'Good time for application.';
    
    if (weather != null) {
      final dynamic rawHumidity = weather['humidity'];
      humidityStr = rawHumidity?.toString() ?? 'Normal';
      
      // Try to determine risk if it's a number
      if (rawHumidity is num) {
        if (rawHumidity > 70) {
          riskLevelStr = 'High';
          warningStr = 'High humidity detected. Avoid spraying if rain is expected.';
        } else {
          riskLevelStr = 'Low';
          warningStr = 'Ideal conditions for spraying.';
        }
      } else if (humidityStr.toLowerCase().contains('high')) {
        riskLevelStr = 'High';
        warningStr = 'Humidity is high. Check for rain before spraying.';
      } else {
        riskLevelStr = 'Normal';
        warningStr = 'Standard conditions for application.';
      }
    }

    return TreatmentAdvisoryData(
      cropName: disease.cropAffected,
      diseaseName: disease.diseaseName,
      severity: 'Medium', 
      detectionTime: 'Updated recently',
      diseaseDetails: disease.causes.isNotEmpty ? disease.causes.first : '',
      fullDiseaseDetails: disease,
      diseaseRiskToday: RiskModel(
        humidity: humidityStr,
        rainChance: '10%', // Could also be fetched if available in DB
        riskLevel: riskLevelStr,
        warning: warningStr,
      ),
      treatments: [
        ...disease.organicTreatments,
        ...disease.chemicalTreatments,
      ],
    );
  }
}

