import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hedieaty/pages/HomePage.dart';
import 'package:hedieaty/pages/SplashScreen.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  // const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home :  SplashScreen(),
      // initialRoute:  '/splash_page',
      routes: {
        '/splash_page': (context) =>   SplashScreen(),
        '/home_page': (context) =>  Homepage(),
        // '/info_page': (context) => const InfoPage(),
        // '/rules_page': (context) =>  CopyrightPage(),
        // '/stats_page': (context) => const StatsPage(),
      },
    );
  }
}


