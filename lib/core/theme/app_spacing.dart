/// Defines the modular spacing scale and corner radius values for CropSecure.
final class AppSpacing {
  AppSpacing._();

  // ---------------------------------------------------------------------------
  // Modular Spacing Scale (8dp base)
  // ---------------------------------------------------------------------------
  /// 4px — icon padding, tight gaps
  static const double xs = 4.0;
  
  /// 8px — internal chip/badge padding
  static const double sm = 8.0;
  
  /// 16px — standard card padding, screen horizontal padding
  static const double md = 16.0;
  
  /// 24px — section spacing
  static const double lg = 24.0;
  
  /// 32px — screen-level padding
  static const double xl = 32.0;
  
  /// 48px — hero section spacing
  static const double xxl = 48.0;

  // ---------------------------------------------------------------------------
  // Corner Radius
  // ---------------------------------------------------------------------------
  /// 6px — chips, badges, tags
  static const double radiusSm = 6.0;
  
  /// 8px — buttons, input fields
  static const double radiusMd = 8.0;
  
  /// 12px — cards
  static const double radiusLg = 12.0;
  
  /// 16px — bottom sheets, modals
  static const double radiusXl = 16.0;
  
  /// 999px — pill buttons, avatar
  static const double radiusFull = 999.0;
}
