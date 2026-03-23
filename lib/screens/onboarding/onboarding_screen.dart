import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': AppAssets.onboarding1,
      'title': 'Capture with your camera',
      'subtitle': 'Take clear pictures of your crop to get fast diagnosis and advice.',
    },
    {
      'image': AppAssets.onboarding2,
      'title': 'Detect pests & diseases',
      'subtitle': 'Automatic detection highlights affected areas and suggests treatments.',
    },
    {
      'image': AppAssets.onboarding3,
      'title': 'Grow healthier plants',
      'subtitle': 'Get expert-backed recommendations and track recovery over time.',
    },
  ];

  void _onNext() {
    if (currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      context.go('/auth/login');
    }
  }

  void _onSkip() {
    context.go('/auth/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _onSkip,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (idx) => setState(() => currentPage = idx),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Image.asset(
                                page['image']!,
                                fit: BoxFit.contain,
                                height: 280,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback if asset missing or invalid
                                  return Icon(
                                    Icons.image_not_supported,
                                    size: 120,
                                    color: AppColors.primaryGreen,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),

              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: currentPage == index ? 12 : 8,
                    height: currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: currentPage == index ? AppColors.primaryGreen : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _onNext,
                  child: Text(
                    currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
