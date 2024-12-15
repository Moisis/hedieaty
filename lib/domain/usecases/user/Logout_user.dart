
import '../../repos_head/user_repository.dart';

class LogoutUser {
  final UserRepository userRepository;

  LogoutUser(this.userRepository);

  Future<void> call() async {
    await userRepository.logoutUser();
  }
}