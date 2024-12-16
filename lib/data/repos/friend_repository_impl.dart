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

    final friendModel2 = Friend(
      UserId: friend.FriendId,
      FriendId: friend.UserId,
    );

    await firebaseDataSource.addFriend(friendModel);
    await firebaseDataSource.addFriend(friendModel2);
    await sqliteDataSource.addFriend(friendModel);

  }

  @override
  Future<void> deleteFriend(FriendEntity friend) async {
    final friendModel = Friend(
      UserId: friend.UserId,
      FriendId: friend.FriendId,
    );

    final friendModel2 = Friend(
      UserId: friend.FriendId,
      FriendId: friend.UserId,
    );

    await firebaseDataSource.deleteFriend(friendModel);
    await firebaseDataSource.deleteFriend(friendModel2);
    await sqliteDataSource.deleteFriend(friendModel);
  }


  @override
  Future<void> syncFriends() async {
    // Listen to the stream of friends from Firebase
    firebaseDataSource.getFriendsStream().listen((friends) async {
      // Iterate over each Friend in the list
      for (var friend in friends) {
        for (var friend in friends) {
          print("Friend: ${friend.UserId}, ${friend.FriendId}");

          // Check if the friend already exists locally before adding
          final existingFriend = await sqliteDataSource.getFriendById(friend.UserId, friend.FriendId);

          // If the friend doesn't exist locally, add it
          if (existingFriend == null) {
            print("Adding friend to SQLite: ${friend.UserId}, ${friend.FriendId}");
            await sqliteDataSource.addFriend(friend);
          } else {
            print("Updating friend in SQLite: ${friend.UserId}, ${friend
                .FriendId}");
            // Update existing friend in local SQLite
            await sqliteDataSource.updateFriend(friend);
          }
        }


      }
    });
  }


  @override
  Future<List<FriendEntity>> getFriendsById(String id) async {
    print("Getting friends for user $id");
    final friends = await sqliteDataSource.getFriends(id);
    print("Got friends from SQLite: ${friends?.first.UserId}");
    for (var friend in friends!) {
      print("Friend: ${friend.UserId}, ${friend.FriendId}");
    }

    print("Getting friends for user $id");
    print("Got friends from Firebase: ${friends.map((friend) => FriendEntity(
          UserId: friend.UserId,
          FriendId: friend.FriendId,
        )).toList()}");

    return friends
        .map((friend) => FriendEntity(
              UserId: friend.UserId,
              FriendId: friend.FriendId,
            ))
        .toList();
  }
}
