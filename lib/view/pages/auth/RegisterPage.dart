import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/database/local/sqlite_user_dao.dart';

import '../../../data/database/remote/firebase_user_dao.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/repos_head/user_repository.dart';
import '../../../domain/usecases/user/add_user.dart';
import '../../../utils/AppColors.dart';
import '../../components/widgets/buttons/CustomButton.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  late AddUser addUserUseCase;



  void initState() {
    super.initState();

    final sqliteDataSource = SQLiteUserDataSource();
    final firebaseDataSource = FirebaseUserDataSource();
    final repository = UserRepositoryImpl(
      sqliteDataSource: sqliteDataSource,
      firebaseDataSource: firebaseDataSource,
    );
    addUserUseCase = AddUser(repository as UserRepository);
    sqliteDataSource.init();


  }

  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();


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
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
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
                    topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.1),
                    topRight: Radius.circular(MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                              // Name Field
                              Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // Email Field
                              Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  controller: _controlleremail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // Phone Number Field with Country Code
                              Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: TextField(
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "+20",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Password Field
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  controller: _controllerPassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Custom_button(
                          title: 'Register',
                          onPress: ()  async {
                            try {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: _controlleremail.text.trim(),
                                  password: _controllerPassword.text.trim())
                                  .then((value) =>
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/home_page", (route) => false));
                            }on FirebaseAuthException catch(e){
                              Fluttertoast.showToast(msg: e.message.toString() , gravity: ToastGravity.SNACKBAR);
                            }

                          },
                        ),
                        Row(
                          children: [
                            Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                            TextButton(
                              child: Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                              },
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