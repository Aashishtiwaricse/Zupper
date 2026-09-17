import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';
import '../../Screens/SignInScreen/signIn.dart';
import 'package:get/get.dart';


Future<void> deleteAccount({
  required String reason,
  required String email,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");
   // final email = prefs.getString("email");

    if (token == null) {
      Get.snackbar(
        "Session Expired",
        "Please login again.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/deletecandidateaccountpermanently",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "deleteAccountReason": reason,
      }),
    );

    final body = jsonDecode(response.body);

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
  await prefs.clear();

  Get.snackbar(
    "Success",
    body["message"] ?? "Account deleted successfully.",
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 2),
  );

  await Future.delayed(const Duration(seconds: 2));

  Get.offAll(() => const LoginScreen());
} else {
      Get.snackbar(
        "Error",
        body["message"] ?? "Something went wrong.",
        snackPosition: SnackPosition.TOP,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.TOP,
    );
  }
}