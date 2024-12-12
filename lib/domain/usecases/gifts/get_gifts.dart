import 'package:hedieaty/domain/entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class GetGifts {
  final GiftRepository repository;

  GetGifts(this.repository);

  Future<List<GiftEntity>> call( ) async {
    return await repository.getGifts();
  }
}
