

import 'package:hedieaty/domain/entities/event_entity.dart';

import '../../repos_head/event_repository.dart';

class GetEventsbyUserId {

  final EventRepository repository;

  GetEventsbyUserId(this.repository);

  Future<List<EventEntity>> call(String UserId) async {
    return await repository.getEventsbyUserId(UserId);
  }


}