import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/disease_stage_section.dart';

class PestsAndDiseasesScreen extends StatelessWidget {
  const PestsAndDiseasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    const seedlingDiseases = [
      {'diseaseName': 'Root Rot (Early Stage)', 'pestType': 'Fungus-Fusarium', 'imageUrl': ''},
      {'diseaseName': 'Leaf Spot', 'pestType': 'Fungal infection', 'imageUrl': ''},
      {'diseaseName': 'Damping-off', 'pestType': 'Fungus - Pythium', 'imageUrl': ''},
      {'diseaseName': 'Collar Rot', 'pestType': 'Fungus', 'imageUrl': ''},
    ];
    
    const vegetativeDiseases = [
      {'diseaseName': 'Leaf Blight', 'pestType': 'Fungus', 'imageUrl': ''},
      {'diseaseName': 'Powdery Mildew', 'pestType': 'Fungus', 'imageUrl': ''},
      {'diseaseName': 'Sooty Mold', 'pestType': 'Fungus (secondary)', 'imageUrl': ''},
      {'diseaseName': 'Rust', 'pestType': 'Fungus', 'imageUrl': ''},
    ];

    const floweringDiseases = [
      {'diseaseName': 'Bud Rot', 'pestType': 'Fungus', 'imageUrl': ''},
      {'diseaseName': 'Blossom Blight', 'pestType': 'Fungus', 'imageUrl': ''},
      {'diseaseName': 'Anthracnose', 'pestType': 'Fungus', 'imageUrl': ''},
      {'diseaseName': 'Blossom Midge', 'pestType': 'Insect', 'imageUrl': ''},
    ];

    const harvestingDiseases = [
      {'diseaseName': 'Grey Mold', 'pestType': 'Fungus', 'imageUrl': ''},
      {'diseaseName': 'Soft Rot', 'pestType': 'Bacterial Disease', 'imageUrl': ''},
      {'diseaseName': 'Thrips', 'pestType': 'Insect', 'imageUrl': ''},
      {'diseaseName': 'Mealybugs', 'pestType': 'Insect', 'imageUrl': ''},
    ];

    void navigateToStage(String title, List<Map<String, String>> data) {
      context.push('/treatment/stage-expanded', extra: {
        'title': title,
        'diseases': data,
      });
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Pests and Diseases',
          style: AppTextStyles.appBarTitle,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pest & Diseases', style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('See relevant information on Jasmine', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Diseases By Stage', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              'All pests and diseases that might appear in your crop at different stages', 
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Jasmine image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/jasmine_crop.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.local_florist, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Stages Lists
            DiseaseStageSection(
              stageTitle: 'Seedling Stage',
              stageIcon: Icons.grass,
              iconColor: Colors.lightGreen,
              diseases: seedlingDiseases,
              onViewAll: () => navigateToStage('Seedling Stage', seedlingDiseases),
            ),
            DiseaseStageSection(
              stageTitle: 'Vegetative Stage',
              stageIcon: Icons.eco,
              iconColor: Colors.green,
              diseases: vegetativeDiseases,
              onViewAll: () => navigateToStage('Vegetative Stage', vegetativeDiseases),
            ),
            DiseaseStageSection(
              stageTitle: 'Flowering Stage',
              stageIcon: Icons.local_florist,
              iconColor: Colors.pinkAccent,
              diseases: floweringDiseases,
              onViewAll: () => navigateToStage('Flowering Stage', floweringDiseases),
            ),
            DiseaseStageSection(
              stageTitle: 'Harvesting Stage',
              stageIcon: Icons.content_cut,
              iconColor: Colors.orange,
              diseases: harvestingDiseases,
              onViewAll: () => navigateToStage('Harvesting Stage', harvestingDiseases),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
