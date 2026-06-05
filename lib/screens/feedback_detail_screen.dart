import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/feedback_item.dart';
import '../providers/feedback_provider.dart';
import '../widgets/type_badge.dart';

class FeedbackDetailScreen extends ConsumerStatefulWidget {
  final FeedbackItem item;
  const FeedbackDetailScreen({super.key, required this.item});

  @override
  ConsumerState<FeedbackDetailScreen> createState() =>
      _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends ConsumerState<FeedbackDetailScreen> {
  late String _status;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _status = widget.item.status;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() { _updating = true; });
    try {
      await updateFeedbackStatus(widget.item.id, newStatus);
      if (mounted) setState(() { _status = newStatus; });
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
      if (mounted) setState(() { _updating = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final cardColor = Theme.of(context).cardColor;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(item.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Vyapari Admin'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TypeBadge(type: item.type),
                const Spacer(),
                _StatusBadge(status: _status),
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
                  _MetaRow(icon: Icons.person_outline, label: 'User ID', value: item.userId),
                  _MetaRow(icon: Icons.email_outlined, label: 'Email', value: item.userEmail),
                  _MetaRow(icon: Icons.phone_android, label: 'Platform', value: item.platform),
                  _MetaRow(icon: Icons.access_time, label: 'Submitted', value: dateStr),
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
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 10),
                  _updating
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: _status,
                            dropdownColor: cardColor,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: const [
                              DropdownMenuItem(
                                  value: 'new', child: Text('New')),
                              DropdownMenuItem(
                                  value: 'reviewed', child: Text('Reviewed')),
                              DropdownMenuItem(
                                  value: 'resolved', child: Text('Resolved')),
                            ],
                            onChanged: (v) {
                              if (v != null && v != _status) _updateStatus(v);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
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
            style: GoogleFonts.poppins(
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

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'reviewed' => (const Color(0xFF533483), 'Reviewed'),
      'resolved' => (const Color(0xFF2ECC71), 'Resolved'),
      _ => (const Color(0xFFE94560), 'New'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
