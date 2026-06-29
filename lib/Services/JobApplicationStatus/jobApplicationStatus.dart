import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/SimilarJobs/JobApplicationStatus/jobApplication.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class JobApplicationService {
  static Future<List<JobApplicationStatus>> getApplications() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/jobapplicationstatus"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => JobApplicationStatus.fromJson(e))
          .toList();
    }

    return [];
  }
}