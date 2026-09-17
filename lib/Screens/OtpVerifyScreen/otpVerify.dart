import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:zuperr/Screens/AboutYourSelf/aboutYourSelf.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';
import 'package:zuperr/Screens/SignInScreen/signIn.dart';
import 'package:zuperr/Services/GoogleAuthService.dart/googleAuth.dart';
import 'package:zuperr/Services/auth_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String otp;
  final String signupToken;

  const VerifyOtpScreen({
    required this.email,
    required this.otp,
    required this.signupToken,
    super.key,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final GoogleAuthService googleAuthService = GoogleAuthService();
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  bool _isLoading = false;
  bool _isButtonEnabled = false;
  final bool _showError = false;
  final AuthService _authService = AuthService();
  late String currentSignupToken;
  Timer? _resendTimer;

  int _remainingSeconds = 120;

  bool _canResend = false;
  void _startResendTimer() {
    _resendTimer?.cancel();

    setState(() {
      _remainingSeconds = 60;
      _canResend = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    });
  }

  String _formatRemainingTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    currentSignupToken = widget.signupToken;

    for (var controller in _otpControllers) {
      controller.addListener(_checkOtpFilled);
    }
    // Start 2-minute countdown
    _startResendTimer();
  }

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

  void _checkOtpFilled() {
    String otp = _otpControllers.map((e) => e.text).join();
    setState(() {
      _isButtonEnabled = otp.length == 5;
    });
  }

  void _onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> verifyOtpApi() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String enteredOtp = _otpControllers.map((e) => e.text).join();

      final response = await _authService.verifyOtp(
        otp: enteredOtp,
        token: currentSignupToken,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"] ?? "OTP Verified Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      final String otpVerifiedToken = response["OtpVerifiedToken"] ?? "";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AboutYourselfScreen(otpVerifiedToken: otpVerifiedToken),
        ),
      );

      // Navigate to Login/Home Screen
      // Navigator.pushReplacement(...);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> resendOtpApi() async {
    if (!_canResend) return;

    try {
      final response = await _authService.resendOtp(
        email: widget.email,
        token: currentSignupToken,
      );

      print("Resend OTP Response: $response");

      // Update token received from resend API
      if (response["SignupToken"] != null) {
        setState(() {
          currentSignupToken = response["SignupToken"].toString();
        });
      }

      if (!mounted) return;

      // Restart 2-minute timer after successful resend
      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"] ?? "OTP resent successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 BACKGROUND
          SizedBox.expand(
            child: Image.asset('assets/SignIn.png', fit: BoxFit.cover),
          ),

          /// 🔵 CONTENT
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    /// 🔷 TOP TEXT
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              "Enter the OTP sent to your associated mobile number",
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

                    /// 🔷 BOTTOM CARD
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 260,
                      ),

                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            /// 🔢 OTP BOXES
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 55,
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: _showError
                                              ? Colors.red
                                              : Colors.grey.shade300,
                                        ),
                                      ),

                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: _showError
                                              ? Colors.red
                                              : Colors.blue,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChange(value, index),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 25),

                            /// 🔘 VERIFY BUTTON
                            GestureDetector(
                              onTap: _isLoading ? null : verifyOtpApi,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: (_isButtonEnabled && !_isLoading)
                                      ? Colors.blue
                                      : Colors.blue.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Verify OTP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// 🔁 RESEND
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Didn't receive OTP? "),
                                TextButton(
                                  onPressed: _canResend ? resendOtpApi : null,
                                  child: Text(
                                    _canResend
                                        ? "Resend OTP"
                                        : "Resend OTP in ${_formatRemainingTime()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _canResend
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// DIVIDER
                            Row(
                              children: const [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("Or login with"),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// GOOGLE
                            ElevatedButton.icon(
                              icon: Image.asset(
                                "assets/google.png",
                                height: 22,
                              ),
                              label: const Text("Continue with Google"),
                              onPressed: () async {
                                try {
                                  final response = await googleAuthService
                                      .signInWithGoogle();

                                  Get.snackbar(
                                    "Success",
                                    response["message"] ?? "Login Successful",
                                  );

                                  Get.offAll(() => const HomeScreen());
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    e.toString().replaceAll("Exception: ", ""),
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
