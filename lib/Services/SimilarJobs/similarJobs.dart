import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zuperr/Models/SimilarJobs.dart';

import 'package:zuperr/Utils/AppConstants.dart';

class SimilarJobsService {
  static Future<List<SimilarJobModel>> fetchSimilarJobs(
  String jobId,
) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/jobs/similar/$jobId",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

     return (data["similarJobs"] as List)
    .map((e) => SimilarJobModel.fromJson(e))
    .toList();
    }

    return [];
  }
}