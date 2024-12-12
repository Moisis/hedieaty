

import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/repos_head/event_repository.dart';

class AddEvent {
  final EventRepository repository;

  AddEvent(this.repository);

  Future<void> call(EventEntity event) async {
    return await repository.addEvent(event);
  }
}
