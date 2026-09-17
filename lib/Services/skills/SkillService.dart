import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class SkillService {
  static Future<List<Skill>> getAllSkills() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");

      final response = await Dio().get(
        "${ApiConstants.baseUrl}/api/employer/skills/get-all-skill",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final model = SkillModel.fromJson(response.data);

      return model.skills;
    } on DioException catch (e) {
      print(e.response?.data);
      return [];
    }
  }
}