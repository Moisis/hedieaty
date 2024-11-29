import '../../domain/entities/user_entity.dart';

class User extends UserEntity {
  User({
    required super.UserId,
    required super.UserName,
    required super.UserEmail,
    required super.UserPrefs,
    required super.UserPhone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      UserId: json['UserId'],
      UserName: json['UserName'],
      UserEmail: json['UserEmail'],
      UserPrefs: json['UserPrefs'],
      UserPhone: json['UserPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': UserId,
      'UserName': UserName,
      'UserEmail': UserEmail,
      'UserPrefs': UserPrefs,
      'UserPhone': UserPhone,
    };
  }
}
