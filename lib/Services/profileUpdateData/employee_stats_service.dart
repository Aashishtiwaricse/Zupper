import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/SimilarJobs/EmployeStats/employee_stats_model.dart';
import 'package:zuperr/Utils/AppConstants.dart';


class EmployeeStatsService {
  static Future<EmployeeStatsModel?> getStats(int days) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");

      final response = await http.get(
        Uri.parse(
            "${ApiConstants.baseUrl}/api/employee/stats?days=$days"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return EmployeeStatsModel.fromJson(
            jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}