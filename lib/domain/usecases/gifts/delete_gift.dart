import 'package:hedieaty/domain/entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class DeleteGift {
  final GiftRepository repository;

  DeleteGift(this.repository);

  Future<void> call(GiftEntity gift) async {
    return await repository.deleteGift(gift);
  }
}
