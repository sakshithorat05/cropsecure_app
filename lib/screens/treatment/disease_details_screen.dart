import 'package:flutter/material.dart';
import 'models/disease_details_model.dart';
import 'widgets/info_row.dart';
import 'widgets/stage_card.dart';
import 'widgets/condition_card.dart';
import 'widgets/section_header.dart'; // Reusing from previous screen

class DiseaseDetailsScreen extends StatelessWidget {
  final DiseaseDetailsModel data;

  const DiseaseDetailsScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Disease Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroSection(context),
                  const SizedBox(height: 24),
                  
                  const SectionHeader(title: 'Scientific Classification'),
                  _buildClassificationCard(context),
                  const SizedBox(height: 24),
                  
                  const SectionHeader(title: 'How to Identify?'),
                  _buildIdentificationList(context),
                  const SizedBox(height: 24),
                  
                  const SectionHeader(title: 'Favourable Conditions'),
                  _buildConditionsList(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 500;

        List<Widget> children = [
          SizedBox(
            width: isWideScreen ? (MediaQuery.of(context).size.width * 0.5) : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is ${data.diseaseName}?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
          ),
          if (isWideScreen) const SizedBox(width: 24) else const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isWideScreen
                ? SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.3),
                    child: _buildImageNode(),
                  )
                : _buildImageNode(),
          ),
        ];

        return isWideScreen
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: children)
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
      },
    );
  }

  Widget _buildImageNode() {
    return Semantics(
      label: 'Image of infected leaves',
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.spa, size: 64, color: Colors.green.shade200), // Placeholder for NetworkImage
      ),
    );
  }

  Widget _buildClassificationCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InfoRow(label: 'Disease', value: data.diseaseName),
            const Divider(),
            InfoRow(label: 'Crop Affected', value: data.cropAffected),
            const Divider(),
            InfoRow(label: 'Disease Type', value: data.diseaseType),
            const Divider(),
            InfoRow(label: 'Causal Organism', value: data.causalOrganism),
            const Divider(),
            InfoRow(label: 'Affected Plant Part', value: data.affectedPlantPart),
            const Divider(),
            InfoRow(label: 'Primary Spread', value: data.primarySpread),
            const Divider(),
            InfoRow(label: 'Severity Level', value: data.severityLevel),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentificationList(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
        
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: crossAxisCount == 2 ? 1.8 : 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: data.identifyStages.length,
          itemBuilder: (context, index) {
            return StageCard(stage: data.identifyStages[index]);
          },
        );
      },
    );
  }

  Widget _buildConditionsList(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.favourableConditions.length,
        itemBuilder: (context, index) {
          return ConditionCard(condition: data.favourableConditions[index]);
        },
      ),
    );
  }
}
