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

  // Future<void> addFriend(FriendEntity friend) async {
  //   final friendModel = Friend(
  //     UserId: friend.UserId,
  //     FriendId: friend.FriendId,
  //   );
  //
  //   final friendModel2 = Friend(
  //     UserId: friend.FriendId,
  //     FriendId: friend.UserId,
  //   );
  //
  //   // Check if the user already exists in Firebase
  //   final existingFriend = await firebaseDataSource.getFriendById(friend.FriendId);
  //   if (existingFriend != null) {
  //     print("Friend already exists, skipping insert.");
  //     return; // Friend already exists, skip adding.
  //   }
  //
  // }


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


    // Check if the user already exists in Firebase
    // final existingFriend = await firebaseDataSource.getFriendById(friend.FriendId);
    // if (existingFriend != null) {
    //   print("Friend already exists, skipping insert.");
    //   return; // Friend already exists, skip adding.
    // }

    await firebaseDataSource.addFriend(friendModel);
    // await firebaseDataSource.addFriend(friendModel2);
    await sqliteDataSource.addFriend(friendModel);
    await sqliteDataSource.addFriend(friendModel2);
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
      print("aaFriend: ${friend.UserId}, ${friend.FriendId}");
    }

    return friends.map((friend) => FriendEntity(
      UserId: friend.UserId,
      FriendId: friend.FriendId,
    )).toList();

  }

  // Future<void> syncFriends() async {
  //   final users = await firebaseDataSource.getFriendsStream().first;
  //   for (var user in users) {
  //     // Check if the user already exists locally before adding
  //     final existingUser = await sqliteDataSource.getFriends(user.FriendId);
  //
  //     if (existingUser == null) {
  //       await sqliteDataSource.addFriend(user);
  //     } else {
  //       await sqliteDataSource.updateFriend(user);
  //     }
  //   }
  // }



  @override
  Future<void> syncFriends() async {
    firebaseDataSource.getFriendsStream().listen((users) async {
      for (var user in users) {
        // Check if the user already exists locally before adding
        final existingUser = await sqliteDataSource.getFriendById(user.UserId);

        if (existingUser == null) {
          await sqliteDataSource.addFriend(user);
        }else{
          await sqliteDataSource.updateFriend(user);
        }
      }
    });
  }

  @override
  Future<List<FriendEntity>> getFriendsById(String id) async {

    print("Getting friends for user $id");
    final friends = await sqliteDataSource.getFriends(id);
    print("Got friends from SQLite: ${friends.first.UserId}");
    for (var friend in friends) {
      print("Friend: ${friend.UserId}, ${friend.FriendId}");
    }

    print("Getting friends for user $id");
    print("Got friends from Firebase: ${
        friends.map((friend) => FriendEntity(
          UserId: friend.UserId,
          FriendId: friend.FriendId,
        )).toList()}");

    return friends.map((friend) => FriendEntity(
      UserId: friend.UserId,
      FriendId: friend.FriendId,
    )).toList();
  }


}