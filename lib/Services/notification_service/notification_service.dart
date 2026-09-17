import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:zuperr/Controllers/Notification/notification_controller.dart';
import 'package:zuperr/Services/notification_service/employer_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );
  //------------------------------------------------------------
// Foreground Notification
//------------------------------------------------------------
void _onNotificationTap(Map<String, dynamic> data) {

  final route = data["route"];

  if(route == null) return;


  Get.toNamed(
    route,
    arguments: data,
  );

}
Future<void> _onForegroundMessage(RemoteMessage message) async {
  try {
    await _saveNotification(message);

    await _showLocalNotification(message);
  } catch (e) {
    debugPrint("Foreground Notification Error : $e");
  }
}

//------------------------------------------------------------
// Notification Click
//------------------------------------------------------------

void _onNotificationOpened(RemoteMessage message) {
  final data = Map<String, dynamic>.from(message.data);

  _onNotificationTap(data);
}


Future<void> updateToken() async {

  try {

    final token = await _firebaseMessaging.getToken();


    if (token == null) {
      debugPrint(
        "FCM token is null",
      );
      return;
    }


    debugPrint(
      "Current FCM Token: $token",
    );


    await _uploadToken(token);


  } catch(e){

    debugPrint(
      "FCM update token error: $e",
    );

  }
}
//------------------------------------------------------------
// Local Notification Click
//------------------------------------------------------------



//------------------------------------------------------------
// Save Notification
//------------------------------------------------------------


Future<void> _saveNotification(
    RemoteMessage message,
) async {


  await NotificationController.to
      .addNotification(

    title:
    message.notification?.title ?? "",


    body:
    message.notification?.body ?? "",


    type:
    message.data["type"] ?? "general",


    route:
    message.data["route"] ?? "",


    data:
    Map<String,dynamic>.from(
        message.data
    ),

  );

}




//------------------------------------------------------------
// Local Notification
//------------------------------------------------------------

Future<void> _showLocalNotification(
  RemoteMessage message,
) async {

  const android = AndroidNotificationDetails(
    "high_importance_channel",
    "High Importance Notifications",
    channelDescription: "Zuperr Notifications",
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  const ios = DarwinNotificationDetails();

  const details = NotificationDetails(
    android: android,
    iOS: ios,
  );

 await _localNotifications.show(
  id: message.hashCode,
  title: message.notification?.title,
  body: message.notification?.body,
  notificationDetails: details,
  payload: jsonEncode(message.data),
);
}

//------------------------------------------------------------
// Get Token
//------------------------------------------------------------

Future<void> _getFCMToken() async {

  final token = await _firebaseMessaging.getToken();

  if (token == null) return;

  debugPrint("FCM TOKEN");

  debugPrint(token);

  await _uploadToken(token);
}

//------------------------------------------------------------
// Upload Token
//------------------------------------------------------------

Future<void> _uploadToken(
  String token,
) async {

  try {
    final EmployerService _employerService =
    EmployerService();

    await _employerService.saveFcmToken(

      token: token,

platform: Platform.isAndroid ? "android" : "ios",
      deviceId: "android",

    );


    debugPrint(
      "FCM Token uploaded successfully",
    );


  } catch(e){

    debugPrint(
      "FCM Token upload failed: $e",
    );

  }

}
  Future<void> initialize() async {
    await _requestPermission();

    await _createNotificationChannel();

    await _initializeLocalNotifications();

    await _configureFirebaseListeners();

    await _getFCMToken();
  }

  Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _createNotificationChannel() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

  await _localNotifications.initialize(
  settings: settings,

  onDidReceiveNotificationResponse: (details) {

    if (details.payload == null) return;


    final decoded = jsonDecode(
      details.payload!,
    );


    if (decoded is Map<String, dynamic>) {

      _onNotificationTap(decoded);

    }

  },
);
  }

  Future<void> _configureFirebaseListeners() async {
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      _onNotificationOpened,
    );

    final initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _onNotificationOpened(initialMessage);
    }

  _firebaseMessaging.onTokenRefresh.listen(
  (token) async {

    debugPrint("New FCM Token: $token");

    await _uploadToken(token);

  },
);
  }}