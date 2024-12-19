//Imports
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//libs
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hedieaty/view/pages/Event/EventCreationPage.dart';
import 'package:hedieaty/view/pages/Profile/ProfileManageFriends.dart';
import 'package:hedieaty/view/pages/Profile/SettingsPage.dart';

// Style
import 'package:hedieaty/utils/AppColors.dart';

//Landing
 import 'package:hedieaty/view/pages/Landing/SplashScreen.dart';
 import 'package:hedieaty/view/pages/Landing/intro_page.dart';

//Auth

import 'package:hedieaty/view/pages/auth/LoginPage.dart';
import 'package:hedieaty/view/pages/auth/RegisterPage.dart';
import 'utils/notification/reciever.dart';

//Pages


import 'package:hedieaty/view/pages/HomePage.dart';


import 'package:hedieaty/view/pages/Profile/ProfilePage.dart';
import 'package:hedieaty/view/pages/Event/EventListPage.dart';
import 'package:hedieaty/view/pages/Profile/MyPledgedGiftsPage.dart';

import 'firebase_options.dart';

// Future<void> initializeFirebase()  async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   FirebaseDatabase.instance.setPersistenceEnabled(true);
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled  // await initializeFirebase();
    (true);
  await NotificationServiceRec.instance.initialize();



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
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.copyWith(
            bodyLarge: AppColors.textPrimary_h2,
            bodyMedium: AppColors.textSecondary_h2,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primary,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialRoute: '/splash_page',
      routes: {
        // Into Screen
        '/splash_page': (context) =>   SplashScreen(),
        '/onboarding': (context) =>   IntroPage(),

        // Auth Screen
        '/login': (context) =>  LoginPage(),
        '/register': (context) =>  RegisterPage(),


        // Pages
        '/home_page': (context) =>  Homepage(),

        //Event
        '/Eventlistpage' : (context) =>  Eventlistpage(),
        '/EventCreatePage' : (context) =>  EventCreationPage(),


        //Profile
        '/settings_page' : (context) =>  SettingsPage(),
        '/pledgedGifts': (context) =>  PledgedGiftsPage(),
        '/profile_page': (context) =>  ProfilePage(),
        '/manageFriends': (context) =>  ProfileManageFriends(),

      },
    );
  }
}


