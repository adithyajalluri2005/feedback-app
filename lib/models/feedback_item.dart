import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackItem {
  final String id;
  final String userId;
  final String userEmail;
  final String type;
  final String message;
  final String platform;
  final String status;
  final DateTime createdAt;

  const FeedbackItem({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.type,
    required this.message,
    required this.platform,
    required this.status,
    required this.createdAt,
  });

  factory FeedbackItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackItem(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      type: data['type'] as String? ?? 'general',
      message: data['message'] as String? ?? '',
      platform: data['platform'] as String? ?? '',
      status: data['status'] as String? ?? 'new',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  FeedbackItem copyWith({String? status}) {
    return FeedbackItem(
      id: id,
      userId: userId,
      userEmail: userEmail,
      type: type,
      message: message,
      platform: platform,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
