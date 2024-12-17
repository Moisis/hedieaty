
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/repos_head/event_repository.dart';

class UpdateEvent {
  final EventRepository repository;

  UpdateEvent(this.repository);

  Future<void> call(EventEntity event) async {
    return await repository.updateEvent(event);
  }
}
