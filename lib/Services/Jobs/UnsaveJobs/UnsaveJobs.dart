import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class UnsaveJobService {
  static Future<bool> unsaveJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/employee/unsavejob"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "jobId": jobId,
        }),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}