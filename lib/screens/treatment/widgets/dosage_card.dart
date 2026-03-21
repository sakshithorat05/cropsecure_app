import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DosageCard extends StatelessWidget {
  final String? mainDosage;
  final String? subDosage;
  final String title;
  final List<DosageItem>? items;
  final bool isLight;

  const DosageCard({
    super.key,
    this.mainDosage,
    this.subDosage,
    this.title = 'DOSAGE',
    this.items,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.lightGreen : AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow], // Slight elevation
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science,
                color: isLight ? AppColors.primaryGreen : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isLight ? AppColors.primaryGreen : Colors.white.withAlpha(230),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items != null)
            ...items!.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: isLight ? AppColors.darkGreen : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.value,
                        style: TextStyle(
                          color: isLight ? AppColors.textSecondary : Colors.white.withAlpha(204),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ))
          else ...[
            if (mainDosage != null)
              Text(
                mainDosage!,
                style: TextStyle(
                  color: isLight ? AppColors.darkGreen : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),
            if (subDosage != null)
              Text(
                subDosage!,
                style: TextStyle(
                  color: isLight ? AppColors.textSecondary : Colors.white.withAlpha(204),
                  fontSize: 14,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class DosageItem {
  final String name;
  final String value;

  const DosageItem({required this.name, required this.value});
}
