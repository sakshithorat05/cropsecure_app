import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScanStep {
  initial,
  capturing,
  analyzingStep1,
  analyzingStep2,
  analyzingStep3,
  success,
  error
}

class DiagnosisResult {
  final String diseaseName;
  final String severity; 
  final double confidenceScore;
  final String immediateAction;

  const DiagnosisResult({
    required this.diseaseName,
    required this.severity,
    required this.confidenceScore,
    required this.immediateAction,
  });
}

class ScanState {
  final ScanStep step;
  final DiagnosisResult? result;

  const ScanState({
    required this.step,
    this.result,
  });

  ScanState copyWith({ScanStep? step, DiagnosisResult? result}) {
    return ScanState(
      step: step ?? this.step,
      result: result ?? this.result,
    );
  }
}

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(() {
  return ScanNotifier();
});

class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanState(step: ScanStep.initial);

  Future<void> startAnalysis() async {
    state = state.copyWith(step: ScanStep.analyzingStep1);
    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(step: ScanStep.analyzingStep2);
    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(step: ScanStep.analyzingStep3);
    await Future.delayed(const Duration(seconds: 1));
    
    state = state.copyWith(
      step: ScanStep.success,
      result: const DiagnosisResult(
        diseaseName: 'Late Blight',
        severity: 'High',
        confidenceScore: 94.5,
        immediateAction: 'Apply fungicide immediately to prevent spread.',
      ),
    );
  }

  void reset() {
    state = const ScanState(step: ScanStep.initial);
  }
}
