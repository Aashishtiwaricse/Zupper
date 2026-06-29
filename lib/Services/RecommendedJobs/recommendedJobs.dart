import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class RecommendedJobsService {
  static Future<List<dynamic>> getRecommendedJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await Dio().get(
        '${ApiConstants.baseUrl}${ApiConstants.recommendations}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {

            print(response.data);
                        print(response.statusCode);


        return response.data['recommendations'] ?? [];
      }

      return [];
    } catch (e) {
      print("Recommended Jobs Error: $e");
      return [];
    }
  }
}