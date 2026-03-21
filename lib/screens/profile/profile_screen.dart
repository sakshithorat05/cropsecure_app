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
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            final userData = snapshot.data;
            final String userName = userData?['name'] ?? 'Farmer';
            final String userPhone = userData?['phone'] ?? '+91';

            return Column(
              children: [
                // Top green header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
                      const SizedBox(height: AppSpacing.sm),
                      Text(userPhone, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                    ],
                  ),
                ),


            const SizedBox(height: AppSpacing.lg),

            // Farm details card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Farm Details', style: AppTextStyles.headingMedium),
                      const SizedBox(height: AppSpacing.md),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        children: [
                          _buildDetailItem('Variety', 'Wheat'),
                          _buildDetailItem('Location', 'Pune, MH'),
                          _buildDetailItem('Land Size', '2.5 acres'),
                          _buildDetailItem('Irrigation', 'Drip'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Settings list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  ListTile(
                    title: Text('Language', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Notifications', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Offline Advisory', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Privacy & Consent', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Logout button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/auth/login');
                  },
                  child: Text('Logout', style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
                ),
              ),
            ),
              ],
            );
          }
        ),
      ),
    );
  }
}


Widget _buildDetailItem(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyles.labelMedium),
      const SizedBox(height: AppSpacing.xs),
      Text(value, style: AppTextStyles.bodyMedium),
    ],
  );
}


