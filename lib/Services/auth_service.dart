import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Services/notification_service/notification_service.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {"Content-Type": "application/json"},
    ),
  );

  //signup

  Future<Response> signup({
  required String firstName,
  required String lastName,
  required String email,
  required String mobileNumber,
  required String password,
}) async {
  try {
    final response = await dio.post(
      ApiConstants.signup,
      data: {
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "mobilenumber": mobileNumber,
        "password": password,
      },
    );

    return response;


  } on DioException catch (e) {
    throw Exception(
      e.response?.data?["message"] ?? "Something went wrong",
    );
  }
}
  //verify api

Future<Map<String, dynamic>> verifyOtp({
  required String otp,
  required String token,
}) async {
  try {
    print("========== VERIFY OTP ==========");
    print("OTP: $otp");
    print("Token Used: $token");
    print("URL: ${ApiConstants.verifyOtp}");

    final response = await dio.post(
      ApiConstants.verifyOtp,
      data: {
        "otp": otp,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    print("Verify OTP Status Code: ${response.statusCode}");
    print("Verify OTP Response: ${response.data}");
    print("================================");

    return Map<String, dynamic>.from(response.data);
  } on DioException catch (e) {
    print("========== VERIFY OTP ERROR ==========");
    print("Error: ${e.message}");
    print("Status Code: ${e.response?.statusCode}");
    print("Error Response: ${e.response?.data}");
    print("======================================");

    throw Exception(
      e.response?.data?["message"] ??
          "OTP Verification Failed",
    );
  }
}



Future<Map<String, dynamic>> verifyloginOtp({
  required String otp,
  required String token,
}) async {
  try {

    print("========== VERIFY OTP ==========");
    print("OTP: $otp");
    print("Token Used: $token");
    print("URL: ${ApiConstants.verifyloginOtp}");

    final response = await dio.post(
      ApiConstants.verifyloginOtp,
      data: {
        "otp": otp,
        "challengeToken":token
      },
      options: Options(
        headers: {
         "Authorization": "Bearer $token",
        },
      ),
    );

    print("Verify OTP Status Code: ${response.statusCode}");
    print("Verify OTP Response: ${response.data}");

    print("================================");

    return response.data;

  } on DioException catch (e) {

    print("========== VERIFY OTP ERROR ==========");
    print("Error: ${e.message}");
    print("Status Code: ${e.response?.statusCode}");
    print("Error Response: ${e.response?.data}");
    print("======================================");

    throw Exception(
      e.response?.data["message"] ?? "OTP Verification Failed",
    );
  }
}

  //Resend otp
// Resend OTP API
Future<Map<String, dynamic>> resendOtp({
  required String email,
  required String token,
}) async {
  try {
    final response = await dio.post(
      ApiConstants.resendOtp,
      data: {
        "email": email,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;

  } on DioException catch (e) {
    throw Exception(
      e.response?.data["message"] ?? "Failed to resend OTP",
    );
  }
}
  //sigin in api
  
  Future<Map<String, dynamic>> signIn({
  required String email,
  required String password,
  required bool rememberMe,
}) async {
  try {
    final response = await dio.post(
      ApiConstants.signin,
      data: {
        "email": email,
        "password": password,
      },
    );

    print('Sign In Response: ${response.data}');

    final prefs = await SharedPreferences.getInstance();

    // Save auth token
    if (response.data["signInToken"] != null) {
      await prefs.setString(
        "auth_token",
        response.data["signInToken"].toString(),
      );

      await NotificationService.instance.updateToken();
    }

    // Save user ID
    if (response.data["userID"] != null) {
      await prefs.setString(
        "user_id",
        response.data["userID"].toString(),
      );
    }

    // Save email
    await prefs.setString("email", email);
    await prefs.setString("saved_email", email);

    // Remember me
    if (rememberMe) {
      await prefs.setBool("remember_me", true);
      await prefs.setString("saved_password", password);
    } else {
      await prefs.setBool("remember_me", false);
      await prefs.remove("saved_password");
    }

    return Map<String, dynamic>.from(response.data);
  } on DioException catch (e) {
    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 400:
        throw Exception("Invalid email or password");

      case 401:
        throw Exception("Unauthorized access");

      case 403:
        throw Exception("Account is blocked");

      case 404:
        throw Exception("User not found");

      case 409:
        throw Exception("Account already exists");

      case 422:
        throw Exception("Invalid input data");

      case 500:
        throw Exception("Server error. Please try again later");

      default:
        throw Exception(
          e.response?.data?["message"] ??
              "Something went wrong. Please try again",
        );
    }
  } catch (e) {
    throw Exception("Unable to login. Please try again");
  }
}

  //Forgot pass

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await dio.post(
        "${ApiConstants.baseUrl}/api/employee/forgot-password/request",
        data: {"email": email},
      );
print("from resend link");
print(email);
      print(response.data);

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to process your request.",
      );
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }
}
