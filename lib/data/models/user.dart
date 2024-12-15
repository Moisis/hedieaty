import '../../domain/entities/user_entity.dart';

class UserModel   {

  final String UserId;
  final String UserName;
  final String UserEmail;
  final String UserPass;
  String? UserPrefs;
  final String UserPhone;


  UserModel({
    required this.UserId,
    required this.UserName,
    required this.UserEmail,
    required this.UserPass,
    this.UserPrefs,
    required this.UserPhone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      UserId: json['UserId'],
      UserName: json['UserName'],
      UserEmail: json['UserEmail'],
      UserPass: json['UserPass'],
      UserPrefs: json['UserPrefs'],
      UserPhone: json['UserPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': UserId,
      'UserName': UserName,
      'UserEmail': UserEmail,
      'UserPass': UserPass,
      'UserPrefs': UserPrefs,
      'UserPhone': UserPhone,
    };
  }
}
