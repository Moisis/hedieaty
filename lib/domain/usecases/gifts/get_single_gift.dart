import 'package:hedieaty/domain/entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class GetGifts {
  final GiftRepository repository;

  GetGifts(this.repository);

  Future<GiftEntity?> call(String giftid) async {
    return await repository.getGiftById(giftid);
  }
}
