import 'package:flutter/material.dart';

import '../../core/services/ml_api_service.dart';
import '../../core/theme/app_colors.dart';

class PredictionField {
  const PredictionField({
    required this.name,
    required this.label,
    this.options,
  });

  final String name;
  final String label;
  final List<String>? options;

  bool get isCategorical => options != null;
}

const jasmineFields = <PredictionField>[
  PredictionField(name: 'farm_area_acres', label: 'Farm area (acres)'),
  PredictionField(
    name: 'jasmine_variety',
    label: 'Jasmine variety',
    options: ['Madurai Malli', 'Mogra', 'Star Jasmine', 'Udupi Mallige'],
  ),
  PredictionField(name: 'plant_age_years', label: 'Plant age (years)'),
  PredictionField(name: 'soil_ph', label: 'Soil pH'),
  PredictionField(name: 'nitrogen_kg_ha', label: 'Nitrogen (kg/ha)'),
  PredictionField(name: 'phosphorus_kg_ha', label: 'Phosphorus (kg/ha)'),
  PredictionField(name: 'potassium_kg_ha', label: 'Potassium (kg/ha)'),
  PredictionField(name: 'temperature_c', label: 'Temperature (C)'),
  PredictionField(name: 'humidity_percent', label: 'Humidity (%)'),
  PredictionField(name: 'rainfall_mm', label: 'Rainfall (mm)'),
  PredictionField(name: 'soil_moisture_percent', label: 'Soil moisture (%)'),
  PredictionField(
    name: 'irrigation_frequency_per_week',
    label: 'Irrigation frequency (per week)',
  ),
  PredictionField(name: 'fertilizer_kg_ha', label: 'Fertilizer (kg/ha)'),
  PredictionField(
    name: 'pruning_count_per_year',
    label: 'Pruning count (per year)',
  ),
  PredictionField(name: 'disease_severity', label: 'Disease severity'),
  PredictionField(
    name: 'previous_yield_kg_per_acre',
    label: 'Previous yield (kg/acre)',
  ),
];

const irrigationFields = <PredictionField>[
  ...jasmineFields,
  PredictionField(
    name: 'soil_type',
    label: 'Soil type',
    options: ['Clay Loam', 'Loam', 'Sandy Loam'],
  ),
  PredictionField(
    name: 'rainfall_last_24h_mm',
    label: 'Rainfall last 24h (mm)',
  ),
  PredictionField(
    name: 'rainfall_forecast_24h_mm',
    label: 'Rainfall forecast 24h (mm)',
  ),
  PredictionField(
    name: 'rainfall_forecast_48h_mm',
    label: 'Rainfall forecast 48h (mm)',
  ),
  PredictionField(
    name: 'temperature_forecast_c',
    label: 'Temperature forecast (C)',
  ),
  PredictionField(
    name: 'humidity_forecast_percent',
    label: 'Humidity forecast (%)',
  ),
  PredictionField(name: 'wind_speed_kmh', label: 'Wind speed (km/h)'),
  PredictionField(
    name: 'solar_radiation_w_m2',
    label: 'Solar radiation (W/m2)',
  ),
  PredictionField(
    name: 'crop_growth_stage',
    label: 'Crop growth stage',
    options: ['Establishment', 'Flowering', 'Post_Flowering', 'Vegetative'],
  ),
  PredictionField(name: 'days_after_pruning', label: 'Days after pruning'),
  PredictionField(
    name: 'days_since_last_irrigation',
    label: 'Days since last irrigation',
  ),
  PredictionField(
    name: 'last_irrigation_amount_l_per_plant',
    label: 'Last irrigation (L/plant)',
  ),
  PredictionField(
    name: 'irrigation_method',
    label: 'Irrigation method',
    options: ['Basin', 'Drip', 'Furrow'],
  ),
  PredictionField(name: 'field_capacity_percent', label: 'Field capacity (%)'),
  PredictionField(name: 'wilting_point_percent', label: 'Wilting point (%)'),
  PredictionField(name: 'root_zone_depth_cm', label: 'Root zone depth (cm)'),
  PredictionField(name: 'ET0_mm_day', label: 'ET0 (mm/day)'),
  PredictionField(name: 'crop_coefficient_kc', label: 'Crop coefficient (Kc)'),
  PredictionField(name: 'ETc_mm_day', label: 'ETc (mm/day)'),
  PredictionField(
    name: 'effective_rainfall_24h_mm',
    label: 'Effective rainfall 24h (mm)',
  ),
];

class PredictionFormScreen extends StatefulWidget {
  const PredictionFormScreen({
    required this.title,
    required this.fields,
    required this.predict,
    required this.resultBuilder,
    super.key,
  });

  final String title;
  final List<PredictionField> fields;
  final Future<Map<String, dynamic>> Function(Map<String, dynamic>) predict;
  final String Function(Map<String, dynamic>) resultBuilder;

  @override
  State<PredictionFormScreen> createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  final _values = <String, String>{};
  bool _isLoading = false;
  String? _result;

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      if (!field.isCategorical) {
        _controllers[field.name] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final features = <String, dynamic>{};
    for (final field in widget.fields) {
      final raw = field.isCategorical
          ? _values[field.name]
          : _controllers[field.name]!.text.trim();
      features[field.name] = field.isCategorical ? raw : double.parse(raw!);
    }
    setState(() {
      _isLoading = true;
      _result = null;
    });
    try {
      final response = await widget.predict(features);
      if (mounted) setState(() => _result = widget.resultBuilder(response));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final field in widget.fields) _buildField(field),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Get prediction'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 20),
              Card(
                color: AppColors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_result!, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildField(PredictionField field) {
    if (field.isCategorical) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: field.label,
            border: const OutlineInputBorder(),
          ),
          items: field.options!
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: (value) =>
              setState(() => _values[field.name] = value ?? ''),
          validator: (value) => value == null ? 'Required' : null,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: _controllers[field.name],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          if (double.tryParse(value.trim()) == null) return 'Enter a number';
          return null;
        },
      ),
    );
  }
}

class JasmineYieldScreen extends StatelessWidget {
  const JasmineYieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const api = MlApiService();
    return PredictionFormScreen(
      title: 'Jasmine Yield Prediction',
      fields: jasmineFields,
      predict: api.predictJasmineYield,
      resultBuilder: (response) =>
          'Predicted yield: ${response['prediction']} ${response['unit']}',
    );
  }
}

class SmartIrrigationScreen extends StatelessWidget {
  const SmartIrrigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const api = MlApiService();
    return PredictionFormScreen(
      title: 'Smart Irrigation',
      fields: irrigationFields,
      predict: api.predictSmartIrrigation,
      resultBuilder: (response) =>
          'Irrigation required (class): ${response['predicted_class']}\n'
          'Recommended amount: ${response['recommended_irrigation_l_per_plant']} L/plant\n'
          'Probabilities: ${response['probabilities']}',
    );
  }
}
