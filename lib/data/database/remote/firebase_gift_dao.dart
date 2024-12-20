import 'package:firebase_database/firebase_database.dart';
import '../../models/gift.dart';

class FirebaseGiftDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Gifts');



  Stream<List<Gift>> getGiftsStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data is Map<dynamic, dynamic>) {
        // Handle the case where data is a Map
        return data.entries
            .map((entry) => Gift.fromJson(Map<String, dynamic>.from(entry.value)))
            .toList();
      } else if (data is List) {
        // Handle the case where data is a List
        return data
            .where((element) => element != null) // Filter out null entries
            .map((element) => Gift.fromJson(Map<String, dynamic>.from(element)))
            .toList();
      } else {
        return []; // Return an empty list if the data is neither a Map nor a List
      }
    });
  }


  Future<void> addGift(Gift gift) async {
    await dbRef.child(gift.GiftId).set(gift.toJson());
  }

  Future<void> updateGift(Gift gift) async {
    await dbRef.child(gift.GiftId).update(gift.toJson());
  }

  Future<void> deleteGift(String id) async {
    await dbRef.child(id).remove();
  }

  Future<Gift?> getGiftById(String id) async {
    final snapshot = await dbRef.child(id).get();
    if (!snapshot.exists) return null;
    return Gift.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }


  Stream<List<Gift>> getGiftsStreambyEventId(String eventId) {
    return dbRef.onValue.map((event) {
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;

        if (data is Map<dynamic, dynamic>) {
          // Handle the case where data is a Map
          return data.entries
              .map((entry) => Gift.fromJson(Map<String, dynamic>.from(entry.value)))
              .where((gift) => gift.GiftEventId == eventId) // Filter gifts
              .toList();
        } else if (data is List) {
          // Handle the case where data is a List
          return data
              .where((element) => element != null) // Filter out null entries
              .map((element) => Gift.fromJson(Map<String, dynamic>.from(element)))
              .where((gift) => gift.GiftEventId == eventId) // Filter gifts
              .toList();
        }
      }
      return [];
    });
  }

  Future<void> deleteGiftsEvent(String Eventid) async {
    final dataSnapshot = await dbRef.get();
    if (!dataSnapshot.exists) return;

    final data = dataSnapshot.value;
    if (data is Map<dynamic, dynamic>) {
      for (final entry in data.entries) {
        final gift = Gift.fromJson(Map<String, dynamic>.from(entry.value));
        if (gift.GiftEventId == Eventid) {
          await dbRef.child(gift.GiftId).remove();
        }
      }
    } else if (data is List) {
      for (final element in data) {
        if (element == null) continue;
        final gift = Gift.fromJson(Map<String, dynamic>.from(element));
        if (gift.GiftEventId == Eventid) {
          await dbRef.child(gift.GiftId).remove();
        }
      }
    }
  }


}
