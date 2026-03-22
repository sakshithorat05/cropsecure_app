import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

enum VoiceState { idle, listening, result }

final voiceStateProvider = NotifierProvider<VoiceStateNotifier, VoiceState>(() => VoiceStateNotifier());
class VoiceStateNotifier extends Notifier<VoiceState> {
  @override
  VoiceState build() => VoiceState.idle;
  void updateState(VoiceState v) => state = v;
}

final recognizedTextProvider = NotifierProvider<RecognizedTextNotifier, String>(() => RecognizedTextNotifier());
class RecognizedTextNotifier extends Notifier<String> {
  @override
  String build() => '';
  void updateState(String t) => state = t;
}

class VoiceSearchOverlay extends ConsumerStatefulWidget {
  const VoiceSearchOverlay({super.key});

  @override
  ConsumerState<VoiceSearchOverlay> createState() => _VoiceSearchOverlayState();
}

class _VoiceSearchOverlayState extends ConsumerState<VoiceSearchOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  late Animation<double> _scaleAnimation3;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _scaleAnimation1 = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _scaleAnimation2 = Tween<double>(begin: 0.9, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _scaleAnimation3 = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() {
    ref.read(voiceStateProvider.notifier).updateState(VoiceState.listening);
    _pulseController.repeat(reverse: true);
    
    // Simulate listening
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _pulseController.stop();
      ref.read(recognizedTextProvider.notifier).updateState('Blue Copper Fungicide');
      ref.read(voiceStateProvider.notifier).updateState(VoiceState.result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceStateProvider);
    final text = ref.watch(recognizedTextProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Text(AppStrings.voiceSearchTitle, style: AppTextStyles.headingMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(AppStrings.voiceSearchInstruction, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxl),
          
          // Animated Mic Area
          Expanded(
            child: Center(
              child: AnimatedSwitcher( // Smooth transition between states
                duration: const Duration(milliseconds: 300),
                child: state == VoiceState.idle 
                  ? _buildIdleState() 
                  : state == VoiceState.listening 
                      ? _buildListeningState() 
                      : _buildResultState(text),
              )
            ),
          ),
          
          SizedBox(height: AppSpacing.xl + bottomPadding),
        ],
      ),
    );
  }

  Widget _buildIdleState() {
    return Column(
      key: const ValueKey('idle'),
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _startListening,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 2),
            ),
            child: const Icon(Icons.mic_none, size: 40, color: AppColors.primaryGreen),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.tapToSpeak, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildListeningState() {
    return Column(
      key: const ValueKey('listening'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation3,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              ScaleTransition(
                scale: _scaleAnimation2,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              ScaleTransition(
                scale: _scaleAnimation1,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic, size: 36, color: AppColors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.listeningLabel, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryGreen)),
      ],
    );
  }

  Widget _buildResultState(String text) {
    return Padding(
      key: const ValueKey('result'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Text(text, style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(voiceStateProvider.notifier).updateState(VoiceState.idle);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryGreen),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  child: Text(AppStrings.tryAgain, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGreen)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/market/search'); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  child: Text(AppStrings.search, style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
