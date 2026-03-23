import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  Interpreter? _interpreter;
  List<String>? _labels;

  // Common labels fallback (PlantVillage style)
  static const List<String> _fallbackLabels38 = [
    'Apple Scab', 'Apple Black Rot', 'Apple Cedar Rust', 'Apple Healthy',
    'Blueberry Healthy',
    'Cherry Powdery Mildew', 'Cherry Healthy',
    'Corn Gray Leaf Spot', 'Corn Common Rust', 'Corn Northern Leaf Blight', 'Corn Healthy',
    'Grape Black Rot', 'Grape Esca', 'Grape Leaf Blight', 'Grape Healthy',
    'Orange Haunglongbing',
    'Peach Bacterial Spot', 'Peach Healthy',
    'Pepper Bell Bacterial Spot', 'Pepper Bell Healthy',
    'Potato Early Blight', 'Potato Late Blight', 'Potato Healthy',
    'Raspberry Healthy',
    'Soybean Healthy',
    'Squash Powdery Mildew',
    'Strawberry Leaf Scorch', 'Strawberry Healthy',
    'Tomato Bacterial Spot', 'Tomato Early Blight', 'Tomato Late Blight', 
    'Tomato Leaf Mold', 'Tomato Septoria Leaf Spot', 'Tomato Spider Mites', 
    'Tomato Target Spot', 'Tomato Yellow Leaf Curl Virus', 'Tomato Mosaic Virus', 'Tomato Healthy'
  ];

  static const List<String> _labels9 = [
    'Anthracnose', 'Chlorosis', 'Dried Leaf', 'Healthy', 'Initial Stage', 
    'Leaf Blight', 'Leaf Spot', 'Pest Damage', 'Rust Diseases'
  ];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      
      // Detect output shape dynamically
      final outputShape = _interpreter!.getOutputTensors().first.shape;
      final numClasses = outputShape[1];
      
      if (numClasses == 9) {
        _labels = _labels9;
      } else if (numClasses == 38) {
        _labels = _fallbackLabels38;
      } else {
        _labels = List.generate(numClasses, (index) => 'Class $index');
      }
      
      print('--- TFLite Model Loaded Successfully (Classes: $numClasses) ---');
    } catch (e) {
      print('--- Error Loading TFLite Model: $e ---');
    }
  }

  Future<Map<String, dynamic>> runInference(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }

    if (_interpreter == null) {
      throw Exception('Failed to initialize TFLite interpreter');
    }

    // 1. Preprocess image
    final imageBytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception('Could not decode image');

    // Model expects 224x224 (common for MobileNet/EfficientNet)
    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    
    // Convert to Float32 list and normalize
    var input = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;
    
    for (var pixel in resizedImage) {
      input[pixelIndex++] = (pixel.r - 127.5) / 127.5;
      input[pixelIndex++] = (pixel.g - 127.5) / 127.5;
      input[pixelIndex++] = (pixel.b - 127.5) / 127.5;
    }

    // 2. Prepare output buffer
    // Output shape is usually [1, num_classes]
    final output = List.filled(1 * _labels!.length, 0.0).reshape([1, _labels!.length]);

    // 3. Run inference
    _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

    // 4. Process output
    List<double> scores = List<double>.from(output[0]);
    double maxScore = -1.0;
    int maxIndex = -1;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        maxIndex = i;
      }
    }

    if (maxIndex != -1) {
      String disease = _labels![maxIndex];
      double confidence = maxScore * 100;

      // Determine severity based on confidence and disease (naive approach)
      String severity = confidence > 80 ? 'High' : (confidence > 50 ? 'Medium' : 'Low');

      return {
        'diseaseName': disease,
        'confidenceScore': confidence,
        'severity': severity,
        'immediateAction': _getImmediateAction(disease),
      };
    }

    throw Exception('Inference failed to produce a result');
  }

  String _getImmediateAction(String disease) {
    if (disease.contains('Healthy')) return 'Monitor crop regularly for any changes.';
    if (disease.contains('Late Blight')) return 'Apply fungicide immediately to prevent spread.';
    if (disease.contains('Bacterial Spot')) return 'Remove infected leaves and avoid overhead watering.';
    return 'Consult an agricultural expert for specific treatment.';
  }

  void dispose() {
    _interpreter?.close();
  }
}
