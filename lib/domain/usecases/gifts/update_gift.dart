import 'package:hedieaty/domain/entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class UpdateGift {
  final GiftRepository repository;

  UpdateGift(this.repository);

  Future<void> call(GiftEntity gift) async {
    return await repository.updateGift(gift);
  }
}
