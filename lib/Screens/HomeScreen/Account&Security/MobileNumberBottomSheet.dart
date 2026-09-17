import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/OTPBottomSheet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zuperr/Utils/AppConstants.dart';

class MobileNumberBottomSheet extends StatefulWidget {
  final Future<void> Function() onVerified;

  const MobileNumberBottomSheet({
    super.key,
    required this.onVerified,
  });

  @override
  State<MobileNumberBottomSheet> createState() =>
      _MobileNumberBottomSheetState();
}

class _MobileNumberBottomSheetState
    extends State<MobileNumberBottomSheet> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> requestTwoFactorOtp() async {
    setState(() => loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}/api/employee/2fa/setup/request",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({}),
      );

      debugPrint(
        "2FA setup request status: ${response.statusCode}",
      );
      debugPrint(
        "2FA setup request response: ${response.body}",
      );

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final data = jsonDecode(response.body);

        final challengeToken = data["challengeToken"];

        if (challengeToken == null ||
            challengeToken.toString().isEmpty) {
          Get.snackbar(
            "Error",
            "Challenge token was not received",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
          return;
        }

        /*
         * Close email/password bottom sheet first.
         */
        Navigator.pop(context);

        /*
         * Then open OTP bottom sheet.
         *
         * IMPORTANT:
         * The challengeToken returned by the API is passed
         * to OTPBottomSheet.
         */
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => OTPBottomSheet(
            challengeToken: challengeToken.toString(),
            onVerified: widget.onVerified,
          ),
        );
      } else {
        String message = "Failed to start 2FA setup";

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
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e, s) {
      debugPrint("2FA setup request error: $e");
      debugPrintStack(stackTrace: s);

      if (mounted) {
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            MediaQuery.of(context).viewInsets.bottom + 40,
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
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Two-Step Verification Email",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "You can receive sign-in codes at this email",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your email address",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Password",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
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
              onPressed:
                  loading ? null : requestTwoFactorOtp,
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }
}