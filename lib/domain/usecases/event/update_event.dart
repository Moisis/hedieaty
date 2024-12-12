import '../../entities/user_entity.dart';
import '../../repos_head/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}
