import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Utils/AppConstants.dart';


class ProfileUpdateService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<bool> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");

      final response = await _dio.put(
        "/api/employee/profile",
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } on DioException catch (e) {
      print("Status Code : ${e.response?.statusCode}");
      print("Response : ${e.response?.data}");
      return false;
    }
  }

  /// Generic method to update any profile field
  Future<bool> updateSingleField({
    required String fieldName,
    required dynamic value,
  }) async {
    return await updateProfile(
      data: {
        fieldName: value,
      },
    );
  }
}