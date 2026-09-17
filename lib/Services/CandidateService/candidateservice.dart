import 'package:dio/dio.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CandidateService {
  static final Dio dio = Dio();

  static Future<bool> saveUserExperienceLevel({
    required String token,
    required String experienceLevel,
  }) async {
    try {
      final response = await dio.post(
        "${ApiConstants.baseUrl}/api/employee/saveuserexperiencelevel",
        data: {
          "updatedFields": {
            "userExperienceLevel": experienceLevel,
          }
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );



      print("form select experience level");
      print(response.data);

      print(response.data);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception(
        e.response?.data["message"] ?? "Unable to save experience level",
      );
    }
  }
}