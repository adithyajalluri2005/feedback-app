import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback_enums.dart';

class FeedbackItem {
  final String id;
  final String userId;
  final String userEmail;
  final FeedbackType type;
  final String message;
  final String platform;
  final FeedbackStatus status;
  final AppSource source;
  final DateTime createdAt;

  const FeedbackItem({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.type,
    required this.message,
    required this.platform,
    required this.status,
    required this.source,
    required this.createdAt,
  });

  factory FeedbackItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackItem(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      type: FeedbackType.fromWire(data['type'] as String?),
      message: data['message'] as String? ?? '',
      platform: data['platform'] as String? ?? '',
      status: FeedbackStatus.fromWire(data['status'] as String?),
      source: AppSource.fromWire(data['source'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  FeedbackItem copyWith({FeedbackStatus? status}) {
    return FeedbackItem(
      id: id,
      userId: userId,
      userEmail: userEmail,
      type: type,
      message: message,
      platform: platform,
      status: status ?? this.status,
      source: source,
      createdAt: createdAt,
    );
  }
}
