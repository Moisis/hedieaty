class UserEntity {
  final String UserId;
  final String UserName;
  final String UserEmail;
  final String UserPass;
  String? UserPrefs;
  final String UserPhone;


  UserEntity({
    required this.UserId,
    required this.UserName,
    required this.UserEmail,
    required this.UserPass,
    this.UserPrefs,
    required this.UserPhone,
  });
}
