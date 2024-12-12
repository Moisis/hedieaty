

import '../../domain/entities/friend_entity.dart';

class Friend extends FriendEntity {

  Friend({
    required super.UserId,
    required super.FriendId,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      UserId: json['UserId'], FriendId: json['FriendId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': UserId,
      'FriendId': FriendId
    };
  }




}

