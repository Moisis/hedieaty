import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  // const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final bool _hasSeenIntro = true;

  @override
  void initState() {
    super.initState();
    initialization();

  }

  void initialization() async {
    // print('ready in 3...');
    // await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
    // Navigator.pushReplacementNamed(context, '/home_page');
    _checkIntroSeen();
  }


  Future<void> _checkIntroSeen() async {
    // TODO: Check if user has seen intro (Shared Prefs )
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool? seen = prefs.getBool('seenIntro') ?? false;
    // setState(() {
    //   _hasSeenIntro = seen;
    // });

    // Navigate based on intro seen status
    if (_hasSeenIntro) {
      Navigator.pushReplacementNamed(context, '/home_page');
    } else {
      Navigator.pushReplacementNamed(context, '/intro_page');
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Container();
  }
}
