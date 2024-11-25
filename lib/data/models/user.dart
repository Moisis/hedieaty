

class User {
  int? userId; // Nullable for auto-incrementing ID
  String userName;
  String userEmail;
  String? userPrefs;
  String userPhone;

  User({
    this.userId,
    required this.userName,
    required this.userEmail,
    this.userPrefs,
    required this.userPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': userId,
      'UserName': userName,
      'UserEmail': userEmail,
      'UserPrefs': userPrefs,
      'UserPhone': userPhone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['UserId'],
      userName: map['UserName'],
      userEmail: map['UserEmail'],
      userPrefs: map['UserPrefs'],
      userPhone: map['UserPhone'],
    );
  }
}
