import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/database_service.dart';
import 'models/disease_details_model.dart';
import 'widgets/disease_stage_section.dart';

class PestsAndDiseasesScreen extends StatefulWidget {
  const PestsAndDiseasesScreen({super.key});

  @override
  State<PestsAndDiseasesScreen> createState() => _PestsAndDiseasesScreenState();
}

class _PestsAndDiseasesScreenState extends State<PestsAndDiseasesScreen> {
  final DatabaseService _db = DatabaseService();
  late Future<List<DiseaseDetailsModel>> _diseasesFuture;

  @override
  void initState() {
    super.initState();
    _diseasesFuture = _db.getAllDiseases();
  }

  void navigateToStage(String title, List<DiseaseDetailsModel> data) {
    context.push('/treatment/stage-expanded', extra: {
      'title': title,
      'diseases': data,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Pests and Diseases',
          style: AppTextStyles.appBarTitle,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<DiseaseDetailsModel>>(
        future: _diseasesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading pests data: ${snapshot.error}'));
          }

          final allDiseases = snapshot.data ?? [];

          // Group by stage (handles case insensitivity)
          final seedling = allDiseases.where((d) => d.stages.any((s) => s.toLowerCase() == 'seedling')).toList();
          final vegetative = allDiseases.where((d) => d.stages.any((s) => s.toLowerCase() == 'vegetative')).toList();
          final flowering = allDiseases.where((d) => d.stages.any((s) => s.toLowerCase() == 'flowering')).toList();
          final harvesting = allDiseases.where((d) => d.stages.any((s) => s.toLowerCase() == 'harvesting')).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pest & Diseases', style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('See relevant information on Jasmine', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Diseases By Stage', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  'All pests and diseases that might appear in your crop at different stages', 
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Jasmine image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/jasmine_crop.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.local_florist, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Show a message if no diseases found across all stages
                if (allDiseases.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No pests or diseases entered into the database yet.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // Stages Lists (Automatically hidden in DiseaseStageSection if empty)
                DiseaseStageSection(
                  stageTitle: 'Seedling Stage',
                  stageIcon: Icons.grass,
                  iconColor: Colors.lightGreen,
                  diseases: seedling,
                  onViewAll: () => navigateToStage('Seedling Stage', seedling),
                ),
                DiseaseStageSection(
                  stageTitle: 'Vegetative Stage',
                  stageIcon: Icons.eco,
                  iconColor: Colors.green,
                  diseases: vegetative,
                  onViewAll: () => navigateToStage('Vegetative Stage', vegetative),
                ),
                DiseaseStageSection(
                  stageTitle: 'Flowering Stage',
                  stageIcon: Icons.local_florist,
                  iconColor: Colors.pinkAccent,
                  diseases: flowering,
                  onViewAll: () => navigateToStage('Flowering Stage', flowering),
                ),
                DiseaseStageSection(
                  stageTitle: 'Harvesting Stage',
                  stageIcon: Icons.content_cut,
                  iconColor: Colors.orange,
                  diseases: harvesting,
                  onViewAll: () => navigateToStage('Harvesting Stage', harvesting),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
