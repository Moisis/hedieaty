import 'package:hedieaty/domain/repos_head/user_repository.dart';
import 'package:flutter/material.dart';
import '../../data/database/remote/firebase_user_dao.dart';
import '../../data/database/local/sqlite_user_dao.dart';
import '../../data/repos/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';

import '../../domain/usecases/user/add_user.dart';
import '../../domain/usecases/user/delete_user.dart';

import '../../domain/usecases/user/get_users.dart';
import '../../domain/usecases/user/sync_users.dart';
import '../../domain/usecases/user/update_user.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late GetUsers getUsersUseCase;
  late AddUser addUserUseCase;
  late UpdateUser updateUserUseCase;
  late DeleteUser deleteUserUseCase;
  late SyncUsers syncUsersUseCase;

  @override
  void initState() {
    super.initState();

    final sqliteDataSource = SQLiteUserDataSource();
    final firebaseDataSource = FirebaseUserDataSource();
    final repository = UserRepositoryImpl(
      sqliteDataSource: sqliteDataSource,
      firebaseDataSource: firebaseDataSource,
    );

    getUsersUseCase = GetUsers(repository as UserRepository);
    addUserUseCase = AddUser(repository as UserRepository);
    updateUserUseCase = UpdateUser(repository as UserRepository);
    deleteUserUseCase = DeleteUser(repository as UserRepository);
    syncUsersUseCase = SyncUsers(repository as UserRepository);

    sqliteDataSource.init();
    syncUsersUseCase.call(); // Sync data initially when the app starts.
  }

  // Function to handle adding a user
  Future<void> _addUser() async {
    final newUser = UserEntity(
      UserId: DateTime.now().millisecondsSinceEpoch.toString(),
      UserName: 'New User',
      UserEmail: 'newuser@example.com',
      UserPass: 'password',
      UserPhone: '11111',
      UserPrefs: 'Default Preferences',
    );

    await addUserUseCase.call(newUser);
    setState(() {}); // Trigger a UI update after adding user
  }

  // Function to handle deleting a user
  Future<void> _deleteUser(String id) async {
    await deleteUserUseCase.call(id);
    setState(() {}); // Trigger a UI update after deleting user
  }

  // Function to handle editing a user
  Future<void> _editUser(UserEntity user) async {
    TextEditingController nameController = TextEditingController(text: user.UserName);
    TextEditingController emailController = TextEditingController(text: user.UserEmail);

    // Show a dialog to edit the user
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {

                Navigator.of(context).pop();
                syncUsersUseCase.call(); // Sync data again to refresh

              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the user details
                final updatedUser = UserEntity(
                  UserId: user.UserId,
                  UserName: nameController.text,
                  UserEmail: emailController.text,
                  UserPass: user.UserPass,
                  UserPrefs: user.UserPrefs,
                  UserPhone: user.UserPhone,
                );
                await updateUserUseCase.call(updatedUser); // Update user through addUserUseCase
                setState(() {}); // Trigger a UI update after editing
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle user list refresh
  Future<void> _refreshUsers() async {
    // Instantiate SyncData and call its method
    await syncUsersUseCase.call(); // Sync data again to refresh
    setState(() {}); // Trigger a UI update after refreshing
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers, // Link the refresh function to pull-to-refresh
        child: FutureBuilder<List<UserEntity>>(
          future: getUsersUseCase.call(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No users found.'));
            } else {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.UserName),
                    subtitle: Text(user.UserEmail),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editUser(user), // Edit the user
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUser(user.UserId), // Delete the user
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
