import '../../repos_head/user_repository.dart';

class SyncUsers {
  final UserRepository repository;

  SyncUsers(this.repository);

  Future<void> call() async {
    await repository.syncUsers();
  }
}
