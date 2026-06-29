import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/SimilarJobs/Jobs/savedJobs.dart';
import 'package:zuperr/Utils/AppConstants.dart';


class SavedJobsService {

  static Future<List<SavedJob>> getSavedJobs() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    final response = await http.get(

      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/getusersavedjobs",
      ),

      headers: {

        "Authorization":"Bearer $token",

      },
    );

    if(response.statusCode==200){

      final json=jsonDecode(response.body);

      return SavedJobsResponse.fromJson(json)
          .savedJobs;

    }

    return [];
  }
}