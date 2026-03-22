import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/disease_details_model.dart';
import '../../core/localization/translation_extension.dart';
import '../../providers/locale_provider.dart';
import 'package:go_router/go_router.dart';

class DiseaseDetailsScreen extends ConsumerStatefulWidget {
  final DiseaseDetailsModel data;

  const DiseaseDetailsScreen({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<DiseaseDetailsScreen> createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends ConsumerState<DiseaseDetailsScreen> {
  String _bottomSectionState = 'causes';

  IconData _getIconForSymptom(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'grass': return Icons.grass;
      case 'eco': return Icons.eco;
      case 'spa': return Icons.spa;
      case 'early symptoms': return Icons.eco;
      case 'progressive symptoms': return Icons.spa;
      case 'advanced symptoms': return Icons.warning_amber_rounded;
      default: return Icons.warning_amber_rounded;
    }
  }

  Color _getColorForSymptom(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'grass': return Colors.lightGreen;
      case 'eco': return Colors.green;
      case 'spa': return Colors.amber;
      case 'early symptoms': return Colors.green;
      case 'progressive symptoms': return Colors.orange;
      case 'advanced symptoms': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryGreen),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              data.diseaseName,
              style: AppTextStyles.displayMedium.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${data.diseaseType} – ${data.causalOrganism}',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.green.shade600, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            
            // Dynamic Images Carousel
            if (data.images.isNotEmpty)
              _buildImageCarousel(data.images),
            if (data.images.isNotEmpty) const SizedBox(height: 24),
            
            // Symptoms Section
            _buildSymptomsSection(data),
            
            const SizedBox(height: 32),
            
            // What is [Disease]?
            _buildWhatIsSection(data),
            
            const SizedBox(height: 32),
            
            // Scientific Classification Section
            _buildClassificationTable(data),
            
            const SizedBox(height: 32),
            
            // How to Identify Section
            _buildHowToIdentify(data),
            
            const SizedBox(height: 32),
            
            // Favourable Conditions Section
            _buildFavourableConditions(data),
            
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(),
            
            const SizedBox(height: 32),
            
            // Conditionally show Treatment, Prevent, or "What Caused It"
            if (_bottomSectionState == 'treat')
              _buildTreatmentSection()
            else if (_bottomSectionState == 'prevent')
              _buildPreventiveMeasuresSection()
            else
              _buildWhatCausedItSection(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index == images.length - 1 ? 0 : 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[index],
                      height: 220,
                      width: images.length > 1 ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width - 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, e, s) => Container(
                        width: MediaQuery.of(context).size.width - 40, 
                        height: 220, 
                        color: Colors.grey[200], 
                        child: const Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGreen.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSymptomsSection(DiseaseDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'symptoms'.tr(ref),
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${data.diseaseName} – Symptoms in ${data.cropAffected}',
          style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (data.symptoms.isNotEmpty)
          ...data.symptoms.map((symptom) => _buildSymptomSection(
            icon: _getIconForSymptom(symptom.title), 
            iconColor: _getColorForSymptom(symptom.title),
            title: symptom.title, 
            bullets: symptom.bullets,
          ))
        else
          Text('No specific symptoms recorded.', style: AppTextStyles.bodyMedium),
      ],
    );
  }

  Widget _buildWhatIsSection(DiseaseDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is ${data.diseaseName}?',
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                data.description.isNotEmpty 
                  ? data.description 
                  : '${data.diseaseName} is a ${data.diseaseType.toLowerCase()} disease that affects ${data.cropAffected.toLowerCase()}.',
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
            ),
            if (data.images.isNotEmpty) ...[
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data.images.first,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildClassificationTable(DiseaseDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'scientific_classification'.tr(ref),
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildClassificationRow('Disease', data.diseaseName), // disease name is data driven
              _buildClassificationRow('Crop Affected', data.cropAffected), 
              _buildClassificationRow('Disease Type', '${data.diseaseType} Disease'),
              _buildClassificationRow('causal_organism'.tr(ref), data.causalOrganism),
              _buildClassificationRow('affected_part'.tr(ref), data.affectedPart),
              _buildClassificationRow('primary_spread'.tr(ref), data.primarySpread),
              _buildClassificationRow('severity'.tr(ref), data.severityLevel, isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassificationRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600])),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToIdentify(DiseaseDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Identify?',
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (data.identifyStages.isEmpty)
          Text('Identification stages not available.', style: AppTextStyles.bodyMedium)
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: data.identifyStages.length,
            itemBuilder: (context, index) {
              final stage = data.identifyStages[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade100, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Text(
                        '${stage.stageNumber} ${stage.title}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        stage.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11, 
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildFavourableConditions(DiseaseDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favourable Conditions',
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (data.favourableConditions.isEmpty)
          Text('Detailed conditions not available.', style: AppTextStyles.bodyMedium)
        else
          ...data.favourableConditions.map((condition) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: condition.getColor(),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: condition.getColor().withOpacity(0.8)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(condition.getIcon(), color: Colors.black87, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        condition.title,
                        style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition.description,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.black54, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _bottomSectionState == 'treat' ? const Color(0xFF558B42) : Colors.grey[300],
              foregroundColor: _bottomSectionState == 'treat' ? AppColors.white : AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              setState(() {
                _bottomSectionState = 'treat';
              });
            },
            child: const Text('Treat now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _bottomSectionState == 'prevent' ? const Color(0xFF558B42) : Colors.grey[300],
              foregroundColor: _bottomSectionState == 'prevent' ? AppColors.white : AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              setState(() {
                _bottomSectionState = 'prevent';
              });
            },
            child: const Text('Prevent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildPreventiveMeasuresSection() {
    final measures = widget.data.preventiveMeasures;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preventive Measures',
          style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        if (measures.isEmpty)
           const Text('No preventive measures recorded yet.'),
        ...measures.map((p) => _buildBulletText(p)),
      ],
    );
  }

  Widget _buildWhatCausedItSection() {
    final causes = widget.data.causes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.nature, color: Colors.green[700], size: 20),
            const SizedBox(width: 8),
            Text('What Caused It', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        if (causes.isEmpty)
           const Text('Causes are not documented for this disease.'),
        ...causes.map((cause) => _buildBulletText(cause)),
      ],
    );
  }

  Widget _buildTreatmentSection() {
    final organic = widget.data.organicTreatments;
    final chemical = widget.data.chemicalTreatments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (organic.isNotEmpty) ...[
          Text(
            'Organic Treatment',
            style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: organic.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final t = organic[index];
              return _buildTreatmentCard(
                title: t.title,
                icon: Icons.eco,
                color: const Color(0xFFF9FBE7), 
                iconColor: Colors.green.shade700,
                type: t.type,
                use: t.use,
                dose: t.dose,
                benefit: t.benefit,
              );
            },
          ),
          const SizedBox(height: 32),
        ],
        
        if (chemical.isNotEmpty) ...[
          Text(
            'Chemical Treatment',
            style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: chemical.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final t = chemical[index];
              return _buildTreatmentCard(
                title: t.title,
                icon: Icons.science_outlined,
                color: const Color(0xFFE3F2FD), 
                iconColor: Colors.blue.shade700,
                type: t.type,
                use: t.use,
                dose: t.dose,
                benefit: t.benefit,
              );
            },
          ),
        ],

        if (organic.isEmpty && chemical.isEmpty)
           const Padding(
             padding: EdgeInsets.all(16.0),
             child: Center(child: Text('No treatments recorded.')),
           ),
      ],
    );
  }

  Widget _buildTreatmentCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String type,
    required String use,
    required String dose,
    required String benefit,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 13, 
                    height: 1.2,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTreatmentBullet('Type', type),
          _buildTreatmentBullet('Use', use),
          _buildTreatmentBullet('Dose', dose),
          _buildTreatmentBullet('Benefit', benefit),
        ],
      ),
    );
  }

  Widget _buildTreatmentBullet(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5))),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 11, height: 1.3, color: Colors.black87),
                children: [
                  TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSection({required IconData icon, required Color iconColor, required String title, required List<String> bullets}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          ...bullets.map((b) => _buildBulletText(b)),
        ],
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
