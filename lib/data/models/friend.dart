class Friend {
  final String UserId;
  final String FriendId;
  Friend({
    required  this.UserId,
    required this.FriendId,
  });


  factory Friend.fromJson(Map<dynamic, dynamic> json) {
    return Friend(
      UserId: json['UserId']  ,
      FriendId: json['FriendId'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': UserId,
      'FriendId': FriendId
    };
  }
}
