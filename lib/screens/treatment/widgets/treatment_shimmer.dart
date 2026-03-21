import 'package:flutter/material.dart';

class TreatmentShimmer extends StatefulWidget {
  const TreatmentShimmer({super.key});

  @override
  State<TreatmentShimmer> createState() => _TreatmentShimmerState();
}

class _TreatmentShimmerState extends State<TreatmentShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       duration: const Duration(milliseconds: 1500), 
       vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(double.infinity, 100, 16),
                const SizedBox(height: 24),
                _buildSkeletonBox(150, 24, 4),
                const SizedBox(height: 16),
                _buildSkeletonBox(double.infinity, 80, 16),
                const SizedBox(height: 24),
                _buildSkeletonBox(200, 24, 4),
                const SizedBox(height: 16),
                _buildSkeletonBox(double.infinity, 120, 16),
                const SizedBox(height: 16),
                _buildSkeletonBox(double.infinity, 120, 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonBox(double width, double height, double borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
