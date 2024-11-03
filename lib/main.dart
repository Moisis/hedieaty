//Imports

//libs
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hedieaty/pages/SettingsPage.dart';

// Style
import 'components/AppColors.dart';

//Landing
 import 'package:hedieaty/pages/Landing/SplashScreen.dart';
 import 'package:hedieaty/pages/Landing/intro_page.dart';

//Auth

import 'package:hedieaty/pages/auth/LoginPage.dart';
import 'package:hedieaty/pages/auth/RegisterPage.dart';


//Pages

import 'package:hedieaty/pages/GiftListPage.dart';
import 'package:hedieaty/pages/HomePage.dart';
import 'package:hedieaty/pages/MyPledgedGiftsPage.dart';
import 'package:hedieaty/pages/NotificationsPage.dart';
import 'package:hedieaty/pages/ProfilePage.dart';
 import 'package:hedieaty/pages/EventListPage.dart';



void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // runApp( MyApp());

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  // const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hedieaty',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        // accentColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          bodyLarge:  AppColors.textPrimary_h1,
          bodyMedium: AppColors.textSecondary_h2,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primary,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      // Todo uncomment screen home :  SplashScreen(),
      // home :  SplashScreen(),
      // initialRoute:  '/splash_page',
      initialRoute:  '/home_page',
      routes: {
        // Into Screen
        '/splash_page': (context) =>   SplashScreen(),
        '/intro_page': (context) =>   IntroPage(),

        // Auth Screen
        '/login_page': (context) =>  LoginPage(),
        '/register_page': (context) =>  RegisterPage(),


        // Pages
        '/home_page': (context) =>  Homepage(),
        '/GiftList': (context) =>  GiftListPage(),
        '/pledgedGifts': (context) =>  PledgedGiftsPage(),
        '/profile_page': (context) =>  ProfilePage(),
        '/notification_page': (context) =>  NotificationsPage(),
        '/Eventlistpage' : (context) =>  Eventlistpage(),
        '/settings_page' : (context) =>  SettingsPage(),
        // '/info_page': (context) => const InfoPage(),
        // '/rules_page': (context) =>  CopyrightPage(),
        // '/stats_page': (context) => const StatsPage(),
      },
    );
  }
}


