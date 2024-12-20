import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/main.dart';

import 'package:hedieaty/view/components/widgets/FriendList.dart';
import 'package:hedieaty/view/components/widgets/nav/BottomNavBar.dart';
import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';
import 'package:hedieaty/view/pages/Event/EventCreatePage.dart';
import 'package:hedieaty/view/pages/HomePage.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Login test
  testWidgets('Integration test', (WidgetTester tester) async {
    // Launch the app

    await intializeFirebase();

    await tester.pumpWidget(const MyApp()); // Replace with your app's entry point

    // Verify that the IntroPage is displayed
    await tester.pump(const Duration(seconds: 5));

    await tester.pumpAndSettle();

    final email = find.byKey(const ValueKey('email'));
    expect(email, findsOneWidget);

    await tester.enterText(email, 'miso1@gmail.com');

    final password = find.byKey(const ValueKey('password'));
    expect(password, findsOneWidget);

    await tester.enterText(password, 'miso1234');

    await tester.pump(const Duration(seconds: 2));

    // Ensure the "Login" button is visible and tap it
    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);


    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that the RegisterPage is displayed
    final homepage = find.byType(HomePage);
    expect(homepage, findsOneWidget);
  });

  testWidgets('Verify app initializes correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp()); // Replace with your app's entry point

    // Wait for initialization to complete
    await tester.pumpAndSettle();

    // Verify the loading indicator appears initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the loading to complete
    await tester.pumpAndSettle();

    // Verify HomePage content is displayed
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(FriendList), findsOneWidget);
    expect(find.byType(Bottomnavbar), findsOneWidget);
    expect(find.text('Create Your Own Event'), findsOneWidget);
  });

  testWidgets('Search bar toggles and filters friends', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify search icon exists
    final searchIcon = find.byIcon(Icons.search);
    expect(searchIcon, findsOneWidget);

    // Tap search icon
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();

    // Enter search query
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'miso2');
    await tester.pump();

    await tester.pump(const Duration(seconds: 10));

    // Verify filtered results
    expect(find.text('miso2'), findsWidgets); // Adjust based on test data
  });

  testWidgets('Add friend workflow', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap floating action button to open Add Friend window
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Enter phone number
    final phoneField = find.byType(TextFormField);
    await tester.enterText(phoneField, '4444444444'); // Adjust for valid input
    await tester.pump();

    await tester.pump(const Duration(seconds: 10));

    // Submit form
    final addFriendButton = find.text('Add Friend');
    expect(addFriendButton, findsOneWidget);
    await tester.tap(addFriendButton);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 10));

    // Verify success message
    expect(find.text('Friend added successfully!'), findsOneWidget);
  });

  testWidgets('Navigate to EventCreatePage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap "Create Your Own Event" button
    final eventButton = find.text('Create Your Own Event');
    expect(eventButton, findsOneWidget);
    await tester.tap(eventButton);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 10));

    // Verify navigation
    expect(find.byType(EventCreationPage), findsOneWidget); // Adjust based on your EventCreatePage class name
  });
}



