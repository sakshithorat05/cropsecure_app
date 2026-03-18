import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/scan_provider.dart';
import '../../core/constants/app_strings.dart';

/// Animated step-by-step checklist matching the analyze state.
class AnalyzingLoader extends StatelessWidget {
  final ScanStep currentStep;

  const AnalyzingLoader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
               width: 60,
               height: 60,
               child: CircularProgressIndicator(
                 color: AppColors.primaryGreen,
                 strokeWidth: 4,
               ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          _buildStepRow(
            AppStrings.scanAnalyzingStep1, 
            status: _getStepStatus(ScanStep.analyzingStep1)
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildStepRow(
            AppStrings.scanAnalyzingStep2, 
            status: _getStepStatus(ScanStep.analyzingStep2)
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildStepRow(
            AppStrings.scanAnalyzingStep3, 
            status: _getStepStatus(ScanStep.analyzingStep3)
          ),
        ],
      ),
    );
  }

  /// Evaluates whether the step is done, active or pending
  String _getStepStatus(ScanStep stepForThisRow) {
    if (currentStep == ScanStep.success) return 'done';
    
    // Quick integer based comparison since Dart enums don't have built in > <
    if (currentStep.index > stepForThisRow.index) return 'done';
    if (currentStep.index == stepForThisRow.index) return 'active';
    return 'pending';
  }

  Widget _buildStepRow(String text, {required String status}) {
    IconData icon;
    Color color;

    if (status == 'done') {
      icon = Icons.check_circle;
      color = AppColors.success;
    } else if (status == 'active') {
      icon = Icons.radio_button_checked;
      color = AppColors.primaryGreen;
    } else {
      icon = Icons.radio_button_unchecked;
      color = AppColors.textHint;
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: AppSpacing.md),
        Text(
          text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: status == 'pending' ? AppColors.textHint : AppColors.textPrimary,
            fontWeight: status == 'active' ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
