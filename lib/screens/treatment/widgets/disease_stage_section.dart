import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/disease_details_model.dart';
import 'disease_stage_card.dart';

class DiseaseStageSection extends StatelessWidget {
  final String stageTitle;
  final IconData stageIcon;
  final Color iconColor;
  final List<DiseaseDetailsModel> diseases;
  final VoidCallback onViewAll;

  const DiseaseStageSection({
    super.key,
    required this.stageTitle,
    required this.stageIcon,
    required this.iconColor,
    required this.diseases,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (diseases.isEmpty) {
      return const SizedBox.shrink(); // Hide section if no diseases for this stage
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stage Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(stageIcon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                stageTitle,
                style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: onViewAll,
                child: Text('View All', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        
        // Horizontal List of Cards
        SizedBox(
          height: 180, // Fixed height for horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              final disease = diseases[index];
              return DiseaseStageCard(disease: disease);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
