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
  static const String marketplaceTitle        = 'Marketplace';
  static const String searchPlaceholder       = 'Search fungicides, fertilisers...';
  static const String tabFungicide            = 'Fungicide';
  static const String tabFertiliser           = 'Fertiliser';
  static const String tabPesticide            = 'Pesticide';
  static const String addToCart               = 'Add to Cart';
  static const String noSearchResults         = 'No products found';
  static const String noSearchResultsSubtitle = 'Try a different name or category';
  static const String recentSearches          = 'Recent Searches';
  static const String popularProducts         = 'Popular Products';
  static const String clearAll                = 'Clear';
  static const String cancel                  = 'Cancel';
  static const String search                  = 'Search';
  static const String tryAgain                = 'Try Again';
  
  static const String cartTitle = 'Your Cart';
  static const String currencyFormatting = '₹';

  // Voice search
  static const String voiceSearchTitle        = 'Search by voice';
  static const String voiceSearchInstruction  = 'Say the product name or disease';
  static const String tapToSpeak              = 'Tap to speak';
  static const String listeningLabel          = 'Listening...';

  // Product detail
  static const String alsoKnownAs            = 'Also known as:';
  static const String targetDiseases         = 'Target Diseases';
  static const String dosageCalculatorTitle  = 'Dosage Calculator';
  static const String enterAreaLabel         = 'Enter your farm area';
  static const String calculate              = 'Calculate';
  static const String safetyInstructions     = 'Safety Instructions';
  static const String completeYourCare       = 'Complete your care for ';
  static const String inStock                = 'In Stock';
  static const String outOfStock             = 'Out of Stock';

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
