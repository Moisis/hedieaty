
class Friend {
  int userId; // Composite Key
  int friendId; // Composite Key

  Friend({
    required this.userId,
    required this.friendId,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserID': userId,
      'FriendID': friendId,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      userId: map['UserID'],
      friendId: map['FriendID'],
    );
  }
}
