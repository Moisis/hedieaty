import 'package:hedieaty/data/database/local/sqlite_event_dao.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/repos_head/event_repository.dart';




import '../database/remote/firebase_event_dao.dart';
import '../models/event.dart';


class EventRepositoryImpl implements EventRepository {
  final SQLiteEventDataSource sqliteDataSource;
  final FirebaseEventDataSource firebaseDataSource;

  EventRepositoryImpl({
    required this.sqliteDataSource,
    required this.firebaseDataSource,
  });

  @override
  Future<void> addEvent(EventEntity event) async {
    final eventModel = Event(
      EventId: event.EventId,
      EventName: event.EventName,
      EventDate: event.EventDate,
      EventLocation: event.EventLocation,
      EventDescription: event.EventDescription,
      UserId : event.UserId
    );
    // Check if the user already exists in SQLite
    final existingUser = await sqliteDataSource.getEventById(event.EventId);
    if (existingUser != null) {
      print("User already exists in SQLite, skipping insert.");
      return; // User already exists, don't add again.
    }

    // Check if the user already exists in Firebase
    final firebaseUser = await firebaseDataSource.getEventById(event.EventId);
    if (firebaseUser != null) {
      print("User already exists in Firebase, skipping insert.");
      return; // User already exists in Firebase, don't add again.
    }

    await sqliteDataSource.addEvent(eventModel);
    await firebaseDataSource.addEvent(eventModel);

  }

  @override
  Future<void> deleteEvent(String id) async {
    await sqliteDataSource.deleteEvent(id);
    await firebaseDataSource.deleteEvent(id);
  }

  @override
  Future<List<EventEntity>> getEvents() async {
    final events = await sqliteDataSource.getEvents();

    return events.map((event) => EventEntity(
        EventId: event.EventId,
        EventName: event.EventName,
        EventDate: event.EventDate,
        EventLocation: event.EventLocation,
        EventDescription: event.EventDescription,
        UserId: event.UserId
    )).toList();
  }

  @override
  Future<void> syncEvents() async {
    firebaseDataSource.getEventsStream().listen((events) async {
      for (var event in events) {
        // Check if the user already exists locally before adding
        final existingUser = await sqliteDataSource.getEventById(event.EventId);
        if (existingUser == null) {
          await sqliteDataSource.addEvent(event);
        }else{
          await sqliteDataSource.updateEvent(event);
        }
      }
    });
  }

  @override
  Future<void> updateEvent(EventEntity event) async {
    final eventModel = Event(
      EventId: event.EventId,
      EventName: event.EventName,
      EventDate: event.EventDate,
      EventLocation: event.EventLocation,
      EventDescription: event.EventDescription,
      UserId: event.UserId
    );
    await sqliteDataSource.updateEvent(eventModel);
    await firebaseDataSource.updateEvent(eventModel);
  }

  @override
  Future<List<EventEntity>> getEventsbyUserId(String id) {
    return getEvents().then((events) => events.where((event) => event.UserId == id).toList());
  }

}
