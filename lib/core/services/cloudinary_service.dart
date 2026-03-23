import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  late String _cloudName;
  late String _apiKey;
  late String _apiSecret;
  late String _uploadPreset;

  void initialize() {
    _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    _apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
    _apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
    _uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'cropsecure_preset';

    if (_cloudName.isEmpty || _apiKey.isEmpty || _apiSecret.isEmpty) {
      throw Exception('Cloudinary credentials not found in .env file');
    }
  }

  /// Upload image to Cloudinary
  /// Returns the secure URL of uploaded image
  Future<String> uploadImage(File imageFile, {String folder = 'cropsecure'}) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = _uploadPreset;
      request.fields['folder'] = folder;

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = _parseJson(responseData);
        return jsonData['secure_url'] ?? jsonData['url'] ?? '';
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('--- Cloudinary Upload Error: $e ---');
      rethrow;
    }
  }

  // Simple JSON parser without external dependency
  Map<String, dynamic> _parseJson(String jsonString) {
    try {
      // Find secure_url value
      final secureUrlMatch = RegExp(r'"secure_url":"([^"]+)"').firstMatch(jsonString);
      final urlMatch = RegExp(r'"url":"([^"]+)"').firstMatch(jsonString);
      
      return {
        'secure_url': secureUrlMatch?.group(1) ?? '',
        'url': urlMatch?.group(1) ?? '',
      };
    } catch (e) {
      print('JSON Parse Error: $e');
      return {};
    }
  }
}
