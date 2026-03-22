import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

class StockBadge extends StatelessWidget {
  final bool inStock;
  
  const StockBadge({
    super.key,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm, 
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: inStock ? AppColors.success.withAlpha(26) : AppColors.error.withAlpha(26),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: inStock ? AppColors.success : AppColors.error,
          width: 0.5,
        ),
      ),
      child: Text(
        inStock ? AppStrings.inStock : AppStrings.outOfStock,
        style: AppTextStyles.badgeText.copyWith(
          color: inStock ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}
