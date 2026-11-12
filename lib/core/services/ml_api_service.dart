import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class MlApiService {
  const MlApiService();

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> features,
  ) async {
    final response = await http
        .post(
          Uri.parse('${AppConstants.apiBaseUrl}$path'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'features': features}),
        )
        .timeout(const Duration(seconds: 30));

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(body['detail']?.toString() ?? 'Prediction failed.');
    }
    return body;
  }

  Future<Map<String, dynamic>> predictJasmineYield(
    Map<String, dynamic> features,
  ) => _post('/predict/jasmine-yield', features);

  Future<Map<String, dynamic>> predictSmartIrrigation(
    Map<String, dynamic> features,
  ) => _post('/predict/smart-irrigation', features);

  Future<Map<String, dynamic>> predictSmartIrrigationAmount(
    Map<String, dynamic> features,
  ) => _post('/predict/smart-irrigation-amount', features);

  Future<Map<String, dynamic>> predictMarketInsights(
    Map<String, dynamic> features,
  ) => _post('/predict/market-insights', features);
}
