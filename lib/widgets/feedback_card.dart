import 'package:flutter/material.dart';
import '../models/feedback_enums.dart';
import '../models/feedback_item.dart';
import 'app_source_badge.dart';
import 'status_badge.dart';
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
          child: Builder(builder: (context) {
            final onSurface = Theme.of(context).colorScheme.onSurface;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TypeBadge(type: item.type),
                    const SizedBox(width: 6),
                    if (item.source != AppSource.unknown)
                      AppSourceBadge(source: item.source),
                    const Spacer(),
                    StatusBadge(status: item.status, dense: true),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.userEmail,
                  style: TextStyle(
                    fontSize: 13,
                    color: onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: onSurface,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.phone_android,
                        size: 13, color: onSurface.withValues(alpha: 0.38)),
                    const SizedBox(width: 4),
                    Text(
                      item.platform,
                      style: TextStyle(
                          fontSize: 12, color: onSurface.withValues(alpha: 0.38)),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time,
                        size: 13, color: onSurface.withValues(alpha: 0.38)),
                    const SizedBox(width: 4),
                    Text(
                      _timeAgo(item.createdAt),
                      style: TextStyle(
                          fontSize: 12, color: onSurface.withValues(alpha: 0.38)),
                    ),
                  ],
                ),
              ],
            );
          }),
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
