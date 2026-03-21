import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder user details — replace with real user data source when available
    const String userName = 'John Doe';
    const String userPhone = '+91 98765 43210';

    return Scaffold(
      body: SafeArea(
        child: Column(
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


