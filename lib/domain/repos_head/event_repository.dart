import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getEvents();
  Stream<List<EventEntity>> getStreamEvents();
  Future<List<EventEntity>> getEventsbyUserId(String id) ;
  Future<EventEntity?> getEventById(String id);
  Future<void> addEvent(EventEntity event);
  Future<void> updateEvent(EventEntity event);
  Future<void> deleteEvent(String id);
  Future<void> syncEvents();
}
