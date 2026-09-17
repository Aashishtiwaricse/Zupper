import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeMain/homeMain.dart';

import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';
import 'package:zuperr/Services/GoogleAuthService.dart/googleAuth.dart';
import 'package:zuperr/Services/auth_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String challengeToken;

  const VerifyOtpScreen({
    required this.email,
    required this.challengeToken,
    super.key,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // ============================================================
  // OTP CONTROLLERS
  // ============================================================

  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());

  // ============================================================
  // SERVICES
  // ============================================================

  final GoogleAuthService googleAuthService = GoogleAuthService();
  final AuthService _authService = AuthService();

  // ============================================================
  // VARIABLES
  // ============================================================

  bool _isLoading = false;
  bool _isButtonEnabled = false;

  bool _showError = false;

  late String currentChallengeToken;

  Timer? _resendTimer;

  int _remainingSeconds = 120;

  bool _canResend = false;

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    currentChallengeToken = widget.challengeToken;

    // Listen for OTP changes
    for (var controller in _otpControllers) {
      controller.addListener(_checkOtpFilled);
    }

    // Start countdown
    _startResendTimer();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _resendTimer?.cancel();

    for (final controller in _otpControllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // RESEND TIMER
  // ============================================================

  void _startResendTimer() {
    _resendTimer?.cancel();

    setState(() {
      _remainingSeconds = 60;
      _canResend = false;
    });

    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_remainingSeconds <= 1) {
          timer.cancel();

          setState(() {
            _remainingSeconds = 0;
            _canResend = true;
          });
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  String _formatRemainingTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // CHECK OTP
  // ============================================================

  void _checkOtpFilled() {
    final otp = _otpControllers.map((e) => e.text).join();

    setState(() {
      _isButtonEnabled = otp.length == 6;
      _showError = false;
    });
  }

  // ============================================================
  // OTP CHANGE
  // ============================================================

  void _onOtpChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(
          _focusNodes[index + 1],
        );
      } else {
        FocusScope.of(context).unfocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(
          _focusNodes[index - 1],
        );
      }
    }
  }

  // ============================================================
  // VERIFY OTP API
  // ============================================================

Future<void> verifyOtpApi() async {
  if (_isLoading) return;

  final String enteredOtp =
      _otpControllers.map((e) => e.text).join();

  if (enteredOtp.length != 6) {
    setState(() {
      _showError = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter the 6 digit OTP"),
        backgroundColor: Colors.red,
      ),
    );

    return;
  }

  try {
    setState(() {
      _isLoading = true;
      _showError = false;
    });

    print("========================================");
    print("VERIFY LOGIN OTP");
    print("OTP: $enteredOtp");
    print("CHALLENGE TOKEN: $currentChallengeToken");
    print("========================================");

    final response = await _authService.verifyloginOtp(
      otp: enteredOtp,
      token: currentChallengeToken,
    );

    print("========================================");
    print("OTP VERIFY RESPONSE:");
    print(response);
    print("========================================");

    if (!mounted) return;

    // =========================================================
    // OTP SUCCESS
    // =========================================================

    if (response["message"] == "OTP verified successfully") {
      final String signInToken =
          response["signInToken"]?.toString() ?? "";

      final String userId =
          response["userID"]?.toString() ?? "";

      final String experienceLevel =
          response["userExperienceLevel"]?.toString() ?? "";

      // =======================================================
      // SAVE FINAL LOGIN TOKEN
      // =======================================================

      if (signInToken.isEmpty) {
        throw Exception(
          "Login token was not received after OTP verification",
        );
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        "auth_token",
        signInToken,
      );

      if (userId.isNotEmpty) {
        await prefs.setString(
          "user_id",
          userId,
        );
      }

      await prefs.setString(
        "email",
        widget.email,
      );

      if (experienceLevel.isNotEmpty) {
        await prefs.setString(
          "user_experience_level",
          experienceLevel,
        );
      }

      print("FINAL LOGIN TOKEN SAVED");
      print("USER ID: $userId");
      print("EXPERIENCE LEVEL: $experienceLevel");

      // =======================================================
      // SUCCESS MESSAGE
      // =======================================================

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ??
                "OTP verified successfully",
          ),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      // =======================================================
      // GO TO MAIN SCREEN
      // =======================================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
        (route) => false,
      );
    } else {
      throw Exception(
        response["message"] ?? "OTP verification failed",
      );
    }
  } catch (e) {
    print("========================================");
    print("OTP VERIFY ERROR");
    print(e);
    print("========================================");

    if (!mounted) return;

    setState(() {
      _showError = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString().replaceAll(
            "Exception: ",
            "",
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<void> resendOtpApi() async {
    if (!_canResend || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      print("========================================");
      print("RESEND LOGIN OTP");
      print("EMAIL: ${widget.email}");
      print("TOKEN: $currentChallengeToken");
      print("========================================");

      final response = await _authService.resendOtp(
        email: widget.email,
        token: currentChallengeToken,
      );

      print("RESEND OTP RESPONSE:");
      print(response);

      // ========================================================
      // UPDATE CHALLENGE TOKEN IF API RETURNS ONE
      // ========================================================

      if (response["challengeToken"] != null) {
        setState(() {
          currentChallengeToken =
              response["challengeToken"].toString();
        });
      } else if (response["SignupToken"] != null) {
        // Keeping this for compatibility with your existing API
        setState(() {
          currentChallengeToken =
              response["SignupToken"].toString();
        });
      }

      if (!mounted) return;

      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ?? "OTP resent successfully",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("RESEND OTP ERROR:");
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll(
              "Exception: ",
              "",
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ======================================================
          // BACKGROUND
          // ======================================================

          SizedBox.expand(
            child: Image.asset(
              'assets/SignIn.png',
              fit: BoxFit.cover,
            ),
          ),

          // ======================================================
          // CONTENT
          // ======================================================

          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // ==================================================
                    // TOP SECTION
                    // ==================================================

                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 40),

                            Text(
                              "Zuperr",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 20),

                            Text(
                              "Verify your OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 12),

                            Text(
                              "Enter the 6 digit OTP sent to your registered email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==================================================
                    // BOTTOM CARD
                    // ==================================================

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 260,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          24,
                          20,
                          20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            // ==========================================
                            // OTP BOXES
                            // ==========================================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                6,
                                (index) {
                                  return SizedBox(
                                    width: 48,
                                    child: TextField(
                                      controller:
                                          _otpControllers[index],
                                      focusNode:
                                          _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                          TextInputType.number,
                                      maxLength: 1,

                                      decoration: InputDecoration(
                                        counterText: "",
                                        filled: true,
                                        fillColor:
                                            Colors.grey.shade100,

                                        enabledBorder:
                                            OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: _showError
                                                ? Colors.red
                                                : Colors
                                                    .grey
                                                    .shade300,
                                          ),
                                        ),

                                        focusedBorder:
                                            OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: _showError
                                                ? Colors.red
                                                : Colors.blue,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),

                                      onChanged: (value) {
                                        _onOtpChange(
                                          value,
                                          index,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 25),

                            // ==========================================
                            // VERIFY BUTTON
                            // ==========================================

                            GestureDetector(
                              onTap: (_isButtonEnabled &&
                                      !_isLoading)
                                  ? verifyOtpApi
                                  : null,
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (_isButtonEnabled &&
                                              !_isLoading)
                                          ? Colors.blue
                                          : Colors.blue
                                              .withValues(
                                              alpha: 0.4,
                                            ),
                                  borderRadius:
                                      BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Verify OTP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // RESEND OTP
                            // ==========================================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive OTP? ",
                                ),

                                TextButton(
                                  onPressed: _canResend &&
                                          !_isLoading
                                      ? resendOtpApi
                                      : null,
                                  child: Text(
                                    _canResend
                                        ? "Resend OTP"
                                        : "Resend OTP in ${_formatRemainingTime()}",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      color: _canResend
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // DIVIDER
                            // ==========================================

                            Row(
                              children: const [
                                Expanded(
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    "Or login with",
                                  ),
                                ),
                                Expanded(
                                  child: Divider(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // GOOGLE LOGIN
                            // ==========================================

                            ElevatedButton.icon(
                              icon: Image.asset(
                                "assets/google.png",
                                height: 22,
                              ),
                              label: const Text(
                                "Continue with Google",
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      try {
                                        final response =
                                            await googleAuthService
                                                .signInWithGoogle();

                                        Get.snackbar(
                                          "Success",
                                          response["message"] ??
                                              "Login Successful",
                                        );

                                        Get.offAll(
                                          () =>
                                              const HomeScreen(),
                                        );
                                      } catch (e) {
                                        Get.snackbar(
                                          "Error",
                                          e
                                              .toString()
                                              .replaceAll(
                                                "Exception: ",
                                                "",
                                              ),
                                        );
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}