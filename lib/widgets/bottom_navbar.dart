import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Custom persistent bottom navbar with a centered Scan FAB.
class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onScanTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Standard Bottom Navigation Bar
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.divider, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.local_florist_outlined),
                activeIcon: Icon(Icons.local_florist),
                label: 'My Crop',
              ),
              BottomNavigationBarItem(
                // Empty space for the center FAB
                icon: Icon(Icons.medical_services_outlined),
                activeIcon: Icon(Icons.medical_services),
                label: 'Treatment',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined),
                activeIcon: Icon(Icons.storefront),
                label: 'Market',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
        
        // Custom Centered FAB overlapping the nav bar
        Positioned(
          bottom: 24, // Lift it slightly above the bar
          child: FloatingActionButton(
            heroTag: 'scanFab',
            backgroundColor: AppColors.primaryGreen,
            elevation: 4,
            shape: const CircleBorder(),
            onPressed: onScanTap,
            child: const Icon(
              Icons.camera_alt,
              color: AppColors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
