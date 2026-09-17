 import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/SavedJobsBin/savedJobsBin.dart';
import 'package:zuperr/Utils/AppConstants.dart';


Future<List<SavedJobBin>> getSavedJobsBin() async {

  try {

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/savedjobs/bin",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );


    print("BIN STATUS: ${response.statusCode}");
    print("BIN BODY: ${response.body}");


    if(response.statusCode == 200){

      final body = jsonDecode(response.body);


      final List data = body["binJobs"] ?? [];


      print("BIN COUNT: ${data.length}");


      return data
          .map((e)=>SavedJobBin.fromJson(e))
          .toList();

    }


    return [];


  } catch(e){

    print("BIN ERROR: $e");

    return [];

  }

}