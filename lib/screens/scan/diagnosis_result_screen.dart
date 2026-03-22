import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/database_service.dart';
import '../treatment/models/disease_details_model.dart';
import '../../providers/scan_provider.dart';

class DiagnosisResultScreen extends ConsumerWidget {
  const DiagnosisResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanProvider);
    final result = scanState.result;

    if (result == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('No diagnosis result available', style: AppTextStyles.headingLarge),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Top Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.close, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Text('Diagnosis Result', style: AppTextStyles.displayMedium.copyWith(color: AppColors.white, fontSize: 24)),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Diagnosis Result', style: AppTextStyles.displayMedium),
                    const SizedBox(height: 20),
                    
                    // Result Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [AppColors.softShadow],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Placeholder
                          Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          ),
                          
                          // Details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.eco, color: AppColors.primaryGreen, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Disease Name: ${result.diseaseName}', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.bug_report, color: AppColors.accentLime, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Disease Type: Fungal', style: AppTextStyles.bodyLarge),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 16),
                                
                                // Stats Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStatItem('Affected Part:', 'Leaf'),
                                    _buildStatItemWithBadge('Severity:', result.severity, _getSeverityColor(result.severity)),
                                    _buildStatItem('Confidence\nScore:', '${result.confidenceScore.toStringAsFixed(1)}%'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Warning Alert
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.alertYellow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _getSeverityColor(result.severity).withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: _getSeverityColor(result.severity), size: 30),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Immediate treatment recommended',
                              style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Text(
                      '${result.diseaseName} detected - ${result.severity} severity. ${result.immediateAction}',
                      style: AppTextStyles.bodyMedium,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final db = DatabaseService();
                              try {
                                await db.addFarmHistoryLog('user_123', {
                                  'type': 'scan',
                                  'title': 'Scan Result',
                                  'subtitle': '${result.diseaseName} detected',
                                  'imageUrl': null,
                                  'metadata': {
                                    'disease': result.diseaseName,
                                    'severity': result.severity,
                                    'confidence': '${result.confidenceScore.toStringAsFixed(1)}%',
                                  }
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Result saved to Farm History')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error saving: $e')),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.save, color: AppColors.white, size: 20),
                            label: Text('Save Result', style: AppTextStyles.labelLarge),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final mockDiseaseData = DiseaseDetailsModel(
                                id: 'leaf_blight_id',
                                cropAffected: 'Jasmine',
                                diseaseName: result.diseaseName,
                                diseaseType: 'Fungal',
                                causalOrganism: 'Alternaria alternata / Cercospora jasminicola',
                                scientificName: 'Alternaria alternata / Cercospora jasminicola',
                                description: 'Leaf blight disease of jasmine is a fungal disease that affects the leaves, causing dark lesions and drying. It reduces photosynthetic activity, weakens plant growth, and lowers flower yield and quality.',
                                affectedPart: 'Leaves',
                                primarySpread: 'Airborne spores, rain splash',
                                severityLevel: 'Medium to High',
                                stages: ['Early', 'Developing'],
                                images: ['https://img.freepik.com/free-photo/damaged-leaves-with-spots_23-2149174021.jpg'],
                                symptoms: [
                                  DiseaseSymptomModel(
                                    title: 'Early Symptoms',
                                    iconName: 'eco',
                                    bullets: ['Small water-soaked or pale brown spots appear on leaves', 'Spots usually start at leaf tips or margins'],
                                  ),
                                  DiseaseSymptomModel(
                                    title: 'Progressive Symptoms',
                                    iconName: 'spa',
                                    bullets: ['Spots increase in size and number', 'Lesions become dark brown to black'],
                                  ),
                                  DiseaseSymptomModel(
                                    title: 'Advanced Symptoms',
                                    iconName: 'warning_amber_rounded',
                                    bullets: ['Large portions of the leaf become dry and scorched', 'Leaves turn yellow -> brown -> dry'],
                                  ),
                                ],
                                identifyStages: [
                                  IdentifyStageModel(stageNumber: 1, title: 'Early Stage', description: 'Small, water-soaked light brown spots appear first on older leaves.'),
                                  IdentifyStageModel(stageNumber: 2, title: 'Developing Stage', description: 'Spots enlarge with target-like rings, may merge into brown patches.'),
                                  IdentifyStageModel(stageNumber: 3, title: 'Advanced Stage', description: 'Leaves turn brown, dry, and drop; flower buds may discolor.'),
                                  IdentifyStageModel(stageNumber: 4, title: 'Severe Stage', description: 'Most leaves affected or fallen. Stems may show dark lesions.'),
                                ],
                                favourableConditions: [
                                  FavourableConditionModel(title: 'High Humidity', description: 'Relative humidity above 70-80%', iconName: 'water_drop'),
                                  FavourableConditionModel(title: 'Warm Temperature', description: 'Ideal range 25-30°C', iconName: 'thermostat'),
                                  FavourableConditionModel(title: 'Poor Air Circulation', description: 'Dense planting or overgrown plants', iconName: 'air'),
                                  FavourableConditionModel(title: 'Frequent Rain', description: 'Continuous rainfall or overhead irrigation', iconName: 'cloudy_snowing'),
                                ],
                                causes: ['High humidity', 'Poor air circulation'],
                                organicTreatments: [
                                  DiseaseTreatmentModel(
                                    title: 'Neem Oil Spray',
                                    type: 'Organic',
                                    use: 'Spray on leaves',
                                    dose: '5ml/liter',
                                    benefit: 'Antifungal properties',
                                    steps: [
                                      'Wait 5–7 days after any bio-fungicides',
                                      'Mix neem oil with water separately',
                                      'Spray thoroughly on both sides of leaves',
                                    ],
                                    estimatedCost: '₹80–120 per application',
                                    repeatAfter: 'Every 10-15 days',
                                    bestTime: 'Early morning or late evening',
                                    waitingPeriod: 'Safe to harvest anytime',
                                    tips: ['Always prepare fresh solution', 'Combine with organic practices'],
                                    safety: ['Avoid spraying in hot sun', 'Store properly'],
                                  ),
                                ],
                                chemicalTreatments: [],
                                preventiveMeasures: ['Use disease-free seeds', 'Rotate crops'],
                              );
                              context.push('/disease-details', extra: mockDiseaseData);
                            },
                            icon: const Icon(Icons.medical_services, color: AppColors.white, size: 20),
                            label: const Text('View Treatment Plan', 
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 80), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatItemWithBadge(String label, String value, Color badgeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.2),
            border: Border.all(color: badgeColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(color: badgeColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.riskMedium;
      case 'high':
        return AppColors.error;
      default:
        return AppColors.primaryGreen;
    }
  }
}
