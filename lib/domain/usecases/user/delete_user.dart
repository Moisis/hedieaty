import '../../repos_head/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteUser(id);
  }
}
