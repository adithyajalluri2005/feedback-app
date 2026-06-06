import 'package:flutter/material.dart';

/// Which app the feedback was submitted from. Wire values match the `source`
/// field stored in Firestore (user_app / vendor_app).
enum AppSource {
  userApp('user_app', 'User App', Color(0xFF3498DB), Icons.person_outline),
  vendorApp('vendor_app', 'Vendor App', Color(0xFFE67E22), Icons.store_outlined),
  unknown('unknown', 'Unknown', Color(0xFF7F8C8D), Icons.device_unknown_outlined);

  const AppSource(this.wire, this.label, this.color, this.icon);

  final String wire;
  final String label;
  final Color color;
  final IconData icon;

  static AppSource fromWire(String? value) => values.firstWhere(
        (s) => s.wire == value,
        orElse: () => AppSource.unknown,
      );
}

/// Type of feedback a user submitted. Wire values match the `type` field
/// stored in Firestore (bug / feature / general).
enum FeedbackType {
  bug('bug', 'Bug', Color(0xFFE94560), Icons.bug_report_outlined),
  feature('feature', 'Feature', Color(0xFF3498DB), Icons.lightbulb_outline),
  general('general', 'General', Color(0xFF95A5A6), Icons.chat_bubble_outline);

  const FeedbackType(this.wire, this.label, this.color, this.icon);

  /// Value stored in Firestore.
  final String wire;

  /// Human-readable label shown in the UI.
  final String label;

  /// Badge accent colour.
  final Color color;

  /// Leading icon for the badge.
  final IconData icon;

  /// Parses a Firestore string, defaulting to [FeedbackType.general] for
  /// unknown/missing values.
  static FeedbackType fromWire(String? value) => values.firstWhere(
        (t) => t.wire == value,
        orElse: () => FeedbackType.general,
      );
}

/// Triage status of a feedback item. Wire values match the `status` field
/// stored in Firestore (new / reviewed / resolved).
enum FeedbackStatus {
  // `new` is a reserved word in Dart, so the enum constant is `newStatus`
  // while the wire value remains "new".
  newStatus('new', 'New', Color(0xFFE94560)),
  reviewed('reviewed', 'Reviewed', Color(0xFF533483)),
  resolved('resolved', 'Resolved', Color(0xFF2ECC71));

  const FeedbackStatus(this.wire, this.label, this.color);

  /// Value stored in Firestore.
  final String wire;

  /// Human-readable label shown in the UI.
  final String label;

  /// Badge accent colour.
  final Color color;

  /// Parses a Firestore string, defaulting to [FeedbackStatus.newStatus] for
  /// unknown/missing values.
  static FeedbackStatus fromWire(String? value) => values.firstWhere(
        (s) => s.wire == value,
        orElse: () => FeedbackStatus.newStatus,
      );
}
