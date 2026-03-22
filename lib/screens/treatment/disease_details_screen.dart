import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/disease_details_model.dart';
import 'package:go_router/go_router.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  final DiseaseDetailsModel data;

  const DiseaseDetailsScreen({
    super.key,
    required this.data,
  });

  @override
  State<DiseaseDetailsScreen> createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends State<DiseaseDetailsScreen> {
  String _bottomSectionState = 'causes';

  IconData _getIconForSymptom(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'grass': return Icons.grass;
      case 'eco': return Icons.eco;
      case 'spa': return Icons.spa;
      default: return Icons.warning_amber_rounded;
    }
  }

  Color _getColorForSymptom(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'grass': return Colors.lightGreen;
      case 'eco': return Colors.green;
      case 'spa': return Colors.amber;
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: index == data.images.length - 1 ? 0 : 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            data.images[index],
                            height: 220,
                            width: data.images.length > 1 ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width - 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, e, s) => Container(
                              width: 140, height: 220, color: Colors.grey[200], child: const Icon(Icons.image, size: 64, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (data.images.isNotEmpty) const SizedBox(height: 24),
            
            // Symptoms Title
            Text(
              'Symptoms',
              style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${data.diseaseName} – Symptoms in ${data.cropAffected}',
              style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Dynamic Symptom Sections
            if (data.symptoms.isNotEmpty)
              ...data.symptoms.map((symptom) => _buildSymptomSection(
                icon: _getIconForSymptom(symptom.iconName), 
                iconColor: _getColorForSymptom(symptom.iconName),
                title: symptom.title, 
                bullets: symptom.bullets,
              )),
            if (data.symptoms.isEmpty)
              Text('No specific symptoms recorded.', style: AppTextStyles.bodyMedium),
            
            const SizedBox(height: 16),
            Text('More info', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              'Scientific name: ${data.scientificName.isNotEmpty ? data.scientificName : data.causalOrganism}',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
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
            ),
            
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
              childAspectRatio: 0.82,
            ),
            itemCount: organic.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final t = organic[index];
              return _buildTreatmentCard(
                title: t.title,
                icon: Icons.eco,
                color: const Color(0xFFEFF5CA), 
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
              childAspectRatio: 0.82,
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
    required String type,
    required String use,
    required String dose,
    required String benefit,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: Colors.green[800]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, height: 1.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTreatmentBullet('Type: $type'),
          _buildTreatmentBullet('Use: $use'),
          _buildTreatmentBullet('Dose: $dose'),
          _buildTreatmentBullet('Benefit: $benefit'),
        ],
      ),
    );
  }

  Widget _buildTreatmentBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 10, color: Colors.black87)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 10, height: 1.2),
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
