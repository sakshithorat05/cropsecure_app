import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/disease_details_model.dart';

class DiseaseStageCard extends StatelessWidget {
  final DiseaseDetailsModel disease;

  const DiseaseStageCard({
    super.key,
    required this.disease,
  });

  @override
  Widget build(BuildContext context) {
    // Attempt to grab the first image if any exist, otherwise empty
    final displayImage = disease.images.isNotEmpty ? disease.images.first : '';

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
            // Navigate passing the REAL data object natively
            context.push('/disease-details', extra: disease);
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
                  child: displayImage.isNotEmpty 
                      ? Image.network(displayImage, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image, color: Colors.grey, size: 40))
                      : const Icon(Icons.image, color: Colors.grey, size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.diseaseType,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      disease.diseaseName,
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
