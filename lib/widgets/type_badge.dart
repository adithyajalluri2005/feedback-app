import 'package:flutter/material.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (type) {
      'bug' => (const Color(0xFFE94560), Icons.bug_report_outlined, 'Bug'),
      'feature' => (const Color(0xFF3498DB), Icons.lightbulb_outline, 'Feature'),
      _ => (const Color(0xFF95A5A6), Icons.chat_bubble_outline, 'General'),
    };
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
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
