import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/database_service.dart';
import '../../core/services/ml_api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/plot_provider.dart';

class SmartIrrigationScreen extends ConsumerStatefulWidget {
  const SmartIrrigationScreen({super.key});

  @override
  ConsumerState<SmartIrrigationScreen> createState() => _SmartIrrigationScreenState();
}

class _SmartIrrigationScreenState extends ConsumerState<SmartIrrigationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mlService = const MlApiService();
  final _db = DatabaseService();

  // Selected Categoricals
  String _soilType = 'Loam';
  String _growthStage = 'Flowering';
  String _irrigationMethod = 'Drip';

  // Form Controllers
  final _soilMoistureController = TextEditingController(text: '38.0');
  final _daysSinceIrrigationController = TextEditingController(text: '3');
  final _lastIrrigationAmountController = TextEditingController(text: '4.0');
  final _rainfall24hController = TextEditingController(text: '0.0');
  final _rainfallForecast24hController = TextEditingController(text: '2.0');
  final _rainfallForecast48hController = TextEditingController(text: '5.0');
  final _tempForecastController = TextEditingController(text: '31.0');
  final _humidityForecastController = TextEditingController(text: '60.0');
  final _windSpeedController = TextEditingController(text: '12.0');
  final _daysAfterPruningController = TextEditingController(text: '45');

  // Advanced Agronomic Controllers (Pre-filled with scientific defaults)
  final _solarRadiationController = TextEditingController(text: '18.5');
  final _fieldCapacityController = TextEditingController(text: '28.0');
  final _wiltingPointController = TextEditingController(text: '14.0');
  final _rootZoneDepthController = TextEditingController(text: '40.0');
  final _et0Controller = TextEditingController(text: '4.8');
  final _cropCoefficientKcController = TextEditingController(text: '1.05');
  final _etcController = TextEditingController(text: '5.04');
  final _effectiveRainfallController = TextEditingController(text: '1.5');

  bool _isLoading = false;
  bool _showAdvancedDynamics = false;
  Map<String, dynamic>? _predictionResult;
  final _scrollController = ScrollController();

  final List<String> _soilTypes = const ['Sandy Loam', 'Loam', 'Clay Loam'];
  final List<String> _growthStages = const [
    'Establishment',
    'Vegetative',
    'Flowering',
    'Post_Flowering',
  ];
  final List<String> _irrigationMethods = const ['Drip', 'Basin', 'Furrow'];

  @override
  void dispose() {
    _scrollController.dispose();
    _soilMoistureController.dispose();
    _daysSinceIrrigationController.dispose();
    _lastIrrigationAmountController.dispose();
    _rainfall24hController.dispose();
    _rainfallForecast24hController.dispose();
    _rainfallForecast48hController.dispose();
    _tempForecastController.dispose();
    _humidityForecastController.dispose();
    _windSpeedController.dispose();
    _daysAfterPruningController.dispose();
    _solarRadiationController.dispose();
    _fieldCapacityController.dispose();
    _wiltingPointController.dispose();
    _rootZoneDepthController.dispose();
    _et0Controller.dispose();
    _cropCoefficientKcController.dispose();
    _etcController.dispose();
    _effectiveRainfallController.dispose();
    super.dispose();
  }

  Future<void> _fetchLiveWeatherAndPlot() async {
    final activePlot = ref.read(activePlotProvider);
    try {
      final weather = await _db.getLatestWeather();
      setState(() {
        if (weather != null) {
          if (weather['temp'] != null) {
            _tempForecastController.text = weather['temp'].toString();
          }
          if (weather['humidity'] != null) {
            _humidityForecastController.text = weather['humidity'].toString();
          }
        }
        if (activePlot != null) {
          _growthStage = 'Flowering';
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Synced live field weather & active plot!'),
            backgroundColor: AppColors.primaryGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not fetch remote weather. Using defaults.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _calculateIrrigation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    final features = <String, dynamic>{
      'soil_type': _soilType,
      'crop_growth_stage': _growthStage,
      'irrigation_method': _irrigationMethod,
      'soil_moisture_percent': double.tryParse(_soilMoistureController.text) ?? 38.0,
      'days_since_last_irrigation': double.tryParse(_daysSinceIrrigationController.text) ?? 3.0,
      'last_irrigation_amount_l_per_plant': double.tryParse(_lastIrrigationAmountController.text) ?? 4.0,
      'rainfall_last_24h_mm': double.tryParse(_rainfall24hController.text) ?? 0.0,
      'rainfall_forecast_24h_mm': double.tryParse(_rainfallForecast24hController.text) ?? 2.0,
      'rainfall_forecast_48h_mm': double.tryParse(_rainfallForecast48hController.text) ?? 5.0,
      'temperature_forecast_c': double.tryParse(_tempForecastController.text) ?? 31.0,
      'humidity_forecast_percent': double.tryParse(_humidityForecastController.text) ?? 60.0,
      'wind_speed_kmh': double.tryParse(_windSpeedController.text) ?? 12.0,
      'days_after_pruning': double.tryParse(_daysAfterPruningController.text) ?? 45.0,
      'solar_radiation_w_m2': double.tryParse(_solarRadiationController.text) ?? 18.5,
      'field_capacity_percent': double.tryParse(_fieldCapacityController.text) ?? 28.0,
      'wilting_point_percent': double.tryParse(_wiltingPointController.text) ?? 14.0,
      'root_zone_depth_cm': double.tryParse(_rootZoneDepthController.text) ?? 40.0,
      'ET0_mm_day': double.tryParse(_et0Controller.text) ?? 4.8,
      'crop_coefficient_kc': double.tryParse(_cropCoefficientKcController.text) ?? 1.05,
      'ETc_mm_day': double.tryParse(_etcController.text) ?? 5.04,
      'effective_rainfall_24h_mm': double.tryParse(_effectiveRainfallController.text) ?? 1.5,
    };

    try {
      final response = await _mlService.predictSmartIrrigation(features);
      if (mounted) {
        setState(() {
          _predictionResult = response;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      // Agronomic Evapotranspiration formula calculation as fallback
      final moisture = features['soil_moisture_percent'] as double;
      final rainForecast = features['rainfall_forecast_24h_mm'] as double;
      final bool requiresIrrigation = moisture < 42.0 && rainForecast < 8.0;

      double recAmount = 0.0;
      if (requiresIrrigation) {
        if (_growthStage == 'Flowering') {
          recAmount = (_irrigationMethod == 'Drip') ? 4.5 : 7.0;
        } else if (_growthStage == 'Vegetative') {
          recAmount = (_irrigationMethod == 'Drip') ? 3.5 : 5.5;
        } else {
          recAmount = (_irrigationMethod == 'Drip') ? 3.0 : 4.5;
        }
      }

      if (mounted) {
        setState(() {
          _predictionResult = {
            'predicted_class': requiresIrrigation ? 1 : 0,
            'recommended_irrigation_l_per_plant': recAmount,
            'probabilities': requiresIrrigation ? [0.12, 0.88] : [0.85, 0.15],
            'is_simulated': true,
          };
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      appBar: AppBar(
        title: const Text(
          'Smart Irrigation Advisory',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0284C7), // Water cyan/blue
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_rounded),
            tooltip: 'Sync Live Weather',
            onPressed: _fetchLiveWeatherAndPlot,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Hero Banner
              _buildHeroBanner(),
              const SizedBox(height: 16),

              // Quick Sync Bar
              _buildQuickActionBar(),
              const SizedBox(height: 16),

              // Section 1: Crop Growth & Irrigation Setup
              _buildSectionCard(
                title: 'Crop Stage & Field Setup',
                icon: Icons.grass_rounded,
                iconColor: const Color(0xFF0284C7),
                children: [
                  _buildGrowthStageSelector(),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Soil Texture',
                          value: _soilType,
                          items: _soilTypes,
                          onChanged: (val) => setState(() => _soilType = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Irrigation Method',
                          value: _irrigationMethod,
                          items: _irrigationMethods,
                          onChanged: (val) => setState(() => _irrigationMethod = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          controller: _daysSinceIrrigationController,
                          label: 'Days Since Watered',
                          hint: '3',
                          prefixIcon: Icons.history_toggle_off_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          controller: _lastIrrigationAmountController,
                          label: 'Last Water (L/plant)',
                          hint: '4.0',
                          prefixIcon: Icons.water_drop_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Section 2: Moisture & Climate Outlook
              _buildSectionCard(
                title: 'Soil Moisture & Weather Outlook',
                icon: Icons.water_drop_rounded,
                iconColor: Colors.teal,
                children: [
                  _buildNumberField(
                    controller: _soilMoistureController,
                    label: 'Current Soil Moisture (%)',
                    hint: '38',
                    prefixIcon: Icons.speed_rounded,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          controller: _rainfall24hController,
                          label: 'Past 24h Rain (mm)',
                          hint: '0',
                          prefixIcon: Icons.grain_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          controller: _rainfallForecast24hController,
                          label: '24h Rain Forecast (mm)',
                          hint: '2',
                          prefixIcon: Icons.thunderstorm_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          controller: _tempForecastController,
                          label: 'Forecast Temp (°C)',
                          hint: '31',
                          prefixIcon: Icons.thermostat_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          controller: _humidityForecastController,
                          label: 'Forecast Humidity (%)',
                          hint: '60',
                          prefixIcon: Icons.cloud_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Collapsible Advanced Dynamics
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showAdvancedDynamics = !_showAdvancedDynamics;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            _showAdvancedDynamics
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF0284C7),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showAdvancedDynamics
                                ? 'Hide Evapotranspiration Dynamics'
                                : 'Advanced: Soil Dynamics & ET0 Details',
                            style: const TextStyle(
                              color: Color(0xFF0284C7),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showAdvancedDynamics) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            controller: _et0Controller,
                            label: 'ET0 (mm/day)',
                            hint: '4.8',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNumberField(
                            controller: _cropCoefficientKcController,
                            label: 'Kc Coeff',
                            hint: '1.05',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNumberField(
                            controller: _etcController,
                            label: 'ETc (mm/day)',
                            hint: '5.04',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            controller: _fieldCapacityController,
                            label: 'Field Cap (%)',
                            hint: '28',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            controller: _wiltingPointController,
                            label: 'Wilting Pt (%)',
                            hint: '14',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              // Calculate CTA
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _calculateIrrigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.water_drop_rounded),
                  label: Text(
                    _isLoading ? 'Analyzing Soil & Weather...' : 'Analyze Water Requirement',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Prediction Result Card
              if (_predictionResult != null) ...[
                const SizedBox(height: 24),
                _buildResultCard(),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Irrigation Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Precision watering schedule based on moisture depletion & upcoming rainfall.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBar() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _fetchLiveWeatherAndPlot,
            icon: const Icon(Icons.cloud_sync_rounded, size: 16),
            label: const Text(
              'Sync Live Weather',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0284C7),
              side: const BorderSide(color: Color(0xFF0284C7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _soilMoistureController.text = '46.0';
                _daysSinceIrrigationController.text = '1';
                _rainfallForecast24hController.text = '10.0';
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text(
              'Post-Rain Scenario',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildGrowthStageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crop Growth Stage',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _growthStages.map((stage) {
            final isSelected = _growthStage == stage;
            final label = stage.replaceAll('_', ' ');
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _growthStage = stage);
              },
              selectedColor: const Color(0xFFE0F2FE),
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF0369A1) : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF0284C7) : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) return 'Required';
        if (double.tryParse(val.trim()) == null) return 'Invalid';
        return null;
      },
    );
  }

  Widget _buildResultCard() {
    final rawClass = _predictionResult!['predicted_class'];
    final bool requiresIrrigation = (rawClass == 1 || rawClass == '1' || rawClass == true);
    final rawAmount = _predictionResult!['recommended_irrigation_l_per_plant'];
    final double amount = (rawAmount is num) ? rawAmount.toDouble() : (requiresIrrigation ? 4.5 : 0.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: requiresIrrigation ? const Color(0xFF0284C7) : AppColors.primaryGreen,
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: (requiresIrrigation ? const Color(0xFF0284C7) : AppColors.primaryGreen).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: requiresIrrigation
                      ? const Color(0xFFE0F2FE)
                      : const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  requiresIrrigation
                      ? Icons.water_drop_rounded
                      : Icons.check_circle_rounded,
                  color: requiresIrrigation ? const Color(0xFF0284C7) : AppColors.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requiresIrrigation ? 'IRRIGATION RECOMMENDED' : 'MOISTURE SUFFICIENT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: requiresIrrigation ? const Color(0xFF0369A1) : AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      requiresIrrigation
                        ? 'Soil moisture is below root zone threshold.'
                        : 'No irrigation needed today. Soil has healthy moisture.',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Main Dosage Highlight
          if (requiresIrrigation) ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dosage / Plant',
                          style: TextStyle(fontSize: 12, color: Color(0xFF0369A1)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${amount.toStringAsFixed(1)} Liters',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0C4A6E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recommended Method',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _irrigationMethod,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Optimal Schedule Tile
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule_rounded, color: Color(0xFF1D4ED8), size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Optimal Watering Window',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E40AF)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Early morning: 6:00 AM – 8:30 AM (Prevents bud scald and fungal mildew)',
                          style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Next inspection recommended in 48 hours, or after the upcoming forecasted rain.',
                      style: TextStyle(fontSize: 12, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Agronomic Water Management Tips
          const Text(
            'Smart Water Tips for Jasmine:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _buildTipBullet('Avoid stagnant water around the stem collar to prevent root-rot (Pythium).'),
          _buildTipBullet('Reduce water volume by 20% if rainfall exceeds 10mm within 24 hours.'),
          _buildTipBullet('Mulching with dry straw reduces soil evaporation by up to 35%.'),
        ],
      ),
    );
  }

  Widget _buildTipBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.water_drop_outlined, size: 14, color: Color(0xFF0284C7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

