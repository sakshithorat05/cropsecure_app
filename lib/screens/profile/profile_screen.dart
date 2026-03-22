import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/plot_provider.dart';
import '../../core/services/database_service.dart';
import '../../providers/locale_provider.dart';
import '../../core/localization/translation_extension.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final DatabaseService _db = DatabaseService();
  final String _tempUid = 'user_123';
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _db.getUserProfile(_tempUid);
  }

  @override
  Widget build(BuildContext context) {
    final activePlot = ref.watch(activePlotProvider);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          final userData = snapshot.data;
          final String fullName = userData?['name'] ?? 'Farmer';
          final String firstName = fullName.split(' ').first;
          final String userPhone = userData?['phone'] ?? '+91';

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Top Green Header
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 60, // Custom safe area padding
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.xl,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName, 
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 28,
                        )
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        userPhone, 
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        )
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // 2. Farm Details Card
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [AppColors.softShadow],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'profile'.tr(ref), 
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (activePlot != null)
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 2.5,
                            children: [
                              _buildDetailItem('Survey No', activePlot.surveyNo),
                              _buildDetailItem('Crop', activePlot.cropName),
                              _buildDetailItem('Variety', activePlot.variety),
                              _buildDetailItem('Land Size', '${activePlot.area} ${activePlot.unit}'),
                              _buildDetailItem('Location', activePlot.location),
                              _buildDetailItem('Season', activePlot.cropSeason ?? 'Not Set'),
                            ],
                          )
                        else
                          const Center(child: Text('No active plot selected')),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // 3. Settings Section
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [AppColors.softShadow],
                    ),
                    child: Column(
                      children: [
                        _buildSettingTile(
                          icon: Icons.history,
                          title: 'Farm History',
                          onTap: () => context.push('/profile/farm-history'),
                        ),
                        _buildDivider(),
                        _buildSettingTile(
                          icon: Icons.landscape_outlined,
                          title: 'Register New Plot',
                          onTap: () => context.push('/profile/register-plot'),
                        ),
                        _buildDivider(),
                        _buildSettingTile(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Purchase History',
                          onTap: () => context.push('/profile/purchase-inputs'),
                        ),
                        _buildDivider(),
                        _buildSettingTile(
                          icon: Icons.language,
                          title: 'language'.tr(ref),
                          onTap: () => _showLanguageDialog(context, ref),
                        ),
                        _buildDivider(),
                        _buildSettingTile(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingTile(
                          icon: Icons.security,
                          title: 'Privacy & Consent',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // 4. Logout Button
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/auth/login');
                      },
                      child: Text(
                        'Logout', 
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                        )
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Spacer for Bottom Bar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        }
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, indent: 50, color: AppColors.divider.withOpacity(0.5));

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen, size: 22),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      onTap: onTap,
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          )
        ),
        const SizedBox(height: 2),
        Text(
          value, 
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          )
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr(ref)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, ref, 'english'.tr(ref), 'en'),
            _buildLanguageOption(context, ref, 'hindi'.tr(ref), 'hi'),
            _buildLanguageOption(context, ref, 'tamil'.tr(ref), 'ta'),
            _buildLanguageOption(context, ref, 'marathi'.tr(ref), 'mr'),
            _buildLanguageOption(context, ref, 'kannada'.tr(ref), 'kn'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, WidgetRef ref, String label, String code) {
    final currentLocale = ref.watch(localeProvider);
    return ListTile(
      title: Text(label),
      trailing: currentLocale == code ? const Icon(Icons.check, color: AppColors.primaryGreen) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(code);
        Navigator.pop(context);
        // Force state refresh
        setState(() {
          _profileFuture = _db.getUserProfile(_tempUid);
        });
      },
    );
  }
}


