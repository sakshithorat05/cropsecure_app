import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/plot_provider.dart';
import '../../core/localization/translation_extension.dart';
import '../../providers/locale_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final DatabaseService _db = DatabaseService();
  final String _tempUid = 'user_123';
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _loadDashboardData();
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final profile = await _db.getUserProfile(_tempUid);
    final stats = await _db.getDashboardStats(_tempUid);
    final tasks = await _db.getUserReminders(_tempUid);
    final weather = await _db.getLatestWeather();
    return {
      'name': profile?['name'] ?? 'Farmer',
      'stats': stats,
      'tasks': tasks,
      'weather': weather,
    };
  }

  @override
  Widget build(BuildContext context) {
    final activePlot = ref.watch(activePlotProvider);
    final allPlots = ref.watch(plotsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          final data = snapshot.data;
          final String fullName = data?['name'] ?? 'Sakshi';
          final String firstName = fullName.split(' ').first;
          final List<Map<String, dynamic>> tasks = (data?['tasks'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
          final Map<String, dynamic>? weather = data?['weather'];
          final Map<String, dynamic> stats = data?['stats'] ?? {
            'totalScans': '0',
            'diseasesDetected': '0',
            'treatmentsApplied': '0',
            'recoveryRate': '92%',
          };

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Green Header Section
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, $firstName.',
                                  style: AppTextStyles.displayMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'today_task'.tr(ref),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                            // Plot Switcher
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.white.withOpacity(0.3)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  allPlots.whenData((plots) {
                                    _showPlotSwitcher(context, ref, plots);
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.landscape, color: AppColors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activePlot?.surveyNo ?? 'No Plot',
                                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'switch_plot'.tr(ref),
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withOpacity(0.8), fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.keyboard_arrow_down, color: AppColors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Current Active Plot Summary
                        if (activePlot != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: AppColors.white, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Active: ${activePlot.cropName} (${activePlot.variety}) - ${activePlot.area} ${activePlot.unit}',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.white, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        // Today's Tasks
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: tasks.isEmpty 
                              ? [ _buildTaskChip('no_tasks'.tr(ref)) ]
                              : tasks.map((task) => Padding(
                                  padding: const EdgeInsets.only(right: AppSpacing.md),
                                  child: _buildTaskChip(task['title'] ?? 'Task'),
                                )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // My Crop Card with overlap
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Transform.translate(
                      offset: const Offset(0, -30),
                      child: _buildMyCropCard(context, activePlot, weather),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Disease Risk Alert
                        _buildDiseaseRiskAlert(context, activePlot),
                        const SizedBox(height: AppSpacing.lg),

                        // What would you like to do? Section
                        _buildActionButtons(context),
                        const SizedBox(height: AppSpacing.lg),

                        // Your Farm at a Glance Section
                        _buildFarmAtGlance(context, stats),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Task Chip Widget
  Widget _buildTaskChip(String task) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.softShadow],
      ),
      child: Text(
        task,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }

  // My Crop Card with status
  Widget _buildMyCropCard(BuildContext context, Plot? plot, Map<String, dynamic>? weather) {
    if (plot == null) return const SizedBox.shrink();
    
    final bool isAtRisk = plot.status == 'At Risk';
    final String humidity = weather?['humidity']?.toString() ?? 'Normal';
    final String alertMsg = isAtRisk ? 'Scan needed immediately' : 'Everything looks stable';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Crop Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crop: ${plot.cropName}',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Variety: ${plot.variety}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Last Scan: ${plot.lastScan}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/crop-registration/${plot.id}'),
                      icon: const Icon(Icons.refresh, size: 14, color: AppColors.primaryGreen),
                      label: Text(
                        'Change Crop',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Status chips
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        isAtRisk ? 'Action' : 'Health',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryGreen,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      isAtRisk ? 'Scan/Treat Now' : 'Healthy Growth',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Humidity',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryGreen,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      humidity,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Risk Badge and Image Placeholder
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isAtRisk ? AppColors.alertYellow : AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAtRisk ? AppColors.warning : AppColors.primaryGreen,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  plot.status,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isAtRisk ? AppColors.warning : AppColors.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  color: AppColors.lightGreen,
                  child: Image.asset(
                    'assets/images/jasmine_crop.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.local_florist,
                          color: AppColors.primaryGreen,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Disease Risk Alert Card
  Widget _buildDiseaseRiskAlert(BuildContext context, Plot? plot) {
    if (plot == null) return const SizedBox.shrink();
    final bool isAtRisk = plot.status == 'At Risk';

    return Container(
      decoration: BoxDecoration(
        color: isAtRisk ? AppColors.alertYellow : AppColors.lightGreen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAtRisk ? AppColors.warning : AppColors.primaryGreen,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diseases Risk',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  isAtRisk ? 'High Alert' : 'No Risk',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isAtRisk ? 'High risk alert detected' : 'Everything looks stable',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (isAtRisk ? AppColors.warning : AppColors.primaryGreen).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAtRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline,
              color: isAtRisk ? AppColors.warning : AppColors.primaryGreen,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'what_would_you_do'.tr(ref),
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          children: [
            _buildActionButton(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Scan Crop\nNow',
              onTap: () => context.push('/home/scan'),
            ),
            _buildActionButton(
              context,
              icon: Icons.description_outlined,
              label: 'View\nAdvisory',
              onTap: () => context.go('/treatment'),
            ),
            _buildActionButton(
              context,
              icon: Icons.shopping_cart_outlined,
              label: 'Purchase\nInputs',
              onTap: () => context.go('/market'),
            ),
            _buildActionButton(
              context,
              icon: Icons.history_outlined,
              label: 'Farm\nHistory',
              onTap: () => context.go('/profile/farm-history'),
            ),
          ],
        ),
      ],
    );
  }

  // Individual Action Button
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppColors.softShadow],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your Farm at a Glance Section
  Widget _buildFarmAtGlance(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'farm_glance'.tr(ref),
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGlanceStatItem(
                label: 'Total scans',
                value: stats['totalScans'] ?? '0',
              ),
              _buildGlanceStatItem(
                label: 'Diseases\ndetected',
                value: stats['diseasesDetected'] ?? '0',
              ),
              _buildGlanceStatItem(
                label: 'Treatments\napplied',
                value: stats['treatmentsApplied'] ?? '0',
              ),
              _buildGlanceStatItem(
                label: 'Recovery\nrate',
                value: stats['recoveryRate'] ?? '92%',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Farm Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 150,
              color: AppColors.white.withOpacity(0.1),
              child: Image.asset(
                'assets/images/farm_overview.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.agriculture,
                      color: Colors.white,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Individual Glance Stat Item
  Widget _buildGlanceStatItem({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _showPlotSwitcher(BuildContext context, WidgetRef ref, List<Plot> plots) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Active Plot',
                style: AppTextStyles.headingSmall.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ...plots.map((plot) => ListTile(
                leading: const Icon(Icons.landscape, color: AppColors.primaryGreen),
                title: Text(plot.surveyNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${plot.cropName} (${plot.variety})'),
                trailing: ref.watch(activePlotProvider)?.id == plot.id 
                  ? const Icon(Icons.check_circle, color: AppColors.primaryGreen) 
                  : null,
                onTap: () {
                  ref.read(activePlotProvider.notifier).setActivePlot(plot);
                  Navigator.pop(context);
                },
              )).toList(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
