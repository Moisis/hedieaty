import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/data/models/event.dart';


class FirebaseEventDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Events');

  // Stream<List<Event>> getEventsStream() {
  //   return dbRef.onValue.map((event) {
  //     final data = event.snapshot.value as Map<dynamic, dynamic>;
  //     return data.entries
  //         .map((entry) => Event.fromJson(Map<String, dynamic>.from(entry.value)))
  //         .toList();
  //   });
  // }
  Stream<List<Event>> getEventsStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data is Map<dynamic, dynamic>) {
        // Handle the case where data is a Map
        return data.entries
            .map((entry) => Event.fromJson(Map<String, dynamic>.from(entry.value)))
            .toList();
      } else if (data is List) {
        // Handle the case where data is a List
        return data
            .where((element) => element != null) // Filter out null entries
            .map((element) => Event.fromJson(Map<String, dynamic>.from(element)))
            .toList();
      } else {
        return []; // Return an empty list if the data is neither a Map nor a List
      }
    });
  }


  Future<void> addEvent(Event event) async {
    await dbRef.child(event.EventId).set(event.toJson());
  }

  Future<void> updateEvent(Event event) async {
    await dbRef.child(event.EventId).update(event.toJson());
  }

  Future<void> deleteEvent(String id) async {
    await dbRef.child(id).remove();
  }

  Future<Event?> getEventById(String id) async {
    final snapshot = await dbRef.child(id).get();
    if (!snapshot.exists) return null;
    return Event.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

  Future<List<Event>> getEvents() async {
    final snapshot = await dbRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Event.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList();
  }
}
