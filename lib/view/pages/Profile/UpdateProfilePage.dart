import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/user_entity.dart';
import 'package:hedieaty/domain/usecases/user/getUserbyId.dart';
import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';

import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/sync_users.dart';
import '../../../domain/usecases/user/update_user.dart';
import '../../../utils/AppColors.dart';
import '../../components/widgets/buttons/IconButton.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String authId = '';
  UserEntity? user;

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;
  late GetUserAuthId getUserAuthIdUseCase;
  late GetUserById getUserByIdUseCase;
  late UpdateUser updateUserUseCase;

  // Controllers for TextFormFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final userRepository = UserRepositoryImpl(
        sqliteDataSource: SQLiteUserDataSource(),
        firebaseDataSource: FirebaseUserDataSource(),
        firebaseAuthDataSource: FirebaseAuthDataSource(),
      );

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);
      getUserAuthIdUseCase = GetUserAuthId(userRepository);
      getUserByIdUseCase = GetUserById(userRepository);
      updateUserUseCase = UpdateUser(userRepository);

      await syncUsersUseCase.call();

      authId = await getUserAuthIdUseCase.call();
      user = await getUserByIdUseCase.call(authId);

      // Initialize TextFormFields with user data
      if (user != null) {
        _nameController.text = user!.UserName;
        _emailController.text = user!.UserEmail;
        _phoneController.text = user!.UserPhone ;
        _passwordController.text = user!.UserPass ;
        _preferencesController.text = user!.UserPrefs! ;
      }

      setState(() {});
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updateEmail(_emailController.text);
          await user.reload();
          await user.updatePassword(_phoneController.text);
          await user.reload();
          user = FirebaseAuth.instance.currentUser;
        }

        final updatedUser = UserEntity(
            UserId: authId,
            UserName: _nameController.text,
            UserEmail: _emailController.text,
            UserPhone: _phoneController.text,
            UserPass: _passwordController.text,
            UserPrefs: _preferencesController.text

        );
        await updateUserUseCase.call(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || !emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }



  String? _validatePhone(String? value) {
    if (value == null || value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Phone number must be exactly 10 digits";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update Profile',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipOval(
                  child: Image.network(
                    'https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png',
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.height * 0.2,
                    errorBuilder: (context, error, stackTrace) {
                      // Provide a fallback image if the network image fails to load
                      return Image.asset(
                        'assets/images/default_profile.png', // Ensure you have this asset in your project

                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator:_validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _preferencesController,
                  decoration: const InputDecoration(
                    labelText: 'Preferences',
                    prefixIcon: Icon(Icons.settings),
                  ),
                ),
                const SizedBox(height: 32),
                IC_button(
                  title: 'Update Profile',
                  icon: Icon(Icons.update, color: AppColors.white),
                  onPress: _updateUser,
                  color: AppColors.primary,
                  fontsize: 14,
                  width: double.infinity,
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }
}
