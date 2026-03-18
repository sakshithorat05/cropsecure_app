import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_button.dart';

/// A generic empty state implementation.
class EmptyStateWidget extends StatelessWidget {
  final String imageAsset;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;

  const EmptyStateWidget({
    super.key,
    required this.imageAsset,
    required this.message,
    this.ctaLabel,
    this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imageAsset,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.inbox_rounded,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
          if (ctaLabel != null && onCtaPressed != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: ctaLabel!,
              onPressed: onCtaPressed,
            ),
          ],
        ],
      ),
    );
  }
}
