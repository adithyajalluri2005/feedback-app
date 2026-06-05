import 'package:flutter/material.dart';
import '../models/feedback_item.dart';
import 'type_badge.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackItem item;
  final VoidCallback onTap;

  const FeedbackCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TypeBadge(type: item.type),
                  const Spacer(),
                  _StatusChip(status: item.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.userEmail,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                item.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone_android,
                      size: 13, color: Colors.white38),
                  const SizedBox(width: 4),
                  Text(
                    item.platform,
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 13, color: Colors.white38),
                  const SizedBox(width: 4),
                  Text(
                    _timeAgo(item.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'reviewed' => (const Color(0xFF533483), 'Reviewed'),
      'resolved' => (const Color(0xFF2ECC71), 'Resolved'),
      _ => (const Color(0xFFE94560), 'New'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
