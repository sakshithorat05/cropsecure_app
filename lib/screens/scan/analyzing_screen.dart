import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/scan_provider.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen> {
  @override
  void initState() {
    super.initState();
    // Start analysis on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scanProvider.notifier).startAnalysis();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);

    // Listen to success state for navigation
    ref.listen(scanProvider, (previous, next) {
      if (next.step == ScanStep.success) {
        context.go('/home/scan/result');
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            // Top Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 24,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text('Scan Affected Area', style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
            ),
            
            const Spacer(),
            
            Text(
              'Analyzing plant health...',
              style: AppTextStyles.headingLarge,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Custom Spinner Simulation
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentLime),
              strokeWidth: 6,
            ),
            
            const SizedBox(height: 60),
            
            // Steps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildStep('Initializing & Location', scanState.step.index >= ScanStep.analyzingStep2.index && scanState.step != ScanStep.error),
                  const SizedBox(height: 16),
                  _buildStep('Running AI Inference', scanState.step.index >= ScanStep.analyzingStep3.index && scanState.step != ScanStep.error),
                  const SizedBox(height: 16),
                  _buildStep('Generating results', scanState.step.index >= ScanStep.success.index && scanState.step != ScanStep.error),
                ],
              ),
            ),

            if (scanState.step == ScanStep.error) ...[
              const SizedBox(height: 40),
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Analysis failed. Please try again with a clearer photo.',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Go Back', style: AppTextStyles.labelLarge),
              ),
            ],
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String text, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppColors.success : AppColors.textHint,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
