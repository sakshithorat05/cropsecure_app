import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TipsCard extends StatelessWidget {
  final String title;
  final List<String> tips;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const TipsCard({
    super.key,
    this.title = 'Farmer Tips',
    required this.tips,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (iconColor ?? Colors.orange).withAlpha(50)),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: iconColor ?? Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor ?? Colors.orange,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => _buildBulletPoint(tip)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: iconColor ?? Colors.orange,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.orange.shade900,
                height: 1.4,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
