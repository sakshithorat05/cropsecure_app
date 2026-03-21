import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SafetyCard extends StatelessWidget {
  final String title;
  final List<String> instructions;

  const SafetyCard({
    super.key,
    this.title = 'Safety – Read Before Use',
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE), // Light red (AppColors.error with low alpha)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withAlpha(50)),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...instructions.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB71C1C), // Deep red
                          height: 1.4,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
