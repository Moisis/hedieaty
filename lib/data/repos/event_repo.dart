


import '../database/DatabaseHelper.dart';
import '../models/event.dart';


class EventRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertEvent(Event event) async {
    final db = await _dbHelper.database;
    return await db.insert('Events', event.toMap());
  }

  Future<int> updateEvent(Event event) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Events',
      event.toMap(),
      where: 'EventId = ?',
      whereArgs: [event.eventId],
    );
  }

  Future<int> deleteEvent(int eventId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Events',
      where: 'EventId = ?',
      whereArgs: [eventId],
    );
  }

  Future<List<Event>> fetchAllEvents() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('Events');
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<Event?> fetchEventById(int eventId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Events',
      where: 'EventId = ?',
      whereArgs: [eventId],
    );
    if (result.isNotEmpty) {
      return Event.fromMap(result.first);
    }
    return null;
  }
}
