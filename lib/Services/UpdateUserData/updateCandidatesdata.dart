

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class updateCandiDatesdata {
  
  static Future<bool> update({
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await Dio().post(
        "${ApiConstants.baseUrl}/api/employee/updatecandidatedata",
        data: {
          "updatedFields": updatedFields,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    }
  }
}