import 'package:sqflite/sqflite.dart';

import '../../models/event.dart';
import 'SQLite.dart';

class SQLiteEventDataSource {

  late Database db;
  bool _isInitialized = false;

  Future<void> init() async {
    db = await DatabaseHelper().database; // Use DatabaseHelper to get the database instance
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<List<Event>> getEvents() async {
    await _ensureInitialized();
    final maps = await db.query('Events');
    return maps.map((map) => Event.fromJson(map)).toList();
  }

  Future<void> addEvent(Event event) async {
    await _ensureInitialized();
    await db.insert('Events', event.toJson());
  }

  Future<void> updateEvent(Event event) async {
    await _ensureInitialized();
    await db.update('Events', event.toJson(), where: 'EventId = ?', whereArgs: [event.EventId]);
  }

  Future<void> deleteEvent(String id) async {
    await _ensureInitialized();
    await db.delete('Events', where: 'EventId = ?', whereArgs: [id]);
  }

  Future<Event?> getEventById(String id) async {
    await _ensureInitialized();
    final maps = await db.query('Events', where: 'EventId = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Event.fromJson(maps.first);
  }
}