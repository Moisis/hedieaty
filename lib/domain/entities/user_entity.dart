import 'package:hedieaty/data/models/user.dart';

class UserEntity extends UserModel {

  int? UserEventsNo ;



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


