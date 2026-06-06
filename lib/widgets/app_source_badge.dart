import 'package:flutter/material.dart';
import '../models/feedback_enums.dart';

class AppSourceBadge extends StatelessWidget {
  final AppSource source;
  const AppSourceBadge({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    final color = source.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(source.icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            source.label,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
