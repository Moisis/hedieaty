import '../../domain/entities/friend_entity.dart';
import '../../domain/repos_head/friend_repository.dart';
import '../database/local/sqlite_friend_dao.dart';
import '../database/remote/firebase_friend_dao.dart';
import '../models/friend.dart';

class FriendRepositoryImpl implements FriendRepository {
  final SQLiteFriendDataSource sqliteDataSource;
  final FirebaseFriendDataSource firebaseDataSource;

  FriendRepositoryImpl({
    required this.sqliteDataSource,
    required this.firebaseDataSource,
  });

  @override
  Future<void> addFriend(FriendEntity friend) async {
    final friendModel = Friend(
      UserId: friend.UserId,
      FriendId: friend.FriendId,
    );

    // Check if the user already exists in Firebase
    final existingFriend = await firebaseDataSource.getFriendById(friend.FriendId);
    if (existingFriend != null) {
      print("Friend already exists, skipping insert.");
      return; // Friend already exists, skip adding.
    }

    await firebaseDataSource.addFriend(friendModel);
    await sqliteDataSource.addFriend(friendModel);
  }

  @override
  Future<void> deleteFriend(FriendEntity friend) async {
    final friendModel = Friend(
      UserId: friend.UserId,
      FriendId: friend.FriendId,
    );

    await firebaseDataSource.deleteFriend(friend.FriendId);
    await sqliteDataSource.deleteFriend(friend.FriendId);
  }

  @override
  Future<List<FriendEntity>> getFriends(String userId) async {

    print("Getting friends for user $userId");
    final friends = await sqliteDataSource.getFriends(userId);
    print("Got friends from SQLite: $friends");
    for (var friend in friends) {
      print("Friend: ${friend.UserId}, ${friend.FriendId}");
    }

    return friends.map((friend) => FriendEntity(
      UserId: friend.UserId,
      FriendId: friend.FriendId,
    )).toList();

  }


}