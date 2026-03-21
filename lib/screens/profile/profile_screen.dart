import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../core/services/database_service.dart';

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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // Ensure light background even in dark mode
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          final userData = snapshot.data;
          final String userName = userData?['name'] ?? 'Farmer';
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
                        userName, 
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
                          'Farm Details', 
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: AppSpacing.md),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 2.5,
                          children: [
                            _buildDetailItem('Variety', 'Jasmine Sambangi'),
                            _buildDetailItem('Location', 'Theni, TN'),
                            _buildDetailItem('Land Size', '1.2 Hectares'),
                            _buildDetailItem('Irrigation', 'Drip / Well'),
                          ],
                        ),
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
                          icon: Icons.shopping_bag_outlined,
                          title: 'Purchase History',
                          onTap: () => context.push('/profile/purchase-inputs'),
                        ),
                        _buildDivider(),
                        _buildSettingTile(
                          icon: Icons.language,
                          title: 'Language',
                          onTap: () {},
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
}


