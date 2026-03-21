import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'disease_stage_card.dart';

class DiseaseStageSection extends StatelessWidget {
  final String stageTitle;
  final IconData stageIcon;
  final Color iconColor;
  final List<Map<String, String>> diseases;
  final VoidCallback onViewAll;

  const DiseaseStageSection({
    super.key,
    required this.stageTitle,
    required this.stageIcon,
    this.iconColor = AppColors.primaryGreen,
    required this.diseases,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(stageIcon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                stageTitle,
                style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.info, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Horizontal List
        SizedBox(
          height: 190, // Height to fit card + shadow + paddings
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              final disease = diseases[index];
              return DiseaseStageCard(
                imageUrl: disease['imageUrl'] ?? '',
                pestType: disease['pestType'] ?? '',
                diseaseName: disease['diseaseName'] ?? '',
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
