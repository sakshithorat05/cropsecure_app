import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  const FarmerRegistrationScreen({super.key});

  @override
  State<FarmerRegistrationScreen> createState() => _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _rationController = TextEditingController();

  // Dropdown values
  String? _farmerType;
  String? _gender;
  String? _isHandicapped;
  String? _isMinority;
  String? _caste;
  String? _state;
  String? _district;
  String? _taluka;
  String? _hobali;
  String? _gramaPanchayath;
  String? _village;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _pincodeController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _rationController.dispose();
    super.dispose();
  }

  void _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    setState(() {
      _ageController.text = age.toString();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        _calculateAge(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Register Farmer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
              _buildDropdownField('Farmer Type', ['Cattle', 'Farmer Plot'], (v) => setState(() => _farmerType = v)),
              _buildTextField('Farmer Name', _nameController, 'Enter as per Aadhar card'),
              _buildTextField('Father\'s Name/Husband\'s Name', _fatherNameController, 'Enter as per Aadhar card'),
              _buildDropdownField('Gender', ['Male', 'Female', 'Others'], (v) => setState(() => _gender = v)),
              
              const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Select DOB',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primaryGreen, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[400]!)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[400]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField('Age', _ageController, 'Age', readOnly: true),
              _buildDropdownField('Handicapped', ['Yes', 'No'], (v) => setState(() => _isHandicapped = v)),
              _buildDropdownField('Minority', ['Yes', 'No'], (v) => setState(() => _isMinority = v)),
              _buildDropdownField('Caste', ['Gen', 'OBC', 'SC', 'ST'], (v) => setState(() => _caste = v)),
              _buildTextField('Mobile Number', _mobileController, 'Mobile Number', maxLength: 10, keyboardType: TextInputType.phone),
              _buildTextField('Pincode', _pincodeController, 'Pincode', maxLength: 6, keyboardType: TextInputType.number),
              
              _buildDropdownField('State', ['Karnataka', 'Tamil Nadu', 'Kerala'], (v) => setState(() => _state = v)),
              _buildDropdownField('District Name', ['District 1', 'District 2'], (v) => setState(() => _district = v)),
              _buildDropdownField('Taluka', ['Taluka 1', 'Taluka 2'], (v) => setState(() => _taluka = v)),
              _buildDropdownField('Hobali', ['Hobali 1', 'Hobali 2'], (v) => setState(() => _hobali = v)),
              _buildDropdownField('Grama Panchayath', ['GP 1', 'GP 2'], (v) => setState(() => _gramaPanchayath = v)),
              _buildDropdownField('Village Name', ['Village 1', 'Village 2'], (v) => setState(() => _village = v)),

              _buildTextField('Aadhar Number', _aadharController, 'Aadhar Number', maxLength: 12, keyboardType: TextInputType.number),
              _buildTextField('Pan Number', _panController, 'PAN Number'),
              _buildTextField('Ration Number', _rationController, 'Ration Number'),

              const SizedBox(height: 24),
              const Text('Identity Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildUploadBox('Upload Aadhar', 'Aadhar Card')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildUploadBox('Upload Pan Card', 'Pan Card')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildUploadBox('Upload Ration Card', 'Ration Card')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildUploadBox('Farmer Photo', 'Farmer Photo')),
                ],
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final profileData = {
                        "uid": "user_123", // Using temp UID for consistency with the rest of the app
                        "name": _nameController.text,
                        "phone": _mobileController.text,
                        "profile": {
                          "fatherName": _fatherNameController.text,
                          "dob": _dobController.text,
                          "gender": _gender,
                          "age": _ageController.text,
                          "caste": _caste,
                          "isHandicapped": _isHandicapped,
                          "isMinority": _isMinority,
                        },
                        "address": {
                          "state": _state,
                          "district": _district,
                          "taluka": _taluka,
                          "village": _village,
                          "pincode": _pincodeController.text,
                        },
                        "kyc": {
                          "aadhar": _aadharController.text,
                          "pan": _panController.text,
                          "ration": _rationController.text,
                        }
                      };

                      try {
                        final db = DatabaseService();
                        await db.saveUserProfile("user_123", profileData);
                        if (mounted) context.go('/auth/otp');
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save profile: $e')),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                  ),
                  child: const Text('Submit Registration', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
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
