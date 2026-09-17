
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';

Future<bool> restoreBinJob(String jobId) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    final response = await http.patch(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/savedjobs/bin/$jobId/restore",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("RESTORE STATUS : ${response.statusCode}");
    print("RESTORE BODY : ${response.body}");

    return response.statusCode == 200 ||
        response.statusCode == 201;
  } catch (e) {
    print(e);
    return false;
  }
}