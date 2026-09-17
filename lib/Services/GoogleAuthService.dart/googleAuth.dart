import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/AppConstants.dart';


class GoogleAuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<Map<String, dynamic>> signInWithGoogle() async {
  try {
    await googleSignIn.initialize();

    final GoogleSignInAccount account =
        await googleSignIn.authenticate();

    final GoogleSignInAuthentication auth =
        account.authentication;

    final String? googleToken = auth.idToken;

    if (googleToken == null) {
      throw Exception("Google ID Token not found");
    }

    print("Google Token:");
    print(googleToken);

    final response = await dio.post(
      "${ApiConstants.baseUrl}/api/employee/google/callback",
      data: {
        "token": googleToken,
        "userType": "employee"

      },
    );

    final prefs = await SharedPreferences.getInstance();

    print(response.data);

    if (response.data["signInToken"] != null) {
      await prefs.setString(
        "auth_token",
        response.data["signInToken"],
      );
    }

    if (response.data["userID"] != null) {
      await prefs.setString(
        "user_id",
        response.data["userID"].toString(),
      );
    }

    if (response.data["user"] != null) {
      await prefs.setString(
        "email",
        response.data["user"]["email"] ?? "",
      );
    }

    return response.data;
  } on DioException catch (e) {
    print("===== DIO ERROR =====");
    print("Status Code: ${e.response?.statusCode}");
    print("Response: ${e.response?.data}");
    print("Message: ${e.message}");
    rethrow;
  } catch (e) {
    throw Exception(e.toString());
  }
}
}