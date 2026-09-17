import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/PasswordUpdate/passUpdate.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class AccountSecurityService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<String?> getCurrentEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  static Future<Map<String, dynamic>> validateEmployerEmail({
    required String oldEmail,
    required String newEmail,
    required String password,
  }) async {
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
        body: jsonEncode({
          "oldEmail": oldEmail,
          "newEmail": newEmail,
          "password": password,
        }),
      );
      print("from change email validateEmployerEmail");

      print(response.body);
      print(response.statusCode);

      print("RAW RESPONSE: ${response.body}");

      if (response.body.isEmpty) {
        return {"success": false, "message": "Empty response from server"};
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "OTP sent successfully",
          "EmailUpdateOtp": data["EmailUpdateOtp"],
          "EmailUpdatetoken": data["EmailUpdatetoken"],
        };
      }

      return {
        "success": false,
        "message": data["message"] ?? "Something went wrong",
      };
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  static Future<Map<String, dynamic>> verifyEmailOtp({
    required String otp,
    required String emailUpdateToken,
  }) async {
    try {
      final token = await getToken();

      if (token == null) {
        return {"success": false, "message": "Authentication token not found."};
      }

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}/api/employee/verifyotpforemailupdate",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"otp": otp, "emailUpdateToken": emailUpdateToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": data["message"] ?? "OTP verified successfully.",
        };
      } else {
        return {"success": false, "message": data["message"] ?? "Invalid OTP."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error. Please try again."};
    }
  }

  static Future<PasswordUpdateResult> updatePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final token = await getToken();

      if (token == null) {
        return PasswordUpdateResult(
          success: false,
          message: "Authentication token not found.",
        );
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

      final body = jsonDecode(response.body);
      final message = body["message"] ?? "Something went wrong.";

      switch (response.statusCode) {
        case 200:
        case 201:
          return PasswordUpdateResult(success: true, message: message);

        case 400:
        case 401:
        case 404:
        case 500:
          return PasswordUpdateResult(success: false, message: message);

        default:
          return PasswordUpdateResult(success: false, message: message);
      }
    } catch (e) {
      return PasswordUpdateResult(
        success: false,
        message: "Unable to connect to server. Please try again.",
      );
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
            body: jsonEncode({"password": password}),
          )
          .timeout(const Duration(seconds: 20));

      print("Verify Password Status: ${response.statusCode}");
      print("Verify Password Response: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Verify Password Error: $e");
      return false;
    }
  }
}
