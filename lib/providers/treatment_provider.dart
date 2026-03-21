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

  TreatmentProvider({TreatmentApiService? apiService}) 
      : _apiService = apiService ?? TreatmentApiService() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _advisoryData = await _apiService.fetchTreatmentAdvisory();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load treatment advisory. Please try again.';
      _advisoryData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshData() {
    _loadInitialData();
  }
}

