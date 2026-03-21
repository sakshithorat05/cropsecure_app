import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'models/treatment_advisory_model.dart';
import 'widgets/info_card.dart';
import 'widgets/step_item.dart';
import 'widgets/dosage_card.dart';
import 'widgets/tips_card.dart';
import 'widgets/safety_card.dart';

class OrganicTreatmentScreen extends StatelessWidget {
  final TreatmentModel data;

  const OrganicTreatmentScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Organic Treatment',
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
              Semantics(
                label: 'Treatment Name',
                child: const Text(
                  'Organic Solutions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
                   _buildChip('Trichoderma'),
                   _buildChip('Neem Tel'),
                   _buildChip('Organic Fungicide'),
                ],
              ),
              const SizedBox(height: 24),

              // Description Section
              Semantics(
                label: 'Treatment Description',
                child: Text(
                  'This organic treatment utilizes natural bio-agents and botanical extracts to manage pests and diseases. It works by strengthening the plant\'s immunity and suppressing pathogen growth without chemical residues.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 24),

              // Dosage Card (Green Card)
              const DosageCard(
                title: 'DOSAGE',
                isLight: true,
                items: [
                  DosageItem(
                    name: 'Trichoderma viride',
                    value: '2–4 grams per liter of water',
                  ),
                  DosageItem(
                    name: 'Neem Oil',
                    value: '2 ml per liter of water',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Info Grid (4 Cards)
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const InfoCard(
                            icon: Icons.how_to_reg_outlined,
                            title: 'How to Apply',
                            value: 'Spray on leaves + soil drench',
                          );
                        case 1:
                          return const InfoCard(
                            icon: Icons.repeat_one_outlined,
                            title: 'Repeat After',
                            value: 'Every 10–15 days',
                            iconColor: Colors.blue,
                          );
                        case 2:
                          return const InfoCard(
                            icon: Icons.wb_sunny_outlined,
                            title: 'Best Time',
                            value: 'Early morning or late evening',
                            iconColor: Colors.orange,
                          );
                        case 3:
                          return const InfoCard(
                            icon: Icons.timer_outlined,
                            title: 'No Waiting Period',
                            value: 'Safe to harvest anytime',
                            iconColor: AppColors.primaryGreen,
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
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
              const SizedBox(height: 20),
              
              const Text(
                'Step 1 – Trichoderma Application',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              const StepItem(stepNumber: 1, description: 'Mix required Trichoderma powder with small water'),
              const StepItem(stepNumber: 2, description: 'Add 1 tsp jaggery or sugar'),
              const StepItem(stepNumber: 3, description: 'Keep mixture 30 minutes in shade'),
              const StepItem(stepNumber: 4, description: 'Dilute with remaining water'),
              const StepItem(stepNumber: 5, description: 'Apply as soil drench + foliar spray', isLast: true),
              
              const SizedBox(height: 20),
              const Text(
                'Step 2 – Neem Oil Application',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              const StepItem(stepNumber: 1, description: 'Wait 5–7 days after Trichoderma'),
              const StepItem(stepNumber: 2, description: 'Mix neem oil with water separately'),
              const StepItem(stepNumber: 3, description: 'Spray thoroughly on both sides of leaves', isLast: true),

              const SizedBox(height: 32),

              // Cost Section
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
                  boxShadow: [AppColors.softShadow],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.currency_rupee, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '₹80–120 per application',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Farmer Tips Card
              const TipsCard(
                tips: [
                  'Always prepare fresh solution',
                  'Add mild soap for neem oil mixing',
                  'Safe during flowering stage',
                  'Combine with organic practices',
                ],
              ),
              const SizedBox(height: 24),

              // Safety Card
              const SafetyCard(
                instructions: [
                  'Avoid spraying in hot sun',
                  'Avoid eye/skin contact',
                  'Do not spray stressed plants',
                  'Keep away from bees',
                  'Store properly',
                ],
              ),

              // Bottom spacing scroll safety
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
}
