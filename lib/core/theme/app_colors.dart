import 'package:flutter/material.dart';

/// Defines the complete color palette for the CropSecure application.
/// Includes primary brand colors, semantic/status colors, neutral palette, 
/// and special app-specific colors.
final class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ---------------------------------------------------------------------------
  // Primary Brand Colors
  // ---------------------------------------------------------------------------
  /// Deep green — buttons, headers, active nav
  static const Color primaryGreen = Color(0xFF2E7D32);
  
  /// Lighter green — hover / active states
  static const Color primaryLight = Color(0xFF4CAF50);
  
  /// Dark green — pressed states
  static const Color primaryDark = Color(0xFF1B5E20);
  
  /// Pale green — card backgrounds, chips
  static const Color primaryContainer = Color(0xFFE8F5E9);
  
  /// Lime — CTA highlights, scan button
  static const Color accentLime = Color(0xFF8BC34A);

  // ---------------------------------------------------------------------------
  // Semantic / Status Colors
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF43A047);
  
  /// Disease risk alert — yellow badge
  static const Color warning = Color(0xFFFFC107);
  
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1E88E5);

  // ---------------------------------------------------------------------------
  // Neutral Palette
  // ---------------------------------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // ---------------------------------------------------------------------------
  // Special App-Specific Colors
  // ---------------------------------------------------------------------------
  /// High disease risk badge
  static const Color riskHigh = Color(0xFFFF5722);
  
  /// Medium severity badge
  static const Color riskMedium = Color(0xFFFFC107);
  
  /// Low severity badge
  static const Color riskLow = Color(0xFF66BB6A);
  
  /// Organic treatment label
  static const Color organicTag = Color(0xFF66BB6A);
  
  /// Chemical treatment label
  static const Color chemicalTag = Color(0xFF42A5F5);
  
  /// Camera scan corner overlay, 50% opacity
  static const Color scanOverlay = Color(0x8000C853);
  
  /// Sale/new badge in marketplace
  static const Color marketplaceBadge = Color(0xFFFF7043);
  
  /// Warm tint for diagnosis result card
  static const Color diagnosisCard = Color(0xFFFFF8E1);
  
  // ---------------------------------------------------------------------------
  // Dark Theme Equivalents (If needed, you can define specific dark mode colors here)
  // For now, using standard colors and adjusting in theme config.
  // ---------------------------------------------------------------------------
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
}
