import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../models/disease_details_model.dart';

class DiseaseCard extends StatelessWidget {
  final DiseaseDetailsModel diseaseData;

  const DiseaseCard({
    super.key,
    required this.diseaseData,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGreen, // Strictly dark green
          borderRadius: BorderRadius.circular(16), // 16+ as requested
          boxShadow: [AppColors.softShadow], // Soft shadow overlay
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/disease-details', extra: diseaseData);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Disease Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Understanding ${diseaseData.diseaseName}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(204),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const AnimatedRotation(
                  turns: 0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
