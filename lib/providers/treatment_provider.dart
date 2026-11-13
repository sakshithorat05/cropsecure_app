import 'package:flutter/material.dart';
import '../../core/services/treatment_api_service.dart';
import '../screens/treatment/models/treatment_advisory_model.dart';

class TreatmentProvider with ChangeNotifier {
  final TreatmentApiService _apiService;
  static final Map<String, TreatmentAdvisoryData> _cache = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TreatmentAdvisoryData? _advisoryData;
  TreatmentAdvisoryData? get advisoryData => _advisoryData;

  TreatmentProvider({TreatmentApiService? apiService, String? cropName}) 
      : _apiService = apiService ?? TreatmentApiService() {
    final cacheKey = cropName?.trim().toLowerCase() ?? 'default';
    if (_cache.containsKey(cacheKey)) {
      _advisoryData = _cache[cacheKey];
      _isLoading = false;
    }
    _loadInitialData(cropName);
  }

  Future<void> _loadInitialData(String? cropName) async {
    final cacheKey = cropName?.trim().toLowerCase() ?? 'default';
    if (_advisoryData == null) {
      _isLoading = true;
      notifyListeners();
    }
    _errorMessage = null;

    try {
      debugPrint('Fetching treatment advisory for crop: $cropName');
      final data = await _apiService.fetchTreatmentAdvisory(cropName: cropName);
      _advisoryData = data;
      _cache[cacheKey] = data;
      _errorMessage = null;
    } catch (e) {
      debugPrint('Error loading advisory: $e');
      final errorText = e.toString();
      if (errorText.contains('No diseases found in database')) {
        _advisoryData = null;
        _errorMessage = null;
      } else {
        if (_cache.containsKey(cacheKey)) {
          _advisoryData = _cache[cacheKey];
          _errorMessage = null;
        } else {
          _errorMessage = 'Failed to load treatment advisory: $e';
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshData({String? cropName}) {
    _loadInitialData(cropName);
  }
}

