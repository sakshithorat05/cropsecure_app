import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/database_service.dart';
import '../../core/services/user_session_service.dart';
import '../../core/theme/app_colors.dart';
import 'models/disease_details_model.dart';
import 'widgets/info_card.dart';
import 'widgets/step_item.dart';
import 'widgets/dosage_card.dart';
import 'widgets/tips_card.dart';
import 'widgets/safety_card.dart';

class OrganicTreatmentScreen extends StatelessWidget {
  final DiseaseTreatmentModel data;

  const OrganicTreatmentScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          data.type == 'Organic' ? 'Organic Treatment' : 'Chemical Treatment',
          style: const TextStyle(
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
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Section
              Semantics(
                label: 'Treatment Description',
                child: Text(
                  data.benefit,
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
              DosageCard(
                title: 'DOSAGE',
                isLight: true,
                items: [
                  DosageItem(
                    name: 'Recommended Dose',
                    value: data.dose,
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
                          return InfoCard(
                            icon: Icons.how_to_reg_outlined,
                            title: 'How to Apply',
                            value: data.use,
                          );
                        case 1:
                          return InfoCard(
                            icon: Icons.repeat_one_outlined,
                            title: 'Repeat After',
                            value: data.repeatAfter,
                            iconColor: Colors.blue,
                          );
                        case 2:
                          return InfoCard(
                            icon: Icons.wb_sunny_outlined,
                            title: 'Best Time',
                            value: data.bestTime,
                            iconColor: Colors.orange,
                          );
                        case 3:
                          return InfoCard(
                            icon: Icons.timer_outlined,
                            title: 'Waiting Period',
                            value: data.waitingPeriod,
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
              Text(
                'Step-by-Step Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              
              if (data.steps.isEmpty)
                Text('No steps provided in database.')
              else
                ...data.steps.asMap().entries.map((entry) {
                   int idx = entry.key;
                   String stepDesc = entry.value;
                   return StepItem(
                     stepNumber: idx + 1, 
                     description: stepDesc,
                     isLast: idx == data.steps.length - 1,
                   );
                }),
              
              const SizedBox(height: 32),

              // Cost Section
              Text(
                'Estimated Cost',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
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
                    Icon(Icons.currency_rupee, color: AppColors.primaryGreen),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.estimatedCost,
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
              if (data.tips.isNotEmpty) ...[
                TipsCard(tips: data.tips),
                const SizedBox(height: 24),
              ],

              // Safety Card
              if (data.safety.isNotEmpty)
                SafetyCard(instructions: data.safety),

              const SizedBox(height: 40),

              // Apply Treatment Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final db = DatabaseService();
                      final uid = await UserSessionService().getCurrentUserId();
                      await db.addFarmHistoryLog(uid, {
                        "type": "treatment",
                        "title": "Treatment Applied",
                        "subtitle": data.title,
                        "createdAt": DateTime.now(),
                        "metadata": {
                          "treatment": data.title,
                          "type": data.type,
                          "dose": data.dose,
                        }
                      });
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Treatment applied and recorded in farm history!'),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                        context.pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to record treatment: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Apply Treatment Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Bottom spacing scroll safety
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

}
