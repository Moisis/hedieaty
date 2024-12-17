

import 'package:hedieaty/domain/repos_head/gift_repoitory.dart';

class SyncGifts {
  final GiftRepository repository;

  SyncGifts(this.repository);

  Future<void> call() async {
    await repository.syncGifts();
  }
}
