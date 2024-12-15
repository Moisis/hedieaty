import 'package:hedieaty/data/database/remote/firebase_auth.dart';

import '../../domain/repos_head/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../database/remote/firebase_user_dao.dart';
import '../database/local/sqlite_user_dao.dart';
import '../models/user.dart';

class UserRepositoryImpl implements UserRepository {
  final SQLiteUserDataSource sqliteDataSource;
  final FirebaseUserDataSource firebaseDataSource;
  final FirebaseAuthDataSource firebaseAuthDataSource;

  UserRepositoryImpl({
    required this.sqliteDataSource,
    required this.firebaseDataSource,
    required this.firebaseAuthDataSource,
  });

  @override
  Future<List<UserEntity>> getUsers() async {
    final users = await sqliteDataSource.getUsers();
    return users.map((user) => UserEntity(
      UserId: user.UserId,
      UserName: user.UserName,
      UserEmail: user.UserEmail,
      UserPass: user.UserPass,
      UserPrefs: user.UserPrefs,
      UserPhone: user.UserPhone,

    )).toList();
  }

  @override
  Future<void> addUser(UserEntity user) async {
    final userModel = UserModel(
      UserId: user.UserId,
      UserName: user.UserName,
      UserEmail: user.UserEmail,
      UserPass: user.UserPass,
      UserPrefs: user.UserPrefs,
      UserPhone: user.UserPhone,
    );

    // Check if the user already exists in SQLite
    final existingUser = await sqliteDataSource.getUserById(user.UserId);
    if (existingUser != null) {
      print("User already exists in SQLite, skipping insert.");
      return; // User already exists, don't add again.
    }

    // Check if the user already exists in Firebase
    final firebaseUser = await firebaseDataSource.getUserById(user.UserId);
    if (firebaseUser != null) {
      print("User already exists in Firebase, skipping insert.");
      return; // User already exists in Firebase, don't add again.
    }

    await sqliteDataSource.addUser(userModel);
    await firebaseDataSource.addUser(userModel);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userModel = UserModel(
      UserId: user.UserId,
      UserName: user.UserName,
      UserEmail: user.UserEmail,
      UserPass: user.UserPass,
      UserPrefs: user.UserPrefs,
      UserPhone: user.UserPhone,
    );
    await sqliteDataSource.updateUser(userModel);
    await firebaseDataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(String id) async {
    await sqliteDataSource.deleteUser(id);
    await firebaseDataSource.deleteUser(id);
  }

  @override
  Future<void> syncUsers() async {
    firebaseDataSource.getUsersStream().listen((users) async {
      for (var user in users) {
        // Check if the user already exists locally before adding
        final existingUser = await sqliteDataSource.getUserById(user.UserId);

        if (existingUser == null) {
          await sqliteDataSource.addUser(user);
        }else{
          await sqliteDataSource.updateUser(user);
        }
      }
    });
  }

  @override
  Future<void> loginUser(String email, String password) async {
    firebaseAuthDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> logoutUser() async {
    firebaseAuthDataSource.signOut();

  }

  // @override
  // Future<void> registerUser(UserModel user) async {
  //   // firebaseAuthDataSource.signUpWithEmailAndPassword(user., password);
  //   // String id =  await firebaseAuthDataSource.getUserAuthID();
  //   //
  //   // // Create a new user data
  //   // final userData = UserModel(
  //   //   UserId: uid,
  //   //   UserName: _controllername.text.trim(),
  //   //   UserEmail: _controlleremail.text.trim(),
  //   //   UserPass: _controllerPassword.text.trim(),
  //   //   UserPhone: _controllerPhone.value.text.trim(),
  //   // );
  //
  //
  // }


  @override
  Future<UserEntity> getUserById(String id) async {
    final usermodel = await sqliteDataSource.getUserById(id);

    return UserEntity(
      UserId: usermodel?.UserId ?? '',
      UserName: usermodel!.UserName,
      UserEmail: usermodel.UserEmail,
      UserPass: usermodel.UserPass,
      UserPrefs: usermodel.UserPrefs,
      UserPhone: usermodel.UserPhone,
      UserEventsNo: 0,
    );
  }

  @override
  Future<String> getUserAuthId() {
    // TODO: implement getUserAuthId
    throw UnimplementedError();
  }

  @override
  Future<void> registerUser(String email, String password) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }



}
