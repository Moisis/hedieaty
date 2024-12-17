

import '../../repos_head/user_repository.dart';

class GetUserAuthId {
  final UserRepository userRepository;

  GetUserAuthId(this.userRepository);

  Future<String> call() async {
    return await userRepository.getUserAuthId();
  }
}