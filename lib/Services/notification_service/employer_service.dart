import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class EmployerService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Response> saveFcmToken({
    required String token,
    required String platform,
    required String deviceId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final authToken = prefs.getString("auth_token");

      debugPrint("AUTH TOKEN => $authToken");

      final response = await dio.put(
        "/api/employee/fcm-token",

        data: {"token": token, "platform": platform, "deviceId": deviceId},

        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",

            "Content-Type": "application/json",
          },
        ),
      );

      debugPrint("FCM TOKEN RESPONSE => ${response.data}");

      return response;
    } on DioException catch (e) {
      debugPrint("FCM TOKEN API ERROR => ${e.response?.data}");

      throw Exception(
        e.response?.data.toString() ?? "Unable to save FCM token",
      );
    }
  }
}
