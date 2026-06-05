import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feedback_item.dart';

final selectedFilterProvider = StateProvider<String>((ref) => 'all');

final feedbackStreamProvider = StreamProvider<List<FeedbackItem>>((ref) {
  final query = FirebaseFirestore.instance
      .collection('feedback')
      .orderBy('createdAt', descending: true);

  return query.snapshots().map(
    (snap) => snap.docs.map(FeedbackItem.fromDoc).toList(),
  );
});

final filteredFeedbackProvider = Provider<AsyncValue<List<FeedbackItem>>>((ref) {
  final filter = ref.watch(selectedFilterProvider);
  final all = ref.watch(feedbackStreamProvider);

  return all.whenData((items) {
    if (filter == 'all') return items;
    return items.where((f) => f.type == filter).toList();
  });
});

final statsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final all = ref.watch(feedbackStreamProvider);
  return all.whenData((items) => {
    'new': items.where((f) => f.status == 'new').length,
    'reviewed': items.where((f) => f.status == 'reviewed').length,
    'resolved': items.where((f) => f.status == 'resolved').length,
  });
});

Future<void> updateFeedbackStatus(String id, String status) async {
  await FirebaseFirestore.instance
      .collection('feedback')
      .doc(id)
      .update({'status': status});
}
