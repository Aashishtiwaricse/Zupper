import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class LoginOtpService {
  static Future<Map<String, dynamic>> sendOtp(String email,String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

     

      debugPrint("Sending OTP request...");
      debugPrint("Email: $email");

      final response = await http
          .post(
            Uri.parse("${ApiConstants.baseUrl}/api/employee/signin"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.setString(
          "challengeToken",
          data["challengeToken"] ?? "",
        );

        await prefs.setString(
          "userId",
          data["userID"] ?? "",
        );

        return {
          "success": true,
          "message": data["message"] ?? "OTP sent successfully",
        };
      }

      return {
        "success": false,
        "message": data["message"] ?? "Request failed",
      };
    } catch (e, stack) {
      debugPrint("LoginOtpService Error: $e");
      debugPrintStack(stackTrace: stack);

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}