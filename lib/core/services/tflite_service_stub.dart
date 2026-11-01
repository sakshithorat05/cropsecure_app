class TFLiteService {
  Future<void> loadModel() async {}

  Future<Map<String, dynamic>> runInference(String imagePath) {
    throw UnsupportedError(
      'On-device TensorFlow Lite scanning is not available in this build.',
    );
  }

  void dispose() {}
}
