import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_spacing.dart';

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
    return {
      'name': profile?['name'] ?? 'Farmer',
      'stats': stats,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          final data = snapshot.data;
          final String userName = data?['name'] ?? 'Sakshi';
          final Map<String, dynamic> stats = data?['stats'] ?? {
            'totalScans': '0',
            'diseasesDetected': '0',
            'treatmentsApplied': '0',
            'recoveryRate': '0%',
          };

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Green Header Section
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
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
                                    'Welcome, $userName.',
                                    style: AppTextStyles.displayMedium.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Today\'s task',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.white.withAlpha(230),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [AppColors.softShadow],
                                ),
                                child: const Icon(
                                  Icons.wb_cloudy,
                                  color: AppColors.primaryGreen,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg),
                          // Today's Tasks
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildTaskChip('Spray scheduled 8 PM'),
                                SizedBox(width: AppSpacing.md),
                                _buildTaskChip('Reason after rainfall'),
                                SizedBox(width: AppSpacing.md),
                                _buildTaskChip('Fertilizer due tomorrow'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // My Crop Card with overlap
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Transform.translate(
                        offset: const Offset(0, -30),
                        child: _buildMyCropCard(context),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Disease Risk Alert
                          _buildDiseaseRiskAlert(context),
                          SizedBox(height: AppSpacing.lg),

                          // What would you like to do? Section
                          _buildActionButtons(context),
                          SizedBox(height: AppSpacing.lg),

                          // Your Farm at a Glance Section
                          _buildFarmAtGlance(context, stats),
                          SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  // Task Chip Widget
  Widget _buildTaskChip(String task) {
    return Container(
      padding: EdgeInsets.symmetric(
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
  Widget _buildMyCropCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Crop Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crop: Jasmine',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Variety: Sambangi',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Last Scan: Yesterday',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                // Status chips
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
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
                        'Needed',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryGreen,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Preventive spray\nin 24 hrs',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
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
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'High',
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
          SizedBox(width: AppSpacing.md),
          // Risk Badge and Image Placeholder
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.alertYellow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  'At Risk',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
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
  Widget _buildDiseaseRiskAlert(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.alertYellow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning,
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(AppSpacing.md),
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
                  'alert',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'High risk alert',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
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
          'What would you like to do?',
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
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
              onTap: () => context.go('/home/scan'),
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
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 28,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
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
            AppColors.primaryGreen.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Farm at a Glance',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppSpacing.md),
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
                value: '0%', // Placeholder for now
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          // Farm Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 150,
              color: AppColors.white.withAlpha(26),
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
        SizedBox(height: AppSpacing.xs),
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
}
