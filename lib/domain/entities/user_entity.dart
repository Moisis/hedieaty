import 'package:hedieaty/data/models/user.dart';

class UserEntity extends UserModel {

  int? UserEventsNo ;


  // UserEntity({
  //   required this.UserId,
  //   required this.UserName,
  //   required this.UserEmail,
  //   required this.UserPass,
  //   this.UserPrefs,
  //   required this.UserPhone,
  //   this.UserEventsNo
  // });

  UserEntity({
    required super.UserId,
    required super.UserName,
    required super.UserEmail,
    required super.UserPass,
    super.UserPrefs,
    required super.UserPhone,
    this.UserEventsNo
  }) ;

}


