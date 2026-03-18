import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_card.dart';
import 'app_button.dart';
import 'severity_badge.dart';

/// Full result card with disease name, severity, confidence score, and CTA
class DiagnosisResultCard extends StatelessWidget {
  final String diseaseName;
  final String severity;
  final double confidenceScore;
  final String immediateAction;
  final VoidCallback onTreatmentTap;

  const DiagnosisResultCard({
    super.key,
    required this.diseaseName,
    required this.severity,
    required this.confidenceScore,
    required this.immediateAction,
    required this.onTreatmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.diagnosisCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Conf. $confidenceScore%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SeverityBadge(severity: severity),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            diseaseName,
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    immediateAction,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
             label: 'View Treatment Advisory',
             icon: Icons.medical_services_outlined,
             onPressed: onTreatmentTap,
          ),
        ],
      ),
    );
  }
}
