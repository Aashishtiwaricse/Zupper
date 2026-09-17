import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class ReplyReviewService {
  static Future<Map<String, dynamic>> reply({
    required String reviewId,
    required String content,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}/api/company/reviews/$reviewId/reply",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "content": content,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return {
          "success": true,
          "message": data["message"] ?? "Reply posted",
        };
      }

      return {
        "success": false,
        "message": data["message"] ?? "Failed",
      };
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}