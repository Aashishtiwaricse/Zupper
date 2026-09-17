import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class VerifyOtpService {
  static Future<bool> verifyOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();

    final challengeToken = prefs.getString("challengeToken");

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/verify-login-otp"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "challengeToken": challengeToken,
        "otp": otp,
      }),
    );
print('from verify otp service: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["token"] != null) {
        await prefs.setString("auth_token", data["token"]);
      }

      return true;
    }

    return false;
  }
}