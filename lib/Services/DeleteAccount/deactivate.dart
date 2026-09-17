import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/SignInScreen/signIn.dart';
import '../../Utils/AppConstants.dart';

Future<void> deactivateAccount(
  BuildContext context,
  String reason,
) async {
  try {
    print("Inside deactivateAccount");

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");
    final email = prefs.getString("email");

    print("Token: $token");
    print("Email: $email");
    print("Reason: $reason");

    if (token == null || email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session expired. Please login again."),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/deactivatecandidateaccount"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "deactivateReason": reason,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Clear all saved data
      await prefs.clear();

      // Optional success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body["message"] ?? "Account deactivated successfully."),
        ),
      );

      // Navigate to login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            body["message"] ?? "Something went wrong.",
          ),
        ),
      );
    }
  } catch (e) {
    print("Exception: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}