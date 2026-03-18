import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Defines the typography scale for CropSecure using the Poppins font family.
final class AppTextStyles {
  AppTextStyles._();

  static final String _fontFamily = GoogleFonts.poppins().fontFamily ?? 'sans-serif';

  // ---------------------------------------------------------------------------
  // Display Styles
  // ---------------------------------------------------------------------------
  /// 28sp, w600, height 1.2 — welcome/splash headings
  static final TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// 24sp, w600, height 1.3 — screen titles
  static final TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ---------------------------------------------------------------------------
  // Heading Styles
  // ---------------------------------------------------------------------------
  /// 20sp, w600 — card section headings
  static final TextStyle headingLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// 18sp, w500 — sub-section headings
  static final TextStyle headingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// 16sp, w500 — list item titles
  static final TextStyle headingSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ---------------------------------------------------------------------------
  // Body Styles
  // ---------------------------------------------------------------------------
  /// 16sp, w400 — general body text
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// 14sp, w400 — descriptions, labels
  static final TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// 12sp, w400, textSecondary — captions, helper text
  static final TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ---------------------------------------------------------------------------
  // Label / Button Styles
  // ---------------------------------------------------------------------------
  /// 14sp, w500, white — filled button labels
  static final TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  /// 12sp, w500 — outlined button labels, chips
  static final TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// 10sp, w400, textSecondary — nav bar labels
  static final TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ---------------------------------------------------------------------------
  // Custom Specialized Styles
  // ---------------------------------------------------------------------------
  /// 14sp, w600, primary, letterSpacing 0.5 — specific section titles
  static final TextStyle sectionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.primaryGreen,
  );

  /// 10sp, w600, white — status badges
  static final TextStyle badgeText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// 18sp, w600, white — App Bar titles
  static final TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// 22sp, w700, primary — dosage amount callout
  static final TextStyle dosageHighlight = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryGreen,
  );

  /// 10sp, w500, textSecondary — inactive nav label
  static final TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// 10sp, w500, primary — active nav label
  static final TextStyle navLabelActive = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryGreen,
  );
}
