import '../entities/friend_entity.dart';


abstract class FriendRepository {
  Future<void> addFriend(FriendEntity user);
  Future<void> deleteFriend(FriendEntity user);
  Future<List<FriendEntity>> getFriendsById(String id);
  Future<void> syncFriends();
  Future<List<FriendEntity>> getFriends(String id);

}
