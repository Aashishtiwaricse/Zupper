import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class UpdateJobPreferenceService {
  static const String url =
      "${ApiConstants.baseUrl}/api/employee/profile";

  static Future<bool> updateJobPreference({
    required List<String> jobTypes,
    required String availability,
    required String preferredLocation,
    required int minimumSalary,
    required int maximumSalary,
    required List<String> jobRoles,
    required String preferredShift,
    required int locationPreferenceKM,
    required List<String> preferredStates,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "careerPreference": {
            "jobTypes": jobTypes,
            "availability": availability,
            "preferredLocation": preferredLocation,
            "minimumSalaryLPA": minimumSalary,
            "maximumSalaryLPA": maximumSalary,
            "jobRoles": jobRoles,
            "preferredShift": preferredShift,
            "locationPreferenceKM": locationPreferenceKM,
            "preferredStates": preferredStates,
          }
        }),
      );

      print(response.statusCode);
      print(response.body);

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
}