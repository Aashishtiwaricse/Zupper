import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class SaveJobService {
  static Future<bool> saveJob(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Replace with your actual token key if different
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/employee/savejob"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "jobId": jobId.toString(),
        }),
      );
 print("${response.statusCode}");
      return response.statusCode == 200 || response.statusCode == 201;
      
      
    } catch (e) {
      print("Save Job Error: $e");
      return false;
    }
  }
}