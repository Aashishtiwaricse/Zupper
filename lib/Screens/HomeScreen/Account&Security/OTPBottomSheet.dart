import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zuperr/Utils/AppConstants.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zuperr/Utils/AppConstants.dart';

class OTPBottomSheet extends StatefulWidget {
  final String challengeToken;
  final Future<void> Function() onVerified;

  const OTPBottomSheet({
    super.key,
    required this.challengeToken,
    required this.onVerified,
  });

  @override
  State<OTPBottomSheet> createState() => _OTPBottomSheetState();
}

class _OTPBottomSheetState extends State<OTPBottomSheet> {
  final otpController = TextEditingController();

  bool loading = false;

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter a valid 6-digit OTP",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}/api/employee/2fa/setup/verify",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "challengeToken": widget.challengeToken,
          "otp": otp,
        }),
      );

      debugPrint("2FA verify status: ${response.statusCode}");
      debugPrint("2FA verify response: ${response.body}");

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        // API verified the OTP successfully.
        await widget.onVerified();

        if (!mounted) return;

        Navigator.pop(context);

        Get.snackbar(
          "Success",
          "Two-Factor Authentication Enabled",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );
      } else {
        String message = "Invalid OTP";

        try {
          final data = jsonDecode(response.body);

          if (data["message"] != null) {
            message = data["message"].toString();
          }
        } catch (_) {}

        Get.snackbar(
          "Error",
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      }
    } catch (e) {
      debugPrint("2FA verification error: $e");

      if (mounted) {
        Get.snackbar(
          "Error",
          "Verification failed",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Enter the verification code Send to your email to enable Two-Factor Authentication.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter 6-digit OTP",
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: loading ? null : verifyOtp,
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Verify OTP"),
            ),
          ),
        ],
      ),
    );
  }
}