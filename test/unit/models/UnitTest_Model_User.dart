import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/data/models/user.dart';


void main() {
  group('UserModel Tests', () {
    test('UserModel toJson should convert to Map correctly', () {
      // Arrange
      final user = UserModel(
        UserId: '001',
        UserName: 'John Doe',
        UserEmail: 'johndoe@example.com',
        UserPass: 'password123',
        UserPrefs: 'DarkMode',
        UserPhone: '+1234567890',
      );

      // Act
      final userJson = user.toJson();

      // Assert
      expect(userJson, {
        'UserId': '001',
        'UserName': 'John Doe',
        'UserEmail': 'johndoe@example.com',
        'UserPass': 'password123',
        'UserPrefs': 'DarkMode',
        'UserPhone': '+1234567890',
      });
    });

    test('UserModel fromJson should create UserModel object correctly', () {
      // Arrange
      final json = {
        'UserId': '002',
        'UserName': 'Jane Smith',
        'UserEmail': 'janesmith@example.com',
        'UserPass': 'securepass456',
        'UserPrefs': 'LightMode',
        'UserPhone': '+0987654321',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.UserId, '002');
      expect(user.UserName, 'Jane Smith');
      expect(user.UserEmail, 'janesmith@example.com');
      expect(user.UserPass, 'securepass456');
      expect(user.UserPrefs, 'LightMode');
      expect(user.UserPhone, '+0987654321');
    });

    test('UserModel fromJson should handle missing optional fields', () {
      // Arrange
      final json = {
        'UserId': '003',
        'UserName': 'Alice Brown',
        'UserEmail': 'alicebrown@example.com',
        'UserPass': 'mypassword789',
        'UserPhone': '+1122334455',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.UserId, '003');
      expect(user.UserName, 'Alice Brown');
      expect(user.UserEmail, 'alicebrown@example.com');
      expect(user.UserPass, 'mypassword789');
      expect(user.UserPrefs, null); // Optional field should be null if missing
      expect(user.UserPhone, '+1122334455');
    });
  });
}
