import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/disease_details_model.dart';

class DiseaseStageCard extends StatelessWidget {
  final String imageUrl;
  final String pestType;
  final String diseaseName;

  const DiseaseStageCard({
    super.key,
    required this.imageUrl,
    required this.pestType,
    required this.diseaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width for horizontal scrolling cards
      margin: const EdgeInsets.only(right: 12, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppColors.softShadow],
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Generate dummy details for the preview
            final dummyDetails = DiseaseDetailsModel(
              diseaseName: diseaseName,
              cropAffected: 'Jasmine',
              diseaseType: pestType,
              causalOrganism: 'Sample Pathogen',
              affectedPlantPart: 'Leaves and Stems',
              primarySpread: 'Wind and rain splash',
              severityLevel: 'High',
              description: 'This is a detailed description of $diseaseName. It commonly affects the plant during this stage and requires immediate attention to prevent severe crop loss.',
              imageUrl: imageUrl.isNotEmpty ? imageUrl : 'assets/images/placeholder.png',
              identifyStages: [
                IdentifyStage(stageNumber: 1, title: 'Early Stage', description: 'Initial spots appear on the lower leaves. Often neglected as nutrient deficiency.'),
                IdentifyStage(stageNumber: 2, title: 'Advanced Stage', description: 'Spots enlarge and turn brown with characteristic yellow halos. Fungal growth may be visible.'),
              ],
              favourableConditions: [
                FavourableCondition(icon: Icons.water_drop, title: 'High Humidity', description: 'Humidity > 85% accelerates spore germination.', backgroundColor: Colors.blue),
                FavourableCondition(icon: Icons.thermostat, title: 'Warm Temperature', description: 'Optimal growth between 24°C and 30°C.', backgroundColor: Colors.orange),
              ],
            );
            
            context.push('/disease-details', extra: dummyDetails);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 90,
                  width: double.infinity,
                  color: Colors.grey[200], // Placeholder background
                  child: const Icon(Icons.image, color: Colors.grey, size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pestType,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      diseaseName,
                      style: AppTextStyles.headingSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
