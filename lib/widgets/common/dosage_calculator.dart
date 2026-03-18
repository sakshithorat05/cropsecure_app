import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_text_field.dart';

/// Inline calculator for dosage computation based on farm area.
class DosageCalculator extends StatefulWidget {
  final double dosagePerAcre; // e.g., 200 ml per acre
  final String unit; // 'ml' or 'g' or 'kg'

  const DosageCalculator({
    super.key,
    required this.dosagePerAcre,
    required this.unit,
  });

  @override
  State<DosageCalculator> createState() => _DosageCalculatorState();
}

class _DosageCalculatorState extends State<DosageCalculator> {
  final TextEditingController _areaController = TextEditingController();
  double _computedDose = 0.0;

  @override
  void initState() {
    super.initState();
    _areaController.addListener(_calculateDose);
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _calculateDose() {
    final areaText = _areaController.text.trim();
    if (areaText.isEmpty) {
      setState(() => _computedDose = 0.0);
      return;
    }
    
    final area = double.tryParse(areaText);
    if (area != null) {
      setState(() {
        _computedDose = area * widget.dosagePerAcre;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, color: AppColors.primaryGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Dosage Calculator',
                style: AppTextStyles.headingMedium.copyWith(color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: AppTextField(
                  controller: _areaController,
                  labelText: 'Farm Area (Acres)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Required',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      '${_computedDose.toStringAsFixed(1)} ${widget.unit}',
                      style: AppTextStyles.dosageHighlight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
