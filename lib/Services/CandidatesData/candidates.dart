import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CandidateService {
  static Future<Map<String, dynamic>?> getCandidateData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await Dio().get(
        "${ApiConstants.baseUrl}/api/employee/getcandidatedata",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      print("Candidate Data Response: ${response.statusCode}");
      print(response.data);

      if (response.statusCode == 200) {
        print("profile data");
        print(response.data);
        return response.data;
      }
    } catch (e) {
      print("Candidate Data Error: $e");
    }

    return null;
  }
}