import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';


Future<bool> deleteBinJob(String jobId) async {

  try {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");


    final response = await http.delete(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/savedjobs/bin/$jobId",
      ),

      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );


    print("DELETE BIN STATUS: ${response.statusCode}");
    print("DELETE BIN BODY: ${response.body}");


    if(response.statusCode == 200 ||
       response.statusCode == 204){

      return true;

    }


    return false;


  } catch(e){

    print("DELETE BIN ERROR: $e");

    return false;

  }

}