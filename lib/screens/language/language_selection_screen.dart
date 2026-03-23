// Create a Flutter language selection screen using StatefulWidget.
// Use Scaffold and SafeArea.
// Add a title at top: "Select Your Language" using AppTextStyles.displayMedium.
// Create a vertical list of language options:
// English, हिंदी, मराठी, தமிழ், ಕನ್ನಡ, മലയാളം.
//
// Each language item should be a rounded container with padding.
// When selected:
//   - background color = AppColors.primaryGreen
//   - text color = white
//
// When not selected:
//   - background color = light grey
//   - text color = black
//
// Add spacing between items using SizedBox.
//
// Maintain selected index using a state variable.
// On tapping a language, update selected index.
//
// At bottom, add a full-width "Continue" button.
// On pressing Continue, navigate using context.go('/auth/login').
//
// Use Column layout with proper padding.
// Use clean UI matching modern mobile design.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/locale_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'हिंदी', 'code': 'hi'},
    {'name': 'मराठी', 'code': 'mr'},
    {'name': 'தமிழ்', 'code': 'ta'},
    {'name': 'ಕನ್ನಡ', 'code': 'kn'},
    {'name': 'മലയാളം', 'code': 'ml'},
  ];

  late String selectedCode;

  @override
  void initState() {
    super.initState();
    selectedCode = 'en'; // Default
  }

  void _onTap(String code) {
    setState(() {
      selectedCode = code;
    });
  }

  void _onContinue() {
    ref.read(localeProvider.notifier).setLocale(selectedCode);
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Select Your Language',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primaryGreen, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your preferred language to continue',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final bool selected = lang['code'] == selectedCode;
                    return GestureDetector(
                      onTap: () => _onTap(lang['code']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primaryGreen : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? AppColors.primaryGreen : AppColors.primaryGreen.withOpacity(0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang['name']!,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: selected ? Colors.white : AppColors.textPrimary,
                                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                            if (selected)
                              const Icon(Icons.check_circle, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _onContinue,
                  child: Text(
                    'Continue',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

