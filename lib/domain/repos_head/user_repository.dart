import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<void> addUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String id);
  Future<void> syncUsers();

  Future<void>loginUser(String email, String password);
  Future<void>registerUser(String email, String password);
  Future<void>logoutUser();

  Future<UserEntity> getUserById(String id);
  Future<String> getUserAuthId();
}
