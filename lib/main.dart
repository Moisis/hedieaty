//Imports

//libs
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hedieaty/view/pages/SettingsPage.dart';

// Style
import 'package:hedieaty/utils/AppColors.dart';

//Landing
 import 'package:hedieaty/view/pages/Landing/SplashScreen.dart';
 import 'package:hedieaty/view/pages/Landing/intro_page.dart';

//Auth

import 'package:hedieaty/view/pages/auth/LoginPage.dart';
import 'package:hedieaty/view/pages/auth/RegisterPage.dart';


//Pages

import 'package:hedieaty/view/pages/GiftListPage.dart';
import 'package:hedieaty/view/pages/HomePage.dart';
import 'package:hedieaty/view/pages/MyPledgedGiftsPage.dart';
import 'package:hedieaty/view/pages/NotificationsPage.dart';
import 'package:hedieaty/view/pages/ProfilePage.dart';
 import 'package:hedieaty/view/pages/EventListPage.dart';

import 'firebase_options.dart';

Future<void> initializeFirebase()  async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  // await initializeFirebase();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  const MyApp({super.key});
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
          bodyLarge:  AppColors.textPrimary_h2,
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
      // initialRoute: '/register',

      routes: {
        // Into Screen
        '/splash_page': (context) =>   SplashScreen(),
        '/intro_page': (context) =>   IntroPage(),

        // Auth Screen
        '/login': (context) =>  LoginPage(),
        '/register': (context) =>  RegisterPage(),


        // '/user': (context) =>  UserScreen(),

        // Pages
        '/home_page': (context) =>  Homepage(),
        '/GiftList': (context) =>  GiftListPage(),
        '/pledgedGifts': (context) =>  PledgedGiftsPage(),
        '/profile_page': (context) =>  ProfilePage(),
        // '/profile_page': (context) =>  ProfileScreen(),

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


