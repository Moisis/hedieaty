import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServiceRec.instance.setupFlutterNotifications();
  NotificationServiceRec.instance.showNotification(message);
}

class NotificationServiceRec {
  NotificationServiceRec._();
  static final NotificationServiceRec instance = NotificationServiceRec._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request notification permissions
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Uncomment for debugging
    // final token = await _messaging.getToken();
    // print('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } catch (e) {
      print('Error requesting notification permissions: $e');
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    try {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          // Handle notification tap logic here
          final String? payload = response.payload;
          print('Notification tapped with payload: $payload');
        },
      );

      _isFlutterLocalNotificationsInitialized = true;
    } catch (e) {
      print('Error setting up Flutter notifications: $e');
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
              'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: message.data.toString(),
        );
      }
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageInteraction);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageInteraction(initialMessage);
    }
  }

  void _handleMessageInteraction(RemoteMessage message) {
    print('Message interaction with data: ${message.data}');
    if (message.data['type'] == 'chat') {
      // Navigate to chat screen logic here
    }
  }
}
