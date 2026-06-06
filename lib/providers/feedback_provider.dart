import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feedback_enums.dart';
import '../models/feedback_item.dart';

/// Currently selected type filter. `null` means "All".
final selectedFilterProvider = StateProvider<FeedbackType?>((ref) => null);

/// Currently selected app source filter. `null` means "All".
final selectedSourceFilterProvider = StateProvider<AppSource?>((ref) => null);

final feedbackStreamProvider = StreamProvider<List<FeedbackItem>>((ref) {
  final query = FirebaseFirestore.instance
      .collection('feedback')
      .orderBy('createdAt', descending: true);

  return query.snapshots().map(
        (snap) => snap.docs.map(FeedbackItem.fromDoc).toList(),
      );
});

/// Live stream of a single feedback document by id. Used by the detail screen
/// so it stays in sync after a status update and works on deep-link/refresh
/// when no item was passed via `extra`. Emits `null` if the doc is missing.
final feedbackByIdProvider =
    StreamProvider.family<FeedbackItem?, String>((ref, id) {
  return FirebaseFirestore.instance
      .collection('feedback')
      .doc(id)
      .snapshots()
      .map((doc) => doc.exists ? FeedbackItem.fromDoc(doc) : null);
});

final filteredFeedbackProvider = Provider<AsyncValue<List<FeedbackItem>>>((ref) {
  final typeFilter = ref.watch(selectedFilterProvider);
  final sourceFilter = ref.watch(selectedSourceFilterProvider);
  final all = ref.watch(feedbackStreamProvider);

  return all.whenData((items) {
    var result = items;
    if (typeFilter != null) result = result.where((f) => f.type == typeFilter).toList();
    if (sourceFilter != null) result = result.where((f) => f.source == sourceFilter).toList();
    return result;
  });
});

final statsProvider = Provider<AsyncValue<Map<FeedbackStatus, int>>>((ref) {
  final all = ref.watch(feedbackStreamProvider);
  return all.whenData((items) => {
        for (final status in FeedbackStatus.values)
          status: items.where((f) => f.status == status).length,
      });
});

final appSourceStatsProvider = Provider<AsyncValue<Map<AppSource, int>>>((ref) {
  final all = ref.watch(feedbackStreamProvider);
  return all.whenData((items) => {
        AppSource.userApp: items.where((f) => f.source == AppSource.userApp).length,
        AppSource.vendorApp: items.where((f) => f.source == AppSource.vendorApp).length,
      });
});

Future<void> updateFeedbackStatus(String id, FeedbackStatus status) async {
  await FirebaseFirestore.instance
      .collection('feedback')
      .doc(id)
      .update({'status': status.wire});
}
