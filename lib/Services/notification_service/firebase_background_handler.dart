import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zuperr/Database/notification_db.dart';
import 'package:zuperr/Models/SimilarJobs/Notifications/notification_model.dart';
import 'package:zuperr/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';




@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {


  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await Hive.initFlutter();


  if (!Hive.isAdapterRegistered(1)) {

    Hive.registerAdapter(
      NotificationModelAdapter(),
    );

  }


  await NotificationDB.instance.init();



  await NotificationDB.instance.save(

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
          message.data,
        ),

  );


  debugPrint(
    "Background Notification Saved",
  );

}