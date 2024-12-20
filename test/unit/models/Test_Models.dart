import 'package:flutter_test/flutter_test.dart';


import 'UnitTest_Model_Event.dart' as event_tests;
import 'UnitTest_Model_Gift.dart' as gift_tests;
import 'UnitTest_Model_User.dart' as user_tests;
import 'UnitTest_Model_Friend.dart' as friend_tests;

void main() {
  group('Model Tests Suite', () {
    // Include Event model tests
    group('Event Model Tests', () {
      event_tests.main();
    });

    // Include Gift model tests
    group('Gift Model Tests', () {
      gift_tests.main();
    });

    // Include User model tests
    group('User Model Tests', () {
      user_tests.main();
    });


    group('Friend Model Tests', () {
      friend_tests.main();
    });

  });
}
