import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/Jobs/AppliedJobs.dart';
import 'package:zuperr/Utils/AppConstants.dart';



class AppliedJobsService {

  static Future<List<AppliedJob>>
      getAppliedJobs() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    final response = await http.post(

      Uri.parse(
        "${ApiConstants.baseUrl}/auth/getuserappliedjobs",
      ),

      headers: {

        "Authorization":"Bearer $token",

      },

    );

    print(response.body);

    if(response.statusCode==200){

      final json=jsonDecode(response.body);

      return AppliedJobsResponse
          .fromJson(json)
          .appliedJobs;
    }

    return [];
  }
}