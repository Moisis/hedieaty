import 'package:flutter_test/flutter_test.dart';

import 'package:hedieaty/data/models/friend.dart';


void main() {
  group('Friend Model Tests', () {
    test('Friend toJson should convert to Map correctly', () {
      // Arrange
      final friend = Friend(
        UserId: '001',
        FriendId: '002',
      );

      // Act
      final friendJson = friend.toJson();

      // Assert
      expect(friendJson, {
        'UserId': '001',
        'FriendId': '002',
      });
    });

    test('Friend fromJson should create Friend object correctly', () {
      // Arrange
      final json = {
        'UserId': '003',
        'FriendId': '004',
      };

      // Act
      final friend = Friend.fromJson(json);

      // Assert
      expect(friend.UserId, '003');
      expect(friend.FriendId, '004');
    });

    test('Friend fromJson should handle dynamic Map correctly', () {
      // Arrange
      final dynamicJson = {
        'UserId': '005',
        'FriendId': '006',
      };

      // Act
      final friend = Friend.fromJson(dynamicJson);

      // Assert
      expect(friend.UserId, '005');
      expect(friend.FriendId, '006');
    });
  });
}
