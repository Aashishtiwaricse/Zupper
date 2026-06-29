import 'package:flutter/material.dart';
import 'package:zuperr/Screens/AboutYourSelf/aboutYourSelf.dart';
import 'package:zuperr/Screens/AboutYourSelf/uploadResume.dart';
import 'package:zuperr/Screens/HomeMain/homeMain.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';
import 'package:zuperr/Screens/OnBoardingScreen/onBoardingScreen.dart';
import 'package:zuperr/Screens/OtpVerifyScreen/otpVerify.dart';
import 'package:zuperr/Screens/SignInScreen/signIn.dart';
import 'package:zuperr/Screens/SignupScreen/signupScreen.dart';
import 'package:zuperr/Screens/SplashScreen/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zuperr',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routes: {
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/onboardingScreen': (context) => OnboardingScreen(),
        '/LoginScreen': (context) => LoginScreen(),
      //  '/VerifyOtpScreen': (context) => VerifyOtpScreen(),




         '/AboutYourselfScreen': (context) =>     AboutYourselfScreen(),
                   
               '/MainScreen': (context) =>MainScreen(),
         '/UploadResumeScreen': (context) =>  UploadResumeScreen()
      },
      home: const SplashScreen(),
    );
  }
}
