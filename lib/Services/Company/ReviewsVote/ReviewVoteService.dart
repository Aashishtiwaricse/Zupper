import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';


class ReviewVoteService {
  static Future<Map<String, dynamic>> upvote(String reviewId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/company/reviews/$reviewId/upvote"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );


print(response.body);
      final body = jsonDecode(response.body);

      return {
        "success": response.statusCode == 200,
        "message": body["message"] ?? "",
        "data": body,
      };
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> downvote(String reviewId) async {
    try {
 final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/company/reviews/$reviewId/downvote"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("doqwnvote response: ${response.statusCode}");

print(response.body);
print(response.body);


      final body = jsonDecode(response.body);

      return {
        "success": response.statusCode == 200,
        "message": body["message"] ?? "",
        "data": body,
      };
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}