import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/data/models/event.dart';


class FirebaseEventDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Events');

  Stream<List<Event>> getEventsStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => Event.fromJson(Map<String, dynamic>.from(entry.value)))
          .toList();
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
