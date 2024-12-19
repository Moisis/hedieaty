

import 'package:hedieaty/domain/entities/event_entity.dart';

import '../../repos_head/event_repository.dart';

class GetSingleEvent {
  final EventRepository eventRepository;

  GetSingleEvent(this.eventRepository);

  Future<EventEntity?> call(String id) async {
    return await eventRepository.getEventById(id);
  }
}