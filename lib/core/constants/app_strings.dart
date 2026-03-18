/// Centralized interface for user-facing UI string constants.
/// Intended to be replaced by generated localization classes (e.g., AppLocalizations) 
/// via `flutter_localizations` in production.
/// Currently holds English default strings to avoid hardcoding in UI.
final class AppStrings {
  AppStrings._();

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------
  static const String appName = 'CropSecure';
  static const String tagline = 'AI-Powered Detection & Advisory';
  static const String languageScreenTitle = 'Select Language';

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  static const String loginTitle = 'Login to your account';
  static const String signUpTitle = 'Create new account';
  static const String otpLabel = 'Enter OTP';
  static const String phoneValidationEmpty = 'Please enter your phone number';
  static const String phoneValidationInvalid = 'Please enter a valid phone number';
  static const String otpValidationEmpty = 'Please enter the OTP';

  // ---------------------------------------------------------------------------
  // Dashboard
  // ---------------------------------------------------------------------------
  static const String welcomeGreeting = 'Hello, Farmer!';
  static const String riskAlertHigh = 'High risk of Leaf Blight detected nearby';
  static const String quickActionScan = 'Scan Crop';
  static const String myCropHeader = 'My Crops';

  // ---------------------------------------------------------------------------
  // Scan
  // ---------------------------------------------------------------------------
  static const String scanInstruction = 'Align the diseased leaf within the frame';
  static const String scanAnalyzingStep1 = 'Checking disease patterns...';
  static const String scanAnalyzingStep2 = 'Matching with AI models...';
  static const String scanAnalyzingStep3 = 'Estimating severity...';
  static const String diagnosisResultTitle = 'Diagnosis Result';

  // ---------------------------------------------------------------------------
  // Treatment
  // ---------------------------------------------------------------------------
  static const String dosageLabel = 'Recommended Dosage';
  static const String stepHeadings = 'Application Steps';
  static const String farmerTipsLabel = 'Farmer Tip';
  static const String treatmentAdvisory = 'Treatment Advisory';

  // ---------------------------------------------------------------------------
  // Marketplace
  // ---------------------------------------------------------------------------
  static const String searchPlaceholder = 'Search products...';
  static const String cartTitle = 'Your Cart';
  static const String currencyFormatting = '₹';

  // ---------------------------------------------------------------------------
  // Common
  // ---------------------------------------------------------------------------
  static const String btnContinue = 'Continue';
  static const String btnNext = 'Next';
  static const String btnBack = 'Back';
  static const String btnViewAll = 'View All';
  static const String loading = 'Loading...';
  static const String btnRetry = 'Retry';
  static const String errorGeneric = 'Something went wrong. Please try again.';
}
