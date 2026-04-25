import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../core/services/tflite_service.dart';
import '../core/services/cloudinary_service.dart';
import '../core/services/database_service.dart';
import '../core/services/user_session_service.dart';

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
  final String? imagePath;
  final Position? location;
  final DiagnosisResult? result;
  final bool isSaving;
  final String? uploadedImageUrl;

  const ScanState({
    required this.step,
    this.imagePath,
    this.location,
    this.result,
    this.isSaving = false,
    this.uploadedImageUrl,
  });

  ScanState copyWith({
    ScanStep? step,
    String? imagePath,
    Position? location,
    DiagnosisResult? result,
    bool? isSaving,
    String? uploadedImageUrl,
  }) {
    return ScanState(
      step: step ?? this.step,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      result: result ?? this.result,
      isSaving: isSaving ?? this.isSaving,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
    );
  }
}

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(() {
  return ScanNotifier();
});

class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanState(step: ScanStep.initial);

  final TFLiteService _tfliteService = TFLiteService();
  final CloudinaryService _cloudinary = CloudinaryService();
  final DatabaseService _db = DatabaseService();
  final UserSessionService _session = UserSessionService();

  Future<void> setImage(String path) async {
    state = ScanState(
      step: ScanStep.initial,
      imagePath: path,
    );
  }

  Future<void> startAnalysis() async {
    if (state.imagePath == null) {
      state = state.copyWith(step: ScanStep.error);
      return;
    }

    try {
      // Phase 1: Initialize & Get Location
      state = state.copyWith(step: ScanStep.analyzingStep1);
      
      // Fetch location concurrently with initialization
      Position? currentPosition;
      try {
        currentPosition = await _determinePosition();
      } catch (e) {
        print('--- Location Error: $e ---');
      }

      // Ensure model is ready (already pre-loaded in main.dart but safety check)
      await _tfliteService.loadModel();

      // Phase 2: AI Inference
      print('--- ScanNotifier: Starting AI Inference phase ---');
      state = state.copyWith(step: ScanStep.analyzingStep2, location: currentPosition);
      final inferenceResult = await _tfliteService.runInference(File(state.imagePath!));
      print('--- ScanNotifier: AI Inference finished ---');
      
      // Phase 3: Transition to results
      print('--- ScanNotifier: Transitioning to results ---');
      state = state.copyWith(step: ScanStep.analyzingStep3);
      
      final result = DiagnosisResult(
        diseaseName: inferenceResult['diseaseName'],
        severity: inferenceResult['severity'],
        confidenceScore: inferenceResult['confidenceScore'],
        immediateAction: inferenceResult['immediateAction'],
      );

      // We stop here and show the result to the user.
      // Small artificial delay to ensure the UI feels balanced before jumping to result
      await Future.delayed(const Duration(milliseconds: 800));

      state = state.copyWith(
        step: ScanStep.success,
        result: result,
      );
    } catch (e) {
      print('--- Analysis Error in ScanNotifier: $e ---');
      state = state.copyWith(step: ScanStep.error);
    }
  }

  Future<bool> saveCurrentResult() async {
    if (state.result == null || state.imagePath == null || state.isSaving) return false;

    state = state.copyWith(isSaving: true);
    try {
      _cloudinary.initialize();
      
      // Step 1: Upload to Cloudinary
      final imageUrl = await _cloudinary.uploadImage(File(state.imagePath!));
      
      // Step 2: Save to MongoDB
      final String uid = await _session.getCurrentUserId(); 
      final result = state.result!;
      final currentPosition = state.location;
      
      await _db.addFarmHistoryLog(uid, {
        'type': 'scan',
        'title': 'Crop Scan',
        'subtitle': '${result.diseaseName} detected',
        'imageUrl': imageUrl,
        'metadata': {
          'disease': result.diseaseName,
          'severity': result.severity,
          'confidence': result.confidenceScore,
          'action': result.immediateAction,
          'location': currentPosition != null ? {
            'lat': currentPosition.latitude,
            'lng': currentPosition.longitude,
          } : null,
        }
      });

      state = state.copyWith(isSaving: false, uploadedImageUrl: imageUrl);
      return true;
    } catch (e) {
      print('--- Save Error: $e ---');
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void reset() {
    state = const ScanState(step: ScanStep.initial);
  }
}
