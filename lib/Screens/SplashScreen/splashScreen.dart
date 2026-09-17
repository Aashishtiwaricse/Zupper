import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zuperr/Screens/HomeMain/homeMain.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';
import 'package:zuperr/Services/PublicJobService/PublicJobService.dart';

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

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _linkSubscription;

  bool _isInitializing = true;
  bool _navigationStarted = false;

  String? _pendingJobId;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    _initialize();
  }

  // ============================================================
  // INITIALIZATION
  // ============================================================

  Future<void> _initialize() async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      // IMPORTANT:
      // Check the URL before doing normal authentication navigation.
      await _checkInitialDeepLink();

      // Listen for links while app is running.
      _listenForDeepLinks();

      // Splash duration.
      await Future.delayed(
        const Duration(seconds: 4),
      );

      if (!mounted) return;

      _isInitializing = false;

      // ========================================================
      // JOB LINK HAS HIGHEST PRIORITY
      // ========================================================

      if (_pendingJobId != null &&
          _pendingJobId!.isNotEmpty) {
        await _openJobFromDeepLink(_pendingJobId!);
        return;
      }

      // ========================================================
      // NO JOB LINK
      // CHECK AUTH
      // ========================================================

      await _normalNavigation();
    } catch (e, stackTrace) {
      print("======================================");
      print("SPLASH INITIALIZATION ERROR");
      print(e);
      print(stackTrace);
      print("======================================");

      if (!mounted) return;

      _isInitializing = false;

      await _normalNavigation();
    }
  }

  // ============================================================
  // INITIAL DEEP LINK
  // ============================================================

  Future<void> _checkInitialDeepLink() async {
    try {
      final Uri? initialUri =
          await _appLinks.getInitialLink();

      if (initialUri == null) {
        print("NO INITIAL DEEP LINK");
        return;
      }

      print("======================================");
      print("INITIAL DEEP LINK");
      print(initialUri.toString());
      print("======================================");

      final jobId = _extractJobId(initialUri);

      if (jobId == null) {
        print("URL DOES NOT CONTAIN VALID JOB ID");
        return;
      }

      _pendingJobId = jobId;

      print("======================================");
      print("JOB ID FOUND");
      print(jobId);
      print("======================================");
    } catch (e) {
      print("INITIAL DEEP LINK ERROR: $e");
    }
  }

  // ============================================================
  // RUNNING APP DEEP LINKS
  // ============================================================

  void _listenForDeepLinks() {
    _linkSubscription =
        _appLinks.uriLinkStream.listen(
      (Uri uri) async {
        print("======================================");
        print("DEEP LINK RECEIVED");
        print(uri.toString());
        print("======================================");

        final jobId = _extractJobId(uri);

        if (jobId == null) {
          print("INVALID JOB LINK");
          return;
        }

        print("JOB ID: $jobId");

        // If splash is still active,
        // save the job ID and let _initialize() handle it.
        if (_isInitializing) {
          _pendingJobId = jobId;
          return;
        }

        // App is already running.
        await _openJobFromDeepLink(jobId);
      },
      onError: (error) {
        print("DEEP LINK STREAM ERROR: $error");
      },
    );
  }

  // ============================================================
  // EXTRACT JOB ID
  // ============================================================

String? _extractJobId(Uri uri) {
  print("DEEP LINK URL: ${uri.toString()}");
  print("DEEP LINK PATH: ${uri.path}");

  final parts = uri.pathSegments;

  print("PATH SEGMENTS: $parts");

  // Expected:
  // https://uat.zuperr.co/job-details/69ae7587070f6ff631a0de28
  //
  // parts:
  // [job-details, 69ae7587070f6ff631a0de28]

  if (parts.length < 2) {
    return null;
  }

  if (parts[0] != "job-details") {
    return null;
  }

  final jobId = parts[1].trim();

  if (jobId.isEmpty) {
    return null;
  }

  print("JOB ID FOUND: $jobId");

  return jobId;
}
  // ============================================================
  // OPEN JOB
  // ============================================================

Future<void> _openJobFromDeepLink(String jobId) async {
  if (!mounted || _navigationStarted) return;

  _navigationStarted = true;

  print("======================================");
  print("OPENING JOB FROM DEEP LINK");
  print("JOB ID: $jobId");
  print("======================================");

  try {
    final job = await PublicJobService.getJob(jobId);

    if (!mounted) return;

    if (job == null) {
      print("JOB NOT FOUND");

      // Job URL was received, but job could not be loaded.
      // Go according to normal authentication.
      _navigationStarted = false;
      await _normalNavigation();
      return;
    }

    print("======================================");
    print("JOB LOADED SUCCESSFULLY");
    print("OPENING JOB DETAILS");
    print("======================================");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(
          job: job,
        ),
      ),
    );
  } catch (e, stackTrace) {
    print("JOB DEEP LINK ERROR: $e");
    print(stackTrace);

    if (!mounted) return;

    _navigationStarted = false;
    await _normalNavigation();
  }
}
  // ============================================================
  // NORMAL NAVIGATION
  // ============================================================

  Future<void> _normalNavigation() async {
    if (!mounted) return;

    if (_navigationStarted) {
      print("Normal navigation already started");
      return;
    }

    _navigationStarted = true;

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString("auth_token");

    final isLoggedIn =
        token != null && token.isNotEmpty;

    print("======================================");
    print("NORMAL NAVIGATION");
    print("AUTH TOKEN PRESENT: $isLoggedIn");
    print("======================================");

    if (!mounted) return;

    if (isLoggedIn) {
      print("GOING TO MAIN SCREEN");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    } else {
      print("GOING TO LOGIN SCREEN");

      Navigator.pushReplacementNamed(
        context,
        '/LoginScreen',
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _controller.dispose();

    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: const Text(
                  "Zuperr",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
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