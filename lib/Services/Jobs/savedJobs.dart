import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/Jobs/savedJobs.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class SavedJobsService {
  static Future<List<SavedJob>> getSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/getusersavedjobs"),

      headers: {"Authorization": "Bearer $token"},
    );
    print("from saved jobs");
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return SavedJobsResponse.fromJson(json).savedJobs;
    }

    return [];
  }

  static Future<bool> deleteSavedJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.patch(
        Uri.parse(
          "${ApiConstants.baseUrl}/api/employee/savedjobs/${jobId}/bin",
        ),

        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print('from delete jobs');

      print(response.body);
      print(response.statusCode);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete Saved Job Error: $e");
      return false;
    }
  }

  static Future<bool> unsaveJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/employee/unsavejob"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"jobId": jobId}),
      );

      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Unsave Job Error : $e");
      return false;
    }
  }
}
