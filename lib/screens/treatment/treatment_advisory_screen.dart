import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

import '../../providers/treatment_provider.dart';
import '../../providers/plot_provider.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/header_section.dart';
import 'widgets/disease_card.dart';
import 'widgets/treatment_card.dart';
import 'widgets/risk_card.dart';
import 'widgets/section_header.dart';
import 'widgets/treatment_shimmer.dart';

class TreatmentAdvisoryScreen extends ConsumerWidget {
  const TreatmentAdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePlot = ref.watch(activePlotProvider);
    final String? cropName = activePlot?.cropName;

    return p.ChangeNotifierProvider(
      create: (_) => TreatmentProvider(cropName: cropName),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: p.Consumer<TreatmentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const SafeArea(child: TreatmentShimmer());
            }

            if (provider.errorMessage != null) {
              return SafeArea(child: _buildErrorState(context, provider));
            }

            if (provider.advisoryData == null) {
              return const SafeArea(child: Center(child: Text('No data available.')));
            }

            final data = provider.advisoryData!;

            return SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HeaderSection (green background)
                    Container(
                      width: double.infinity,
                      color: AppColors.primaryGreen,
                      // Extra bottom padding to allow the card to overlap gracefully
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 56),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Treatment Advisory',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Expert recommendations for your crop',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          HeaderSection(
                            cropName: data.cropName,
                            diseaseName: data.diseaseName,
                            severity: data.severity,
                            detectionTime: data.detectionTime,
                          ),
                        ],
                      ),
                    ),

                    // Transform.translate (overlap effect)
                    Transform.translate(
                      offset: const Offset(0, -32),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.lightBackground,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                          child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                // Disease Card
                                DiseaseCard(diseaseData: data.fullDiseaseDetails),
                                const SizedBox(height: 24),

                                // Recommended Section
                                const SectionHeader(
                                  title: 'Recommended Treatments',
                                  subtitle: 'Choose one option based on availability and preference',
                                ),

                                // Treatment Cards
                                ...data.treatments.map((t) => TreatmentCard(treatment: t)),

                                const SizedBox(height: 8),

                                // Grid Section
                                Builder(
                                  builder: (context) {
                                    final bool isWideScreen = MediaQuery.of(context).size.width > 600;
                                    return GridView.count(
                                      crossAxisCount: isWideScreen ? 2 : 1,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      childAspectRatio: isWideScreen ? 1.5 : 1.3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      children: [
                                        RiskCard(riskData: data.diseaseRiskToday),
                                        const PestsCard(),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, TreatmentProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Unknown error occurred.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refreshData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
