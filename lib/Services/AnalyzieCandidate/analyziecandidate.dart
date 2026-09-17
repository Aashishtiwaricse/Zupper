import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class AnalyzeCandidateService {
  static Future<String?> analyzeCandidate({
    required Map<String, dynamic> candidateProfile,
    required Map<String, dynamic> jobDescription,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/analyze-candidate"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "candidateProfile": candidateProfile,
        "jobDescription": jobDescription,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Change this according to your API response
      return data["summary"] ??
          data["analysis"] ??
          data["result"]?.toString();
    }

    return null;
  }
}