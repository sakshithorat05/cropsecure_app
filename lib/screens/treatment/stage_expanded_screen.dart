import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/disease_stage_card.dart';
import 'models/disease_details_model.dart';

class StageExpandedScreen extends StatelessWidget {
  final String stageTitle;
  final List<DiseaseDetailsModel> diseases;

  const StageExpandedScreen({
    super.key,
    required this.stageTitle,
    required this.diseases,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(stageTitle, style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75, // Taller cards
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          return DiseaseStageCard(disease: diseases[index]);
        },
      ),
    );
  }
}
