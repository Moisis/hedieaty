import 'package:hedieaty/domain/entities/user_entity.dart';

import '../../repos_head/user_repository.dart';

class GetUserByPhone {
  final UserRepository userRepository;

  GetUserByPhone(this.userRepository);

  Future<UserEntity> call(String phone) async {
    return await userRepository.getUserByPhone(phone);
  }
}