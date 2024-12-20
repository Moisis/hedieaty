import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/data/models/event.dart';

void main() {
  group('Event Model Tests', () {
    test('Event toJson should convert to Map correctly', () {
      // Arrange
      final event = Event(
        EventId: '1',
        EventName: 'Flutter Conference',
        EventDate: '2024-01-01',
        EventLocation: 'San Francisco',
        EventImageUrl: 'https://example.com/image.png',
        EventDescription: 'A conference about Flutter',
        UserId: '123',
      );

      // Act
      final eventJson = event.toJson();

      // Assert
      expect(eventJson, {
        'EventId': '1',
        'EventName': 'Flutter Conference',
        'EventDate': '2024-01-01',
        'EventLocation': 'San Francisco',
        'EventImageUrl': 'https://example.com/image.png',
        'EventDescription': 'A conference about Flutter',
        'UserId': '123',
      });
    });

    test('Event fromJson should create Event object correctly', () {
      // Arrange
      final json = {
        'EventId': '2',
        'EventName': 'Dart Workshop',
        'EventDate': '2024-02-01',
        'EventLocation': 'New York',
        'EventImageUrl': 'https://example.com/dart.png',
        'EventDescription': 'A workshop about Dart',
        'UserId': '456',
      };

      // Act
      final event = Event.fromJson(json);

      // Assert
      expect(event.EventId, '2');
      expect(event.EventName, 'Dart Workshop');
      expect(event.EventDate, '2024-02-01');
      expect(event.EventLocation, 'New York');
      expect(event.EventImageUrl, 'https://example.com/dart.png');
      expect(event.EventDescription, 'A workshop about Dart');
      expect(event.UserId, '456');
    });
  });
}
