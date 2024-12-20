import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/data/models/gift.dart';


void main() {
  group('Gift Model Tests', () {
    test('Gift toJson should convert to Map correctly', () {
      // Arrange
      final gift = Gift(
        GiftId: '101',
        GiftName: 'Smartwatch',
        GiftDescription: 'A premium smartwatch with health tracking features.',
        GiftPrice: 299.99,
        GiftCat: 'Electronics',
        GiftStatus: 'Available',
        GiftEventId: '202',
      );

      // Act
      final giftJson = gift.toJson();

      // Assert
      expect(giftJson, {
        'GiftId': '101',
        'GiftName': 'Smartwatch',
        'GiftDescription': 'A premium smartwatch with health tracking features.',
        'GiftPrice': 299.99,
        'GiftCat': 'Electronics',
        'GiftStatus': 'Available',
        'GiftEventId': '202',
      });
    });

    test('Gift fromJson should create Gift object correctly', () {
      // Arrange
      final json = {
        'GiftId': '102',
        'GiftName': 'Coffee Maker',
        'GiftDescription': 'A high-quality coffee maker with customizable settings.',
        'GiftPrice': 89.99,
        'GiftCat': 'Kitchen',
        'GiftStatus': 'Pledged',
        'GiftEventId': '203',
      };

      // Act
      final gift = Gift.fromJson(json);

      // Assert
      expect(gift.GiftId, '102');
      expect(gift.GiftName, 'Coffee Maker');
      expect(gift.GiftDescription, 'A high-quality coffee maker with customizable settings.');
      expect(gift.GiftPrice, 89.99);
      expect(gift.GiftCat, 'Kitchen');
      expect(gift.GiftStatus, 'Pledged');
      expect(gift.GiftEventId, '203');
    });

    test('Gift fromJson should handle missing or null fields with defaults', () {
      // Arrange
      final json = {
        'GiftId': '103',
        'GiftName': "BOOKS",
        'GiftDescription': "hARRY POTTER",
        'GiftPrice': 50.0,
        'GiftCat': "OTHER",
        'GiftStatus': 'Available',
        'GiftEventId': '204',
      };

      // Act
      final gift = Gift.fromJson(json);

      // Assert
      expect(gift.GiftId, '103');
      expect(gift.GiftName, 'BOOKS');
      expect(gift.GiftDescription, 'hARRY POTTER');
      expect(gift.GiftPrice, 50.0);
      expect(gift.GiftCat, 'OTHER');
      expect(gift.GiftStatus, 'Available');
      expect(gift.GiftEventId, '204');
    });
  });
}
