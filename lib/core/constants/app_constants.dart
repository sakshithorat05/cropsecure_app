/// Global application constants.
final class AppConstants {
  AppConstants._();

  /// Android emulator uses 10.0.2.2; desktop/web can override this with
  /// --dart-define=CROPSECURE_API_URL=http://127.0.0.1:8000.
  static const String apiBaseUrl = String.fromEnvironment(
    'CROPSECURE_API_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
  
  /// Camera scan corner overlay size
  static const double scanOverlayCornerSize = 32.0;
  
  /// Standard bottom navigation bar height
  static const double bottomNavHeight = 64.0;
  
  /// Floating scan Action Button size
  static const double scanFabSize = 56.0;
  
  /// Maximum allowed items in the marketplace cart
  static const int maxCartItems = 99;
  
  /// Standard OTP length for authentication
  static const int otpLength = 6;
  
  /// Standard list pagination page size
  static const int paginationPageSize = 20;
}
