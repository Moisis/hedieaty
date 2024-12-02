import 'package:firebase_database/firebase_database.dart';
import '../../models/gift.dart';

class FirebaseGiftDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Gifts');

  Stream<List<Gift>> getGiftsStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => Gift.fromJson(Map<String, dynamic>.from(entry.value)))
          .toList();
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

  // Future<List<Gift>> get() async {
  //   final snapshot = await dbRef.get();
  //   final data = snapshot.value as Map<dynamic, dynamic>;
  //   return data.entries
  //       .map((entry) => User.fromJson(Map<String, dynamic>.from(entry.value)))
  //       .toList();
  // }
}
