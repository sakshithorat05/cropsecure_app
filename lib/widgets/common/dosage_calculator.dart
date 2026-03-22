import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

class DosageCalculator extends StatefulWidget {
  final double dosagePerAcre;
  final String dosageUnit;
  final String cropName;

  const DosageCalculator({
    super.key,
    required this.dosagePerAcre,
    required this.dosageUnit,
    this.cropName = 'crop',
  });

  @override
  State<DosageCalculator> createState() => _DosageCalculatorState();
}

class _DosageCalculatorState extends State<DosageCalculator> {
  final TextEditingController _areaController = TextEditingController();
  String _selectedUnit = 'Acres';
  double? _computedTotal;

  void _calculate() {
    final areaText = _areaController.text.trim();
    if (areaText.isEmpty) {
      setState(() => _computedTotal = null);
      return;
    }
    
    final area = double.tryParse(areaText);
    if (area != null) {
      double areaInAcres = area;
      if (_selectedUnit == 'Hectares') {
        areaInAcres = area * 2.47105;
      } else if (_selectedUnit == 'Bigha') {
        areaInAcres = area * 0.61; // approx depending on region
      }
      
      setState(() {
        _computedTotal = areaInAcres * widget.dosagePerAcre;
      });
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primaryLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                AppStrings.dosageCalculatorTitle,
                style: AppTextStyles.headingSmall.copyWith(color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.enterAreaLabel,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _areaController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'e.g. 2.5',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              DropdownButtonHideUnderline(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedUnit,
                    style: AppTextStyles.bodyMedium,
                    items: ['Acres', 'Hectares', 'Bigha'].map((u) {
                      return DropdownMenuItem(value: u, child: Text(u));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedUnit = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                height: 48,
                width: 100,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  child: Text(AppStrings.calculate, style: AppTextStyles.labelLarge.copyWith(color: AppColors.white)),
                ),
              ),
            ],
          ),
          if (_computedTotal != null) ...[
            const SizedBox(height: AppSpacing.md),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(_computedTotal),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_computedTotal!.toStringAsFixed(1)} ${widget.dosageUnit}',
                      style: AppTextStyles.dosageHighlight.copyWith(color: AppColors.primaryGreen),
                    ),
                    Text(
                      'for ${_areaController.text} $_selectedUnit of ${widget.cropName}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
