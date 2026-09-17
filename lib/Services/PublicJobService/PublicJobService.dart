import 'package:dio/dio.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class PublicJobService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  static Future<Map<String, dynamic>?> getJob(String jobId) async {
    try {
      final response = await _dio.get(
        '/api/public/jobs/$jobId',
      );

      print("Public Job API Response: ${response.data}");

      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic>) {

        final responseData =
            Map<String, dynamic>.from(response.data);

        if (responseData['success'] == true &&
            responseData['job'] is Map<String, dynamic>) {

          return Map<String, dynamic>.from(
            responseData['job'],
          );
        }
      }

      return null;
    } on DioException catch (e) {
      print(
        "Public Job API Error: ${e.response?.data}",
      );

      return null;
    } catch (e) {
      print(
        "Public Job Error: $e",
      );

      return null;
    }
  }
}