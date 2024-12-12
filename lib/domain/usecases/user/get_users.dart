import '../../entities/user_entity.dart';
import '../../repos_head/user_repository.dart';



class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.getUsers();
  }
}
