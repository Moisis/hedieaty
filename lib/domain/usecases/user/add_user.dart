import '../../entities/user_entity.dart';
import '../../repos_head/user_repository.dart';

class AddUser {
  final UserRepository repository;

  AddUser(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.addUser(user);
  }
}
