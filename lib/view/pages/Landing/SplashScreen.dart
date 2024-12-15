import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();



    final prefs = await SharedPreferences.getInstance();
    bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    // You can replace this logic to check for intro screen status
    hasSeenIntro = true;

    if (hasSeenIntro) {
      Navigator.pushReplacementNamed(context, '/home_page');
    } else {
      prefs.setBool('hasSeenIntro' ,false );
      Navigator.pushReplacementNamed(context, '/intro_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}