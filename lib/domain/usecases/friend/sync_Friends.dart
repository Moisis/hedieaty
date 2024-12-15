
import '../../repos_head/friend_repository.dart';

class SyncFriends {
  final FriendRepository repository;

  SyncFriends(this.repository);

  Future<void> call() async {
    await repository.syncFriends();
  }
}
