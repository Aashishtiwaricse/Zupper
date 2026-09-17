import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zuperr/Controllers/Notification/notification_controller.dart';
import 'package:zuperr/Database/notification_db.dart';
import 'package:zuperr/Screens/AboutYourSelf/aboutYourSelf.dart';
import 'package:zuperr/Screens/AboutYourSelf/uploadResume.dart';
import 'package:zuperr/Screens/HomeMain/homeMain.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';
import 'package:zuperr/Screens/OnBoardingScreen/onBoardingScreen.dart';
import 'package:zuperr/Screens/SignInScreen/signIn.dart';
import 'package:zuperr/Screens/SignupScreen/signupScreen.dart';
import 'package:zuperr/Screens/SplashScreen/splashScreen.dart';
import 'package:zuperr/Services/notification_service/notification_service.dart';
import 'package:zuperr/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Models/SimilarJobs/Notifications/notification_model.dart';

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("Background Notification");
  debugPrint(message.notification?.title);
  debugPrint(message.notification?.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    // Hive
    await Hive.initFlutter();
      Hive.registerAdapter(
    NotificationModelAdapter(),
  );
  await NotificationDB.instance.init();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );





  
  // Background FCM
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Notification Controller
  Get.put(NotificationController(), permanent: true);


  // Notification Service
  await NotificationService.instance.initialize();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Zuperr',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      routes: {
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/onboardingScreen': (context) => OnboardingScreen(),
        '/LoginScreen': (context) => LoginScreen(),
      //  '/VerifyOtpScreen': (context) => VerifyOtpScreen(),




      //   '/AboutYourselfScreen': (context) =>     AboutYourselfScreen(),
                   
               '/MainScreen': (context) =>MainScreen(),
         '/UploadResumeScreen': (context) =>  UploadResumeScreen()
      },
      home: const SplashScreen(),
    );
  }
}
