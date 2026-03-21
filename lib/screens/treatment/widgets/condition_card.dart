import 'package:flutter/material.dart';
import '../models/disease_details_model.dart';

class ConditionCard extends StatelessWidget {
  final FavourableCondition condition;

  const ConditionCard({
    super.key,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: condition.backgroundColor.withAlpha(38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: condition.backgroundColor.withAlpha(77),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(204),
              shape: BoxShape.circle,
            ),
            child: Icon(
              condition.icon,
              color: condition.backgroundColor.withAlpha(204),
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            condition.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            condition.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
