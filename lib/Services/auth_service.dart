import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Map<String, dynamic>> signup({
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

      final signupToken = response.data["SignupToken"];

      if (signupToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("signup_token", signupToken);
      }

      return response.data;
    } on DioException catch (e) {
      print("Status Code: ${e.response?.statusCode}");
      print("Response Data: ${e.response?.data}");
      print("Message: ${e.message}");
      rethrow;
    }
  }
  Future<Map<String, dynamic>> verifyOtp({
  required String otp,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("signup_token");

    final response = await dio.post(
      ApiConstants.verifyOtp,
      data: {
        "otp": otp,
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
      e.response?.data["message"] ?? "OTP Verification Failed",
    );
  }
}

Future<Map<String, dynamic>> resendOtp() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("signup_token");

    final response = await dio.post(
      ApiConstants.resendOtp,
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
Future<Map<String, dynamic>> signIn({
  required String email,
  required String password,
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

    if (response.data["signInToken"] != null) {
      await prefs.setString(
        "auth_token",
        response.data["signInToken"],
      );
    }

    if (response.data["userID"] != null) {
      await prefs.setString(
        "user_id",
        response.data["userID"],
      );
    }

    return response.data;
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
        throw Exception("Something went wrong. Please try again");
    }
  } catch (e) {
    throw Exception("Unable to login. Please try again");
  }
}
}





