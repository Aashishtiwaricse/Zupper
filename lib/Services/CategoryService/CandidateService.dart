import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CandidateService {
   static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }
  static Future<bool> updateCategories(List<String> categories) async {
  final token = await getToken();

  final response = await http.post(
    Uri.parse("${ApiConstants.baseUrl}/api/employee/updatecandidatedata"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "updatedFields": {
        "selectedJobCategories": categories,
      },
    }),
  );

  print("Status: ${response.statusCode}");
  print("Body: ${response.body}");

  return response.statusCode == 200;
}
}