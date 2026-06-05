import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/feedback_enums.dart';
import '../models/feedback_item.dart';
import '../providers/feedback_provider.dart';
import '../widgets/status_badge.dart';
import '../widgets/type_badge.dart';

class FeedbackDetailScreen extends ConsumerStatefulWidget {
  final String id;

  /// Item passed via `extra` when navigating from the list. Used for an
  /// instant first paint; the screen still subscribes to the live document so
  /// it stays in sync (and works when [initial] is null on a deep-link).
  final FeedbackItem? initial;

  const FeedbackDetailScreen({super.key, required this.id, this.initial});

  @override
  ConsumerState<FeedbackDetailScreen> createState() =>
      _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends ConsumerState<FeedbackDetailScreen> {
  bool _updating = false;

  Future<void> _updateStatus(FeedbackStatus newStatus) async {
    setState(() => _updating = true);
    try {
      await updateFeedbackStatus(widget.id, newStatus);
      // No local state to set: the feedbackByIdProvider stream pushes the
      // updated document and the UI rebuilds automatically.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(feedbackByIdProvider(widget.id));
    // Prefer live data; fall back to the item passed via `extra` while the
    // stream is loading so there's no flash of a spinner on the fast path.
    final item = async.valueOrNull ?? widget.initial;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Vyapari Admin'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: switch ((item, async)) {
        // We have something to show (live or initial).
        (final FeedbackItem i, _) => _DetailBody(
            item: i,
            updating: _updating,
            onStatusChanged: _updateStatus,
          ),
        // No initial item and the stream resolved to null → doc is missing.
        (null, AsyncData()) => const _CenteredMessage(
            'This feedback item no longer exists.',
          ),
        (null, AsyncError(:final error)) => _CenteredMessage('Error: $error'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final FeedbackItem item;
  final bool updating;
  final ValueChanged<FeedbackStatus> onStatusChanged;

  const _DetailBody({
    required this.item,
    required this.updating,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(item.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TypeBadge(type: item.type),
              const Spacer(),
              StatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Message',
            child: Text(
              item.message,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Details',
            child: Column(
              children: [
                _MetaRow(
                    icon: Icons.person_outline,
                    label: 'User ID',
                    value: item.userId),
                _MetaRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: item.userEmail),
                _MetaRow(
                    icon: Icons.phone_android,
                    label: 'Platform',
                    value: item.platform),
                _MetaRow(
                    icon: Icons.access_time,
                    label: 'Submitted',
                    value: dateStr),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Update Status',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 10),
                updating
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<FeedbackStatus>(
                          value: item.status,
                          dropdownColor: cardColor,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.arrow_drop_down),
                          items: [
                            for (final s in FeedbackStatus.values)
                              DropdownMenuItem(
                                value: s,
                                child: Text(s.label),
                              ),
                          ],
                          onChanged: (v) {
                            if (v != null && v != item.status) {
                              onStatusChanged(v);
                            }
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String text;
  const _CenteredMessage(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, color: Color(0xDEFFFFFF))),
          ),
        ],
      ),
    );
  }
}
