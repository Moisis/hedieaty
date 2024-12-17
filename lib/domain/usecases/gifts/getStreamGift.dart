
import 'package:hedieaty/domain/entities/gift_entity.dart';


import '../../repos_head/gift_repoitory.dart';

class GetStreamGift {
  final GiftRepository repository;

  GetStreamGift(this.repository);

  Stream<List<GiftEntity>> call(String eventId) {
    return repository.getStreamGift( eventId);
  }
}