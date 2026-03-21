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

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
            
            // Images Array (Two images side-by-side matching the new mockup)
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/jasmine_crop.jpg',
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, e, s) => Container(height: 140, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 140,
                      color: Colors.green.shade100, // Placeholder for the second spotty leaf image
                      child: const Center(
                        child: Text(
                          'Leaf Image 2',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Symptoms Title
            Text(
              'Symptoms',
              style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${data.diseaseName} – Symptoms in Jasmine',
              style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Hardcoded Symptom Sections matching Mockup
            _buildSymptomSection(
              icon: Icons.grass, 
              iconColor: Colors.lightGreen,
              title: 'Early Symptoms', 
              bullets: [
                'Small water-soaked or pale brown spots appear on leaves',
                'Spots usually start at leaf tips or margins',
                'Affected areas may have a yellow halo around them',
                'Only a few leaves are affected at this stage',
              ],
            ),
            _buildSymptomSection(
              icon: Icons.eco, 
              iconColor: Colors.green,
              title: 'Progressive Symptoms', 
              bullets: [
                'Spots increase in size and number',
                'Lesions become dark brown to black',
                'Target-like rings may be visible in some cases',
                'Multiple spots merge to form large blighted areas',
                'Leaves begin to curl, wrinkle, or lose shine',
              ],
            ),
            _buildSymptomSection(
              icon: Icons.spa, 
              iconColor: Colors.amber,
              title: 'Advanced / Severe Symptoms', 
              bullets: [
                'Large portions of the leaf become dry and scorched',
                'Leaves turn yellow -> brown -> dry',
                'Premature leaf fall (defoliation) occurs',
                'Disease spreads from lower leaves to upper canopy',
              ],
            ),
            
            const SizedBox(height: 16),
            Text('More info', style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              'Scientific name: Alternaria alternata (primary) / Cercospora jasminicola',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preventive Measures',
          style: AppTextStyles.headingMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        _buildBulletText('Maintain proper spacing for good air circulation'),
        _buildBulletText('Prune regularly to avoid dense canopy'),
        _buildBulletText('Remove and destroy infected leaves immediately'),
        _buildBulletText('Avoid water stagnation in the field'),
        _buildBulletText('Do not use overhead irrigation; water at plant base'),
        _buildBulletText('Irrigate in morning so leaves dry quickly'),
        _buildBulletText('Keep field clean and weed-free'),
        _buildBulletText('Avoid excess nitrogen fertilizers'),
        _buildBulletText('Apply balanced nutrients to strengthen plants'),
        _buildBulletText('Spray neem oil 2 ml per liter during early stage'),
        _buildBulletText('Apply bio-agents (Trichoderma viride, Pseudomonas fluorescens)'),
        _buildBulletText('Take preventive action during humid and rainy weather'),
      ],
    );
  }

  Widget _buildWhatCausedItSection() {
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
        _buildBulletText('Caused by fungal pathogens Alternaria and Cercospora'),
        _buildBulletText('Fungi survive in infected plant debris and soil'),
        _buildBulletText('High humidity and continuous leaf wetness favor infection'),
        _buildBulletText('Frequent rainfall or overhead irrigation spreads spores'),
        _buildBulletText('Dense plant canopy reduces air circulation'),
      ],
    );
  }

  Widget _buildTreatmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organic Treatment',
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildTreatmentCard(
              title: 'Trichoderma viride',
              icon: Icons.eco,
              color: const Color(0xFFEFF5CA), // pale lime green
              type: 'Bio-fungicide',
              use: 'Preventive',
              dose: '2-4 g/L',
              benefit: 'Controls fungus, improves soil',
            ),
            _buildTreatmentCard(
              title: 'Pseudomonas fluorescens',
              icon: Icons.eco_outlined,
              color: const Color(0xFFEFF5CA),
              type: 'Bio-bacterium',
              use: 'Preventive + Curative',
              dose: '2-3 g/L',
              benefit: 'Boosts plant immunity',
            ),
            _buildTreatmentCard(
              title: 'Neem Oil',
              icon: Icons.wb_sunny_outlined,
              color: const Color(0xFFF9F6CA), // pale yellow
              type: 'Botanical',
              use: 'Early control',
              dose: '2 ml/L',
              benefit: 'Suppresses fungal growth',
            ),
            _buildTreatmentCard(
              title: 'NSKE (Neem Seed)',
              icon: Icons.water_drop_outlined,
              color: const Color(0xFFF9F6CA),
              type: 'Botanical extract',
              use: 'Preventive',
              dose: '5% solution',
              benefit: 'Reduces infection',
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        Text(
          'Chemical Treatment',
          style: AppTextStyles.headingLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildTreatmentCard(
              title: 'Mancozeb 75% WP',
              icon: Icons.science_outlined,
              color: const Color(0xFFE3F2FD), // pale blue for chemical
              type: 'Fungicide',
              use: 'Preventive',
              dose: '2-2.5 g/L',
              benefit: 'Broad-spectrum control',
            ),
            _buildTreatmentCard(
              title: 'Propiconazole 25% EC',
              icon: Icons.science,
              color: const Color(0xFFE3F2FD),
              type: 'Systemic Fungicide',
              use: 'Curative',
              dose: '1 ml/L',
              benefit: 'Stops fungal spread quickly',
            ),
            _buildTreatmentCard(
              title: 'Carbendazim 50% WP',
              icon: Icons.science_outlined,
              color: const Color(0xFFE3F2FD),
              type: 'Systemic Fungicide',
              use: 'Curative',
              dose: '1 g/L',
              benefit: 'High disease action',
            ),
            _buildTreatmentCard(
              title: 'Copper Oxychloride',
              icon: Icons.science_outlined,
              color: const Color(0xFFE3F2FD),
              type: 'Contact Fungicide',
              use: 'Preventive',
              dose: '3 g/L',
              benefit: 'Protects leaf surfaces',
            ),
          ],
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
