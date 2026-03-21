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
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<String> _languages = [
    'English',
    'हिंदी',
    'मराठी',
    'தமிழ்',
    'ಕನ್ನಡ',
    'മലയാളം',
  ];

  int selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onContinue() {
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Your Language',
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final bool selected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () => _onTap(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primaryGreen : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _languages[index],
                          style: selected
                              ? AppTextStyles.bodyLarge.copyWith(color: AppColors.white)
                              : AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

