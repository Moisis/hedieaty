

import 'package:hedieaty/domain/entities/event_entity.dart';

import 'package:hedieaty/domain/repos_head/event_repository.dart';



class GetStreamEvent {
  final EventRepository repository;

  GetStreamEvent(this.repository);

  Stream<List<EventEntity>> call( ) {
    return repository.getStreamEvents();
  }
}