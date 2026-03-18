import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Camera viewfinder overlay with animated corner brackets.
class ScanOverlay extends StatefulWidget {
  const ScanOverlay({super.key});

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Container(color: Colors.black.withValues(alpha: 0.5)),
        
        // Clear center area for viewfinder
        Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               ScaleTransition(
                 scale: _animation,
                 child: Container(
                   width: 250,
                   height: 250,
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: AppColors.primaryLight,
                       width: 2,
                     ),
                     borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                     color: Colors.transparent,
                   ),
                   // In a real app, this would use CustomPaint to draw the specific 4 corners instead of full border.
                 ),
               ),
               const SizedBox(height: AppSpacing.xl),
               const Text(
                 AppStrings.scanInstruction,
                 style: TextStyle(
                   color: AppColors.white,
                   fontSize: 16,
                   fontWeight: FontWeight.w500,
                 ),
               ),
             ],
          ),
        ),
      ],
    );
  }
}
