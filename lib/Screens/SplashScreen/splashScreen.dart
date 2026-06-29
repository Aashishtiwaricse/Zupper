import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeMain/homeMain.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

@override
void initState() {
  super.initState();

  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);

  _scale = Tween<double>(begin: 0.8, end: 1.2).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  _controller.forward();

  _checkLoginStatus();
}
Future<void> _checkLoginStatus() async {
  await Future.delayed(const Duration(seconds: 4));

  final prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString("auth_token");

  if (!mounted) return;

  if (token != null && token.isNotEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  } else {
    Navigator.pushReplacementNamed(
      context,
      '/onboardingScreen',
    );
  }
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Center Animated Text
          Center(
            child: FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: const Text(
                  "Zuperr",
                  style: TextStyle(
                    fontSize: 40,
    fontWeight: FontWeight.w900, // 🔥 MORE BOLD

                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}