import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// A circular avatar widget with fallback initials.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackInitial;
  final double radius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackInitial,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryContainer,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : null,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              fallbackInitial.toUpperCase(),
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryGreen,
              ),
            )
          : null,
    );
  }
}
