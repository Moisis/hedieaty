import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/repos_head/event_repository.dart';



class GetEvents {
  final EventRepository repository;

  GetEvents(this.repository);

  Future<List<EventEntity>> call() async {
    return await repository.getEvents();
  }
}
