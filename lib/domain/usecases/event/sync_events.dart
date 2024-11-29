import 'package:hedieaty/domain/repos_head/event_repository.dart';



class SyncEvents {
  final EventRepository repository;

  SyncEvents(this.repository);

  Future<void> call() async {
    await repository.syncEvents();
  }
}
