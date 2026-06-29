 import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

Future<bool> updateCandidateData({
  required String profileSummary,
  required List<String> keySkills,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final response = await Dio().post(
      "${ApiConstants.baseUrl}/api/employee/updatecandidatedata",
      data: {
        "profileSummary": profileSummary,
        "keySkills": keySkills,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );
print("TOKEN: $token");
    print(response.data);

    return response.statusCode == 200 ||
        response.statusCode == 201;
  } on DioException catch (e) {
    print("Update Error: ${e.response?.data}");
    return false;
  }
}