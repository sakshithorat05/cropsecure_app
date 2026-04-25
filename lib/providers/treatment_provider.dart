import 'package:flutter/material.dart';
import '../../core/services/treatment_api_service.dart';
import '../screens/treatment/models/treatment_advisory_model.dart';

class TreatmentProvider with ChangeNotifier {
  final TreatmentApiService _apiService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TreatmentAdvisoryData? _advisoryData;
  TreatmentAdvisoryData? get advisoryData => _advisoryData;

  TreatmentProvider({TreatmentApiService? apiService, String? cropName}) 
      : _apiService = apiService ?? TreatmentApiService() {
    _loadInitialData(cropName);
  }

  Future<void> _loadInitialData(String? cropName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('Fetching treatment advisory for crop: $cropName');
      _advisoryData = await _apiService.fetchTreatmentAdvisory(cropName: cropName);
      _errorMessage = null;
    } catch (e) {
      debugPrint('Error loading advisory: $e');
      final errorText = e.toString();
      if (errorText.contains('No diseases found in database')) {
        _advisoryData = null;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load treatment advisory: $e';
        _advisoryData = null;
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

