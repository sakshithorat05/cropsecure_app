import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/plot_provider.dart';

class CropFieldRegistrationScreen extends ConsumerStatefulWidget {
  final String plotId;
  const CropFieldRegistrationScreen({super.key, required this.plotId});

  @override
  ConsumerState<CropFieldRegistrationScreen> createState() => _CropFieldRegistrationScreenState();
}

class _CropFieldRegistrationScreenState extends ConsumerState<CropFieldRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Values
  String? _cropType;
  String? _cropName;
  String? _cropVariety;
  String? _cropSeason;
  String? _seedSource;
  String? _specificTech;
  String? _seedTreatment;
  DateTime? _sowingDate;
  String _mixedCrop = 'No';
  
  // Controllers for mixed crop
  final TextEditingController _mixedCropNameController = TextEditingController();
  final TextEditingController _mixedCropVarietyController = TextEditingController();
  final TextEditingController _mixedCropTechController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to access ref safely if needed, 
    // but here we can just read it once during init.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plotsAsync = ref.read(plotsProvider);
      final plots = plotsAsync.value ?? [];
      final plot = plots.firstWhere((p) => p.id == widget.plotId, orElse: () => plots.first);
      
      setState(() {
        _cropType = plot.cropType;
        _cropName = plot.cropName != 'Not yet added' ? plot.cropName : null;
        _cropVariety = plot.variety != 'Not yet added' ? plot.variety : null;
        _cropSeason = plot.cropSeason;
        _seedSource = plot.seedSource;
        _specificTech = plot.specificTech;
        _seedTreatment = plot.seedTreatment;
        _sowingDate = plot.sowingDate;
        _mixedCrop = plot.hasMixedCrop ? 'Yes' : 'No';
        _mixedCropNameController.text = plot.mixedCropName ?? '';
        _mixedCropVarietyController.text = plot.mixedCropVariety ?? '';
        _mixedCropTechController.text = plot.mixedCropSpecificTech ?? '';
      });
    });
  }

  @override
  void dispose() {
    _mixedCropNameController.dispose();
    _mixedCropVarietyController.dispose();
    _mixedCropTechController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _sowingDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _sowingDate) {
      setState(() {
        _sowingDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Crop & Fields', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
      body: Consumer(
        builder: (context, ref, child) {
          final plotsAsync = ref.watch(plotsProvider);
          final plots = plotsAsync.value ?? [];
          final plot = plots.firstWhere((p) => p.id == widget.plotId, orElse: () => plots.isNotEmpty ? plots.first : const Plot(id: '', surveyNo: '', cropName: '', variety: '', area: '', unit: '', ownerName: '', location: ''));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plot Summary Section (Read-Only)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.landscape, color: AppColors.primaryGreen, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Plot: ${plot.surveyNo}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Area: ${plot.area} ${plot.unit}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Seasonal Crop Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 16),

                  _buildDropdownField('Crop Type', ['Grain', 'Fruit', 'Vegetable', 'Flower', 'Other'], (v) => setState(() => _cropType = v), value: _cropType),
                  _buildDropdownField('Crop Name', ['Greengram', 'Jasmine', 'Tomato', 'Maize', 'Paddy', 'Marigold'], (v) => setState(() => _cropName = v), value: _cropName),
              _buildDropdownField('Crop Varieties', ['BGS-9', 'African Orange', 'Hybrid-7', 'Local', 'Sambangi'], (v) => setState(() => _cropVariety = v), value: _cropVariety),
              _buildDropdownField('Crop Season', ['Kharif', 'Rabi', 'Zaid', 'Summer', 'Whole Year'], (v) => setState(() => _cropSeason = v), value: _cropSeason),
              _buildDropdownField('Source from which the seed was obtained?', ['Application', 'Market', 'Own Seed', 'Department', 'Others'], (v) => setState(() => _seedSource = v), value: _seedSource),
              _buildDropdownField('Specific Technology', ['Drill sown with pulse intercrop', 'Broadcasting', 'Transplantation', 'Drip Irrigation'], (v) => setState(() => _specificTech = v), value: _specificTech),
              _buildDropdownField('Seed Treatment and Dipping', ['None', 'Organic', 'Chemical', 'Physical'], (v) => setState(() => _seedTreatment = v), value: _seedTreatment),
              
              // Sowing Date Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sowing Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _sowingDate == null 
                                ? 'Select Date' 
                                : '${_sowingDate!.year}/${_sowingDate!.month.toString().padLeft(2, '0')}/${_sowingDate!.day.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 15, color: _sowingDate == null ? Colors.grey[600] : Colors.black),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.black54, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

              _buildDropdownField('Mixed Crop', ['No', 'Yes'], (v) => setState(() => _mixedCrop = v ?? 'No'), value: _mixedCrop),

              if (_mixedCrop == 'Yes') ...[
                _buildTextField('Mixed Crop Name', _mixedCropNameController, 'Enter Mixed Crop Name'),
                _buildTextField('Mixed Crop Variety', _mixedCropVarietyController, 'Enter Mixed Crop Variety'),
                _buildTextField('Mixed Crop Specific Tech', _mixedCropTechController, 'Enter Mixed Crop Specific Tech'),
              ],

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final plotsAsync = ref.read(plotsProvider);
                      final plots = plotsAsync.value ?? [];
                      final plot = plots.firstWhere((p) => p.id == widget.plotId);
                      
                      final updatedPlot = plot.copyWith(
                        cropName: _cropName ?? 'Not yet added',
                        variety: _cropVariety ?? 'Not yet added',
                        cropType: _cropType,
                        cropSeason: _cropSeason,
                        seedSource: _seedSource,
                        specificTech: _specificTech,
                        seedTreatment: _seedTreatment,
                        sowingDate: _sowingDate,
                        hasMixedCrop: _mixedCrop == 'Yes',
                        mixedCropName: _mixedCropNameController.text,
                        mixedCropVariety: _mixedCropVarietyController.text,
                        mixedCropSpecificTech: _mixedCropTechController.text,
                      );
                      
                      // Update provider
                      ref.read(plotsProvider.notifier).updatePlot(updatedPlot);
                      
                      // Also update active plot if it was the one modified
                      if (ref.read(activePlotProvider)?.id == plot.id) {
                        ref.read(activePlotProvider.notifier).setActivePlot(updatedPlot);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Crop Details Updated Successfully')),
                      );
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
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

  Widget _buildDropdownField(String label, List<String> items, Function(String?) onChanged, {String? value}) {
    // Safety check for dropdown values
    final bool valueExists = items.contains(value);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: valueExists ? value : null,
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
}
