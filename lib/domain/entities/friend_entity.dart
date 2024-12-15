import 'package:hedieaty/data/models/friend.dart';

class FriendEntity extends Friend{


   String? UserName;
   String? UserEmail;
   String? UserPass;
  String? UserPrefs;
   String? UserPhone;
  int? UserEventsNo ;

   FriendEntity({
     required super.UserId,
     required super.FriendId,
      this.UserName,
      this.UserEmail,
      this.UserPass,
      this.UserPrefs,
      this.UserPhone,
     this.UserEventsNo
   }) ;
}