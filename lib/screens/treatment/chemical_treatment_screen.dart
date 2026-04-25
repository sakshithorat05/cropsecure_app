import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/database_service.dart';
import '../../core/services/user_session_service.dart';
import '../../core/theme/app_colors.dart';
import 'models/disease_details_model.dart';
import 'widgets/info_card.dart';
import 'widgets/step_item.dart';
import 'widgets/dosage_card.dart';

class ChemicalTreatmentScreen extends StatelessWidget {
  final DiseaseTreatmentModel data;

  const ChemicalTreatmentScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          data.type == 'Chemical' ? 'Chemical Treatment' : 'Organic Treatment',
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
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

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
                      data.benefit,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dosage Card
              DosageCard(
                mainDosage: data.dose,
                subDosage: 'Follow instructions on the pack thoroughly.',
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
                    childAspectRatio: isWideScreen ? 2.5 : 2.8, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      InfoCard(
                        icon: Icons.water_drop_outlined,
                        title: 'How to Apply',
                        value: data.use,
                      ),
                      InfoCard(
                        icon: Icons.update,
                        title: 'Repeat After',
                        value: data.repeatAfter,
                        iconColor: Colors.blue,
                      ),
                      InfoCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Best Time',
                        value: data.bestTime,
                        iconColor: Colors.orange,
                      ),
                      InfoCard(
                        icon: Icons.timer_outlined,
                        title: 'Wait Before Harvest',
                        value: data.waitingPeriod,
                        iconColor: Colors.red.shade400,
                      ),
                    ],
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
              const SizedBox(height: 20),
              
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

              const SizedBox(height: 24),

              // Estimated Cost
              Text(
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
                    Icon(Icons.currency_rupee, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Text(
                      data.estimatedCost,
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
              if (data.tips.isNotEmpty)
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
                          const Expanded(
                            child: Text(
                              'Farmer Tips',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...data.tips.map((tip) => _buildBulletText(context, tip)),
                    ],
                  ),
                ),

              const SizedBox(height: 44),

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
                        "title": "Chemical Treatment Applied",
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
                            content: Text('Chemical treatment applied and recorded!'),
                            backgroundColor: Colors.redAccent,
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
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Apply Chemical Treatment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
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
            ),
          ),
        ],
      ),
    );
  }

}
