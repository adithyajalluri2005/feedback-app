import 'package:flutter/material.dart';
import '../models/feedback_enums.dart';

/// Colour-coded badge for a feedback [FeedbackStatus].
///
/// Set [dense] for the compact chip used in list cards; leave it false for the
/// larger outlined badge used on the detail screen.
class StatusBadge extends StatelessWidget {
  final FeedbackStatus status;
  final bool dense;

  const StatusBadge({super.key, required this.status, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: dense
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dense ? 0.15 : 0.2),
        borderRadius: BorderRadius.circular(dense ? 12 : 20),
        border:
            dense ? null : Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: dense ? 11 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
