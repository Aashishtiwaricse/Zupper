import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class UpdateProfileService {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<bool> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.put(
        Uri.parse("$baseUrl/api/employee/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(profileData),
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