import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class ApplyJobService {
  static Future<Map<String, dynamic>> applyForJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("user_id");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/jobs/applyforJobs"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "jobId": jobId,
          "userId": userId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": data["message"] ?? "Job applied successfully",
        };
      }

      return {
        "success": false,
        "message": data["error"] ??
            data["message"] ??
            "Failed to apply for job",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong. Please try again.",
      };
    }
  }
}