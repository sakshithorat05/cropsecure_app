import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Displays a color-coded severity tag (High/Medium/Low)
class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    
    switch (severity.toLowerCase()) {
      case 'high':
        badgeColor = AppColors.riskHigh;
        break;
      case 'medium':
        badgeColor = AppColors.riskMedium;
        break;
      case 'low':
        badgeColor = AppColors.riskLow;
        break;
      default:
        badgeColor = AppColors.textHint;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        severity.toUpperCase(),
        style: AppTextStyles.badgeText,
      ),
    );
  }
}
