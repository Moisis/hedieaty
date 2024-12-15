import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hedieaty/utils/AppColors.dart';
import 'package:hedieaty/view/components/widgets/buttons/CustomButton.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || !emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _controllerEmail.text.trim(),
              password: _controllerPassword.text.trim())
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, '/home_page', (route) => false));
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(), gravity: ToastGravity.SNACKBAR);
    }
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
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
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
                    topLeft: Radius.circular(
                        MediaQuery.of(context).size.width * 0.1),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(165, 201, 255, 1.0),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _controllerEmail,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      border: InputBorder.none,
                                    ),
                                    validator: _validateEmail,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _controllerPassword,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: "Password",
                                      border: InputBorder.none,
                                    ),
                                    validator: _validatePassword,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Custom_button(
                          title: 'Login',
                          onPress: _login,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/register', (route) => false);
                              },
                              child: const Text(
                                "Sign Up",
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
          ],
        ),
      ),
    );
  }
}
