import 'package:hedieaty/domain/entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class GetGiftsEvent {

  final GiftRepository repository;

  GetGiftsEvent(this.repository);

  Future<List<GiftEntity>> call(String eventId) async {
    return await repository.getGiftsListbyEventId(eventId);
  }

}