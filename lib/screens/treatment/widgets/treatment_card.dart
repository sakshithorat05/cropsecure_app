import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../models/disease_details_model.dart';
import '../models/treatment_advisory_model.dart';

class TreatmentCard extends StatelessWidget {
  final DiseaseTreatmentModel treatment;

  const TreatmentCard({
    super.key,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    final bool isChemical = treatment.type.toLowerCase() == 'chemical';
    
    // Explicit Figma Badges
    final String badgeText = isChemical ? 'FAST ACTING' : 'ECO-FRIENDLY';
    final Color badgeColor = isChemical ? AppColors.primaryGreen : Colors.blue;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppColors.softShadow],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isChemical) {
              context.push('/treatment/chemical', extra: treatment);
            } else {
              context.push('/treatment/organic', extra: treatment);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              isChemical ? 'Chemical Treatment' : 'Organic Treatment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isChemical)
                            Text(
                              'Success Rate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          if (isChemical)
                            Text(
                              '92%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        treatment.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
