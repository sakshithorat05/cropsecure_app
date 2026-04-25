import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/plot_provider.dart';

class PlotRegistrationScreen extends ConsumerStatefulWidget {
  const PlotRegistrationScreen({super.key});

  @override
  ConsumerState<PlotRegistrationScreen> createState() => _PlotRegistrationScreenState();
}

class _PlotRegistrationScreenState extends ConsumerState<PlotRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _surveyNoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Dropdown values
  String? _areaUnit;
  String? _category;
  String? _soilType;
  String? _irrigationSource;
  String? _waterSource;
  String? _state;
  String? _district;
  String? _taluka;
  String? _hobali;
  String? _gramaPanchayath;
  String? _village;

  @override
  void dispose() {
    _surveyNoController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newPlot = Plot(
        id: 'plot_${DateTime.now().millisecondsSinceEpoch}',
        surveyNo: _surveyNoController.text,
        cropName: 'Not yet added', // Placeholder until next screen
        variety: 'Not yet added',
        area: _areaController.text,
        unit: _areaUnit ?? 'Acre',
        ownerName: 'Farmer', // Mock for now
        location: '${_village ?? ""}, ${_district ?? ""}',
        status: 'Healthy',
      );

      // Add to provider
      ref.read(plotsProvider.notifier).addPlot(newPlot);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plot basic info saved! Adding crop details...')),
      );

      // Navigate to Crop Registration
      context.push('/crop-registration/${newPlot.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Register Plot', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: const Icon(Icons.eco, color: Colors.green, size: 24),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Survey No', _surveyNoController, 'Enter Survey No / Gat No'),
              
              _buildDropdownField('Unit of the Area', ['Acre', 'Guntha', 'Hectare', 'Cent', 'Bigha', 'Marla'], (v) => setState(() => _areaUnit = v)),
              
              _buildTextField('Area', _areaController, 'Enter Area', keyboardType: TextInputType.number),
              
              _buildDropdownField('Category', ['Marginal', 'Small', 'Medium', 'Big'], (v) => setState(() => _category = v)),
              
              _buildDropdownField('Soil Type', ['Red Soil', 'Black Soil', 'Alluvial Soil', 'Laterite Soil'], (v) => setState(() => _soilType = v)),
              
              _buildDropdownField('Source of Irrigation', ['Irrigation', 'UnIrrigation'], (v) => setState(() => _irrigationSource = v)),
              
              _buildDropdownField('Source of Water', ['Canal', 'Water pond', 'Borewell', 'River', 'Rain'], (v) => setState(() => _waterSource = v)),
              
              _buildDropdownField('State', ['Karnataka', 'Tamil Nadu', 'Kerala', 'Maharashtra'], (v) => setState(() => _state = v)),
              
              _buildDropdownField('District', ['District 1', 'District 2'], (v) => setState(() => _district = v)),
              
              _buildDropdownField('Taluka', ['Taluka 1', 'Taluka 2'], (v) => setState(() => _taluka = v)),
              
              _buildDropdownField('Hobali', ['Hobali 1', 'Hobali 2'], (v) => setState(() => _hobali = v)),
              
              _buildDropdownField('Grama Panchayath', ['GP 1', 'GP 2'], (v) => setState(() => _gramaPanchayath = v)),
              
              _buildDropdownField('Village', ['Village 1', 'Village 2'], (v) => setState(() => _village = v)),
              
              _buildTextField('Pincode', _pincodeController, 'Enter 6-digit Pincode', maxLength: 6, keyboardType: TextInputType.number),

              const SizedBox(height: 24),
              const Text('Plot Documents & Photos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildUploadBox('Farmer Plot', 'Capture Live Photo')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildUploadBox('Phani Plot', 'RTC (Pahani) Record')),
                ],
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                  ),
                  child: const Text('Submit Plot Registration', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool readOnly = false, int? maxLength, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[400]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[400]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          hint: Text('Select $label', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUploadBox(String label, String subLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        Container(
          height: 110,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(subLabel, style: TextStyle(fontSize: 11, color: Colors.grey[700], fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryGreen, size: 36),
            ],
          ),
        ),
      ],
    );
  }
}
