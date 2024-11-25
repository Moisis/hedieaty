import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/data/models/user.dart';
import 'package:hedieaty/data/models/event.dart';
import 'package:hedieaty/data/models/gift.dart';
import 'package:hedieaty/data/models/friend.dart';

void main() {
  group('User Model Tests', () {
    test('User toJson and fromJson', () {
      final user = User(
        userId: 1,
        userName: 'Alice',
        userEmail: 'alice@example.com',
        userPhone: '1234567890',
        userPrefs: 'Dark mode',
      );

      // Convert to JSON
      final userJson = user.toMap();
      expect(userJson, {
        'UserId': 1,
        'UserName': 'Alice',
        'UserEmail': 'alice@example.com',
        'UserPhone': '1234567890',
        'UserPrefs': 'Dark mode',
      });

      // Convert back to User object
      final newUser = User.fromMap(userJson);
      expect(newUser.userId, 1);
      expect(newUser.userName, 'Alice');
      expect(newUser.userEmail, 'alice@example.com');
      expect(newUser.userPhone, '1234567890');
      expect(newUser.userPrefs, 'Dark mode');
    });
  });

  group('Event Model Tests', () {
    test('Event toJson and fromJson', () {
      final event = Event(
        eventId: 1,
        eventName: 'Birthday Party',
        eventDate: '2024-12-25',
        eventLocation: 'Central Park',
        eventDescription: 'A fun birthday celebration',
        userId: 1,
      );

      // Convert to JSON
      final eventJson = event.toMap();
      expect(eventJson, {
        'EventId': 1,
        'EventName': 'Birthday Party',
        'EventDate': '2024-12-25',
        'EventLocation': 'Central Park',
        'EventDescription': 'A fun birthday celebration',
        'UserId': 1,
      });

      // Convert back to Event object
      final newEvent = Event.fromMap(eventJson);
      expect(newEvent.eventId, 1);
      expect(newEvent.eventName, 'Birthday Party');
      expect(newEvent.eventDate, '2024-12-25');
      expect(newEvent.eventLocation, 'Central Park');
      expect(newEvent.eventDescription, 'A fun birthday celebration');
      expect(newEvent.userId, 1);
    });
  });

  group('Gift Model Tests', () {
    test('Gift toJson and fromJson', () {
      final gift = Gift(
        giftId: 1,
        giftName: 'Watch',
        giftDescription: 'A stylish wristwatch',
        giftCat: 'Accessories',
        giftPrice: 199.99,
        giftStatus: 'Planned',
        giftEventId: 1,
      );

      // Convert to JSON
      final giftJson = gift.toMap();
      expect(giftJson, {
        'GiftId': 1,
        'GiftName': 'Watch',
        'GiftDescription': 'A stylish wristwatch',
        'GiftCat': 'Accessories',
        'GiftPrice': 199.99,
        'GiftStatus': 'Planned',
        'GiftEventId': 1,
      });

      // Convert back to Gift object
      final newGift = Gift.fromMap(giftJson);
      expect(newGift.giftId, 1);
      expect(newGift.giftName, 'Watch');
      expect(newGift.giftDescription, 'A stylish wristwatch');
      expect(newGift.giftCat, 'Accessories');
      expect(newGift.giftPrice, 199.99);
      expect(newGift.giftStatus, 'Planned');
      expect(newGift.giftEventId, 1);
    });
  });

  group('Friend Model Tests', () {
    test('Friend toJson and fromJson', () {
      final friend = Friend(
        userId: 1,
        friendId: 2,
      );

      // Convert to JSON
      final friendJson = friend.toMap();
      expect(friendJson, {
        'UserID': 1,
        'FriendID': 2,
      });

      // Convert back to Friend object
      final newFriend = Friend.fromMap(friendJson);
      expect(newFriend.userId, 1);
      expect(newFriend.friendId, 2);
    });
  });
}
