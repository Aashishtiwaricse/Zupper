import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zuperr/Services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool _loading = false;

  // 2 minutes = 120 seconds
  int _remainingSeconds = 0;

  Timer? _timer;

  bool get _canResend => _remainingSeconds == 0;

  // Start 2 minute countdown
  void _startCountdown() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 120;
    });

    _timer = Timer.periodic(
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
          });
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> sendRequest() async {
    if (!_formKey.currentState!.validate()) return;

    // Prevent resend before 2 minutes
    if (!_canResend) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await _authService.forgotPassword(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      // Start 2-minute countdown ONLY after successful API response
      _startCountdown();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Email Sent"),
            content: Text(
              response["message"] ??
                  "Password reset instructions have been sent to your email.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Back to Login"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/SignIn.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 70),

                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Enter your registered email address and we'll send password reset instructions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  Container(
                    margin: const EdgeInsets.all(18),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email Address",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText:
                                  "Enter your email address",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return "Email is required";
                              }

                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return "Enter valid email";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xff2F80ED),
                                disabledBackgroundColor:
                                    Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),

                              onPressed:
                                  (_loading || !_canResend)
                                      ? null
                                      : sendRequest,

                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : !_canResend
                                      ? Text(
                                          "Resend in ${_formatTime()}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        )
                                      : Text(
                                          _remainingSeconds == 0
                                              ? "Send Reset Link"
                                              : "Resend Reset Link",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: const Text(
                                "Back to Login",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
