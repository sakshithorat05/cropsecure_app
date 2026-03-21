import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'models/treatment_advisory_model.dart';
import 'widgets/info_card.dart';
import 'widgets/step_item.dart';
import 'widgets/dosage_card.dart';

class ChemicalTreatmentScreen extends StatelessWidget {
  final TreatmentModel data;

  const ChemicalTreatmentScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Chemical Treatment',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Medicine Name Header
              Text(
                data.medicineName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // ALSO KNOWN AS Section
              const Text(
                'ALSO KNOWN AS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip('Bavistin'),
                  _buildChip('Dhanustin'),
                ],
              ),
              const SizedBox(height: 24),

              // Description Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: AppColors.primaryGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'This fungicide provides both curative and preventive action against a wide range of crop diseases. Designed for rapid absorption to halt fungal growth effectively.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dosage Card
              const DosageCard(
                mainDosage: '2 grams per 1 liter water',
                subDosage: 'Per Acre: 500g per 200 liters water',
              ),
              const SizedBox(height: 24),

              // Info Grid (4 Cards)
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isWideScreen = constraints.maxWidth > 600;
                  return GridView.count(
                    crossAxisCount: isWideScreen ? 2 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isWideScreen ? 2.5 : 2.8, // Increased height for mobile
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      const InfoCard(
                        icon: Icons.water_drop_outlined,
                        title: 'How to Apply',
                        value: 'Foliar spray (spray on leaves)',
                      ),
                      const InfoCard(
                        icon: Icons.update,
                        title: 'Repeat After',
                        value: 'Repeat after 7–10 days',
                        iconColor: Colors.blue,
                      ),
                      const InfoCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Best Time',
                        value: 'Early morning or late evening',
                        iconColor: Colors.orange,
                      ),
                      InfoCard(
                        icon: Icons.timer_outlined,
                        title: 'Wait Before Harvest',
                        value: '7 days before harvest',
                        iconColor: Colors.red.shade400,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Step-by-Step Instructions
              const Text(
                'Step-by-Step Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const StepItem(
                stepNumber: 1,
                description: 'Fill spray tank halfway with clean water',
              ),
              const StepItem(
                stepNumber: 2,
                description: 'Measure 1 g Carbendazim per liter of water',
              ),
              const StepItem(
                stepNumber: 3,
                description: 'Dissolve powder in a small container first',
              ),
              const StepItem(
                stepNumber: 4,
                description: 'Fill remaining water and stir thoroughly',
              ),
              const StepItem(
                stepNumber: 5,
                description: 'Add solution to spray tank and mix well',
              ),
              const StepItem(
                stepNumber: 6,
                description: 'Spray on all leaves (upper & lower surfaces)',
              ),
              const StepItem(
                stepNumber: 7,
                description: 'Ensure uniform coverage; avoid runoff',
                isLast: true,
              ),
              const SizedBox(height: 24),

              // Estimated Cost
              const Text(
                'Estimated Cost',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.currency_rupee, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Text(
                      '150–200 per 250g pack',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Farmer Tips
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Farmer Tips',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBulletText(context, 'Shake sprayer every few minutes'),
                    _buildBulletText(context, 'Do not mix with other pesticides unless recommended'),
                    _buildBulletText(context, 'Store powder in cool dry place'),
                    _buildBulletText(context, 'Do not store mixed solution overnight'),
                  ],
                ),
              ),

              // Bottom spacing to prevent FAB overlap
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBulletText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange.shade900,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
