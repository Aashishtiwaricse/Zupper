import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';




class ApplyJobService {
  static Future<bool> applyForJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("user_id");

      print("Job ID: $jobId");
      print("User ID: $userId");

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}/auth/jobs/applyforJobs",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "jobId": jobId,
          "userId": userId,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print("Apply Error: $e");
      return false;
    }
  }
}