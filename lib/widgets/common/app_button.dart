import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonType { primary, secondary, text, destructive }

/// A highly customizable, production-grade button widget.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.text;

  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.destructive;

  @override
  Widget build(BuildContext context) {
    if (type == AppButtonType.primary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context, AppColors.white),
      );
    } else if (type == AppButtonType.secondary) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context, AppColors.primaryGreen),
      );
    } else if (type == AppButtonType.destructive) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.white,
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context, AppColors.white),
      );
    } else {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context, AppColors.primaryGreen),
      );
    }
  }

  Widget _buildChild(BuildContext context, Color loadColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(loadColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(label),
      ],
    );
  }
}
