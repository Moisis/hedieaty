import 'package:hedieaty/domain/entities/gift_entity.dart';
import '../../repos_head/gift_repoitory.dart';

class AddGift {
  final GiftRepository repository;

  AddGift(this.repository);

  Future<void> call(GiftEntity gift) async {
    return await repository.addGift(gift);
  }
}
