import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class CartStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withAlpha(220),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: onDecrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.remove, size: 14, color: AppColors.white),
            ),
          ),
          Container(width: 1, height: 16, color: AppColors.white.withAlpha(128)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              quantity.toString(),
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
            ),
          ),
          Container(width: 1, height: 16, color: AppColors.white.withAlpha(128)),
          InkWell(
            onTap: onIncrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.add, size: 14, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
