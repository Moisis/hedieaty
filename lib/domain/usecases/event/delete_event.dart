import 'package:hedieaty/domain/repos_head/event_repository.dart';



class DeleteEvent {
  final EventRepository repository;

  DeleteEvent(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteEvent(id);
  }
}
