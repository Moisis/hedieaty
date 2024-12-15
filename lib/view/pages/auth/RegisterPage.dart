import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hedieaty/view/components/widgets/buttons/CustomButton.dart';

import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repos_head/user_repository.dart';
import '../../../domain/usecases/user/add_user.dart';
import '../../../utils/AppColors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late AddUser addUserUseCase;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();


  @override
  void initState() {
    super.initState();

    final sqliteDataSource = SQLiteUserDataSource();
    final firebaseDataSource = FirebaseUserDataSource();
    final firebaseAuthDataSource = FirebaseAuthDataSource();

    final repository = UserRepositoryImpl(
      sqliteDataSource: sqliteDataSource,
      firebaseDataSource: firebaseDataSource,
      firebaseAuthDataSource: firebaseAuthDataSource,
    );
    addUserUseCase = AddUser(repository as UserRepository);
    sqliteDataSource.init();
  }


  Future<void> register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim());

      // Get the User ID
      String uid = userCredential.user?.uid ?? '';

      // Create a new user data
      final userData = UserEntity(
        UserId: uid,
        UserName: _controllerName.text.trim(),
        UserEmail: _controllerEmail.text.trim(),
        UserPass: _controllerPassword.text.trim(),
        UserPhone: _controllerPhone.value.text.trim(),
        UserEventsNo: 0,
      );

      addUserUseCase.call(userData);

      // Navigate to home page
      Navigator.pushNamedAndRemoveUntil(
          context, "/home_page", (route) => false);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(), gravity: ToastGravity.SNACKBAR);
    }
  }




  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _resetForm() {
    setState(() {
      _controllerName.clear();
      _controllerEmail.clear();
      _controllerPhone.clear();
      _controllerPassword.clear();
      _errorMessage = null;
    });
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      register();
      setState(() {
        _errorMessage = null;
      });
      Fluttertoast.showToast(msg: "Registration completed successfully!" , gravity: ToastGravity.SNACKBAR);
    } else {
      setState(() {
        _errorMessage = "Please fix the errors above.";

      });
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
      body: Container(
        color: AppColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.1),
                    topRight: Radius.circular(MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          // Name Field
                          TextFormField(
                            controller: _controllerName,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateName,
                          ),
                          const SizedBox(height: 20),
                          // Email Field
                          TextFormField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 20),
                          // Phone Number Field
                          TextFormField(
                            controller: _controllerPhone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              border: OutlineInputBorder(),
                              prefixText: "+20 ",
                            ),
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          TextFormField(
                            controller: _controllerPassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 20),
                          // Error Message Display
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 20),
                          // Buttons

                          Custom_button(
                            onPress: _validateAndSubmit,
                            title: "Register",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                },
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // @override
  // void dispose() {
  //   _resetForm();
  //   _controllerName.dispose();
  //   _controllerEmail.dispose();
  //   _controllerPhone.dispose();
  //   _controllerPassword.dispose();
  //   super.dispose();
  // }
}


