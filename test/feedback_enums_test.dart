import 'package:feedback_app/models/feedback_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackType.fromWire', () {
    test('parses known wire values', () {
      expect(FeedbackType.fromWire('bug'), FeedbackType.bug);
      expect(FeedbackType.fromWire('feature'), FeedbackType.feature);
      expect(FeedbackType.fromWire('general'), FeedbackType.general);
    });

    test('defaults to general for unknown/null', () {
      expect(FeedbackType.fromWire('nonsense'), FeedbackType.general);
      expect(FeedbackType.fromWire(null), FeedbackType.general);
    });
  });

  group('FeedbackStatus.fromWire', () {
    test('parses known wire values', () {
      expect(FeedbackStatus.fromWire('new'), FeedbackStatus.newStatus);
      expect(FeedbackStatus.fromWire('reviewed'), FeedbackStatus.reviewed);
      expect(FeedbackStatus.fromWire('resolved'), FeedbackStatus.resolved);
    });

    test('defaults to new for unknown/null', () {
      expect(FeedbackStatus.fromWire('nonsense'), FeedbackStatus.newStatus);
      expect(FeedbackStatus.fromWire(null), FeedbackStatus.newStatus);
    });

    test('wire round-trips through the enum', () {
      for (final s in FeedbackStatus.values) {
        expect(FeedbackStatus.fromWire(s.wire), s);
      }
    });
  });
}
