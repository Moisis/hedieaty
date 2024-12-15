

import 'package:hedieaty/domain/entities/user_entity.dart';

import '../../repos_head/user_repository.dart';

class GetUserById {
  final UserRepository userRepository;

  GetUserById(this.userRepository);

  Future<UserEntity> call(String id) async {
    return await userRepository.getUserById(id);
  }
}