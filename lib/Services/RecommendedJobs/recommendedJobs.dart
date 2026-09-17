import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/SignInScreen/signIn.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class RecommendedJobsService {
  static Future<List<dynamic>> getRecommendedJobs(
      BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await Dio().get(
        '${ApiConstants.baseUrl}${ApiConstants.recommendations}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return response.data['recommendations'] ?? [];
      }

      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("auth_token");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your session has expired. Please log in again."),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      }

      debugPrint("Recommended Jobs Error: ${e.response?.data}");
      return [];
    } catch (e) {
      debugPrint("Recommended Jobs Error: $e");
      return [];
    }
  }
}