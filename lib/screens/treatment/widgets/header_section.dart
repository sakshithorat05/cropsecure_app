import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final String cropName;
  final String diseaseName; // Expected "Leaf Blight (Jhusa Rog)"
  final String severity;
  final String detectionTime;

  const HeaderSection({
    super.key,
    required this.cropName,
    required this.diseaseName,
    required this.severity,
    required this.detectionTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                diseaseName, // "Leaf Blight (Jhusa Rog)"
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.alertYellow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                severity,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.grass, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              cropName, // "Jasmine"
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 24),
            const Icon(Icons.access_time, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              detectionTime, // "Detected 2 hours ago"
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
