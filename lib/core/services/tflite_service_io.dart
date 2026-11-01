import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  Interpreter? _interpreter;
  List<String>? _labels;

  static const List<String> _fallbackLabels38 = [
    'Apple Scab',
    'Apple Black Rot',
    'Apple Cedar Rust',
    'Apple Healthy',
    'Blueberry Healthy',
    'Cherry Powdery Mildew',
    'Cherry Healthy',
    'Corn Gray Leaf Spot',
    'Corn Common Rust',
    'Corn Northern Leaf Blight',
    'Corn Healthy',
    'Grape Black Rot',
    'Grape Esca',
    'Grape Leaf Blight',
    'Grape Healthy',
    'Orange Haunglongbing',
    'Peach Bacterial Spot',
    'Peach Healthy',
    'Pepper Bell Bacterial Spot',
    'Pepper Bell Healthy',
    'Potato Early Blight',
    'Potato Late Blight',
    'Potato Healthy',
    'Raspberry Healthy',
    'Soybean Healthy',
    'Squash Powdery Mildew',
    'Strawberry Leaf Scorch',
    'Strawberry Healthy',
    'Tomato Bacterial Spot',
    'Tomato Early Blight',
    'Tomato Late Blight',
    'Tomato Leaf Mold',
    'Tomato Septoria Leaf Spot',
    'Tomato Spider Mites',
    'Tomato Target Spot',
    'Tomato Yellow Leaf Curl Virus',
    'Tomato Mosaic Virus',
    'Tomato Healthy',
  ];

  static const List<String> _labels9 = [
    'Anthracnose',
    'Chlorosis',
    'Dried leaf',
    'Healthy',
    'Initial stage',
    'Leaf blight',
    'Leaf spot',
    'Pest damage',
    'Rust diseases',
  ];

  static const List<String> _labels10 = [
    'Alternaria leaf blight',
    'Anthracnose',
    'Chlorosis',
    'Dried leaf',
    'Healthy',
    'Initial stage',
    'Leaf blight',
    'Leaf spot',
    'Pest damage',
    'Rust diseases',
  ];

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    final numClasses = _interpreter!.getOutputTensors().first.shape[1];
    _labels = switch (numClasses) {
      10 => _labels10,
      9 => _labels9,
      38 => _fallbackLabels38,
      _ => List.generate(numClasses, (index) => 'Class $index'),
    };
  }

  Future<Map<String, dynamic>> runInference(String imagePath) async {
    if (_interpreter == null) await loadModel();
    final imageBytes = await File(imagePath).readAsBytes();
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception('Could not decode image');
    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    final input = Float32List(1 * 224 * 224 * 3);
    var pixelIndex = 0;
    for (final pixel in resizedImage) {
      input[pixelIndex++] = (pixel.r - 127.5) / 127.5;
      input[pixelIndex++] = (pixel.g - 127.5) / 127.5;
      input[pixelIndex++] = (pixel.b - 127.5) / 127.5;
    }

    final output = List.filled(
      1 * _labels!.length,
      0.0,
    ).reshape([1, _labels!.length]);
    _interpreter!.run(input.reshape([1, 224, 224, 3]), output);
    final scores = List<double>.from(output[0]);
    var maxIndex = 0;
    for (var index = 1; index < scores.length; index++) {
      if (scores[index] > scores[maxIndex]) maxIndex = index;
    }
    final disease = _labels![maxIndex];
    final confidence = scores[maxIndex] * 100;
    return {
      'diseaseName': disease,
      'confidenceScore': confidence,
      'severity': _getSeverity(disease, confidence),
      'immediateAction': _getImmediateAction(disease),
    };
  }

  String _getSeverity(String disease, double confidence) {
    final value = disease.toLowerCase();
    if (value.contains('healthy')) return 'None';
    if (value.contains('dried') || value.contains('blight')) return 'High';
    if (confidence < 40) return 'Low';
    return 'Medium';
  }

  String _getImmediateAction(String disease) {
    final value = disease.toLowerCase();
    if (value.contains('healthy'))
      return 'Keep monitoring your crops regularly.';
    if (value.contains('blight'))
      return 'Apply recommended fungicide and remove highly infected leaves.';
    if (value.contains('spot'))
      return 'Improve air circulation and avoid overhead watering.';
    if (value.contains('rust'))
      return 'Apply sulfur or copper-based fungicides.';
    if (value.contains('pest'))
      return 'Identify the pest and apply organic neem oil or suitable pesticide.';
    return 'Consult your nearest agricultural extension officer for detailed advice.';
  }

  void dispose() => _interpreter?.close();
}
