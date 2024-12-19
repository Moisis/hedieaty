



import '../../entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class GetPledgedGifts {
  final GiftRepository repository;

  GetPledgedGifts(this.repository);

  Future<List<GiftEntity>?> call(String userid) async {
    return await repository.getPledgedGifts(userid);
  }
}