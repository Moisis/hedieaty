import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/data/models/friend.dart';
import '../../models/gift.dart';

class FirebaseFriendDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Friends');

  Stream<List<Friend>> getFriendsStreamById(String userId) {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value;
      print('Data: $data');

      // Safely handle null and non-map values
      if (data is Map<dynamic, dynamic>) {
        return data.entries
            .map((entry) => Friend.fromJson(Map<String, dynamic>.from(entry.value)))
            .where((friend) => friend.UserId == userId) // Filter by userId
            .toList();
      } else {
        // Return an empty list if data is null or not a Map
        return <Friend>[];
      }
    });
  }

  Stream<List<Friend>> getFriendsStream( ) {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value;
      print('Data: $data');

      // Safely handle null and non-map values
      if (data is Map<dynamic, dynamic>) {
        return data.entries
            .map((entry) => Friend.fromJson(Map<String, dynamic>.from(entry.value)))
            .toList();
      } else {
        // Return an empty list if data is null or not a Map
        return <Friend>[];
      }
    });
  }


  Future<void> addFriend(Friend friend) async {
    await dbRef.child(friend.UserId).child(friend.FriendId).set(friend.toJson());
  }


  Future<void> updateFriend(Friend friend) async {
    await dbRef.child(friend.UserId).update(friend.toJson());
  }

  Future<void> deleteFriend(String id) async {
    await dbRef.child(id).remove();
  }

  Future<Friend?> getFriendById(String id) async {
    final snapshot = await dbRef.child(id).get();
    if (!snapshot.exists) return null;
    return Friend.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

}
