import 'package:flutter/material.dart';
import '../models/feedback_enums.dart';

class TypeBadge extends StatelessWidget {
  final FeedbackType type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final color = type.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
