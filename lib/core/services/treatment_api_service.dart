import 'package:flutter/material.dart';
import '../../screens/treatment/models/disease_details_model.dart';
import '../../screens/treatment/models/treatment_advisory_model.dart';

class TreatmentApiService {
  Future<TreatmentAdvisoryData> fetchTreatmentAdvisory() async {
    // Simulating network delay for realistic API behavior
    await Future.delayed(const Duration(seconds: 2));

    // Simulated API response data
    return TreatmentAdvisoryData(
      cropName: 'Juhusa Ragi',
      diseaseName: 'Leaf Blight',
      severity: 'Medium Severity',
      detectionTime: 'Detected 2 hours ago',
      diseaseDetails:
          'Leaf blight is a fungal disease that affects the leaves of plants, causing dark, necrotic lesions. It typically thrives in warm, humid conditions and can quickly spread to other parts of the plant if left untreated. Early identification and targeted treatments are key to managing its impact.',
      fullDiseaseDetails: DiseaseDetailsModel(
        diseaseName: 'Leaf Blight',
        cropAffected: 'Jasmine / Juhusa Ragi',
        diseaseType: 'Fungal Disease',
        causalOrganism: 'Alternaria alternata / Cercospora jasminicola',
        affectedPlantPart: 'Leaves',
        primarySpread: 'Airborne spores, rain splash',
        severityLevel: 'Medium to High',
        description: 'Leaf blight is a fungal disease that rapidly spreads under warm, humid conditions, creating necrotic lesions on foliage.',
        imageUrl: 'placeholder_for_asset',
        identifyStages: [
          IdentifyStage(stageNumber: 1, title: 'Early Stage (Days 1–3)', description: 'Tiny yellow spots start appearing on the lower leaves. Often neglected as nutrient deficiency.'),
          IdentifyStage(stageNumber: 2, title: 'Developing Stage (Days 4–7)', description: 'Spots enlarge and turn brown with characteristic yellow halos. Fungal growth may be visible.'),
          IdentifyStage(stageNumber: 3, title: 'Advanced Stage (Days 8–14)', description: 'Lesions merge together. Parts of the leaf begin to dry out, shrivel, and exhibit necrosis.'),
          IdentifyStage(stageNumber: 4, title: 'Severe Stage (Beyond 14 days)', description: 'Total leaf drop occurs. Photosynthesis is severely impaired, affecting overall plant yield.'),
        ],
        favourableConditions: [
          FavourableCondition(icon: Icons.water_drop, title: 'High Humidity', description: 'Humidity > 85% accelerates spore germination.', backgroundColor: Colors.blue),
          FavourableCondition(icon: Icons.thermostat, title: 'Warm Temperature', description: 'Optimal growth between 24°C and 30°C.', backgroundColor: Colors.orange),
          FavourableCondition(icon: Icons.air, title: 'Poor Air Circulation', description: 'Dense planting prevents leaf drying.', backgroundColor: Colors.purple),
          FavourableCondition(icon: Icons.cloudy_snowing, title: 'Frequent Rain', description: 'Rain splash physically spreads spores to healthy plants.', backgroundColor: Colors.teal),
        ],
      ),
      diseaseRiskToday: RiskModel(
        humidity: 'High',
        rainChance: '60%',
        riskLevel: 'High',
        warning: 'Avoid spraying today due to high chance of rain.',
      ),
      treatments: [
        TreatmentModel(
          label: 'FAST ACTING',
          medicineName: 'Carbendazim 50% WP (Fungicide)',
          type: 'Chemical',
          description:
              'Mix 2 grams per liter of water. Spray thoroughly over affected areas during early morning or late evening.',
          successRate: '92%',
        ),
        TreatmentModel(
          label: 'ECO-FRIENDLY',
          medicineName: 'Mancozeb 75% WP (Fungicide)',
          type: 'Organic',
          description:
              'Mix 2.5 grams per liter of water. Ensure even coverage across all leaves. Repeat after 14 days if needed.',
          successRate: '85%',
        ),
      ],
    );
  }
}
