class TFLiteService {
  Future<void> loadModel() async {}

  Future<Map<String, dynamic>> runInference(String imagePath) {
    throw UnsupportedError(
      'On-device TensorFlow Lite scanning is not available on Chrome. '
      'Use an Android, iOS, Windows, or macOS build for crop scanning.',
    );
  }

  void dispose() {}
}
