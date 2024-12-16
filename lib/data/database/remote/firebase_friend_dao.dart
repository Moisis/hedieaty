import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/data/models/friend.dart';


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




  Stream<List<Friend>> getFriendsStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value;

      // Print the raw data for debugging
      print('Data: $data');

      // Safely handle null and ensure `data` is a map
      if (data is Map) {
        // Flatten the data into a list of friends
        return data.entries
            .expand((entry) {
          // Filter only entries where the value is a map (friend data)
          if (entry.value is Map) {
            final friendsMap = Map<String, dynamic>.from(entry.value);
            return friendsMap.entries.map((friendEntry) {
              try {
                final friendData = Map<String, dynamic>.from(friendEntry.value);
                // Extract friend data (FriendId, UserId)
                final friendId = friendData['FriendId'] ?? '';
                final userId = friendData['UserId'] ?? '';

                // Ensure both FriendId and UserId are not null and create Friend object
                if (friendId.isNotEmpty && userId.isNotEmpty) {
                  return Friend(
                    FriendId: friendId,
                    UserId: userId,
                  );
                }
              } catch (e) {
                print("Error parsing friend data: $e");
              }
              return null; // Return null if there's an error or missing data
            }).where((friend) => friend != null); // Only include non-null friends
          }
          return <Friend>[]; // Return an empty list if not a valid map
        })
            .where((friend) => friend != null) // Ensure we don't include any nulls here
            .map((friend) => friend!) // Cast non-null entries
            .toList(); // Flatten the results into a single list
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

  Future<void> deleteFriend(Friend friend) async {
    await dbRef.child(friend.UserId).child(friend.FriendId).remove();
  }

  Future<Friend?> getFriendById(String id) async {
    final snapshot = await dbRef.child(id).get();
    if (!snapshot.exists) return null;
    return Friend.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

}
