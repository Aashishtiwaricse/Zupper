import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class AccountSecurityService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

static Future<Map<String, dynamic>> validateNewEmail(String email) async {
  try {
    final token = await getToken();

    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/validateuserforupdatecandidateemail",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"newEmail": email}),
    );

    print("Validate Email Status: ${response.statusCode}");
    print("Validate Email Response: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "message": data["message"] ?? "OTP sent successfully",
      };
    }

    return {
      "success": false,
      "message": data["message"] ?? "Something went wrong",
    };
  } catch (e) {
    print("Validate Email Error: $e");

    return {
      "success": false,
      "message": "Network error. Please try again.",
    };
  }
}

  static Future<bool> verifyEmailOtp(String otp) async {
    try {
      final token = await getToken();

      if (token == null) {
        print("Token not found");
        return false;
      }

      final response = await http
          .post(
            Uri.parse(
              "${ApiConstants.baseUrl}/api/employee/verifyotpforemailupdate",
            ),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "otp": otp,
            }),
          )
          .timeout(const Duration(seconds: 20));

      print("OTP Status: ${response.statusCode}");
      print("OTP Response: ${response.body}");

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print("Verify OTP Error: $e");
      return false;
    }
  }

  static Future<bool> updatePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final token = await getToken();

      if (token == null) {
        print("Token not found");
        return false;
      }

      final response = await http
          .post(
            Uri.parse(
              "${ApiConstants.baseUrl}/api/employee/updatecandidatepassword",
            ),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "oldPassword": oldPassword,
              "newPassword": newPassword,
            }),
          )
          .timeout(const Duration(seconds: 20));

      print("Password Update Status: ${response.statusCode}");
      print("Password Update Response: ${response.body}");

      switch (response.statusCode) {
        case 200:
        case 201:
          return true;

        case 400:
          print("Invalid password");
          return false;

        case 401:
          print("Unauthorized");
          return false;

        case 500:
          print("Server Error");
          return false;

        default:
          return false;
      }
    } catch (e) {
      print("Update Password Error: $e");
      return false;
    }
  }

  static Future<bool> verifyPassword(String password) async {
    try {
      final token = await getToken();

      if (token == null) {
        print("Token not found");
        return false;
      }

      final response = await http
          .post(
            Uri.parse(
              "${ApiConstants.baseUrl}/api/employee/validateuserforcandidateprofileupdate",
            ),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 20));

      print("Verify Password Status: ${response.statusCode}");
      print("Verify Password Response: ${response.body}");

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print("Verify Password Error: $e");
      return false;
    }
  }
}