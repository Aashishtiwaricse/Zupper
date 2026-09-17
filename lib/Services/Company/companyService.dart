import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zuperr/Models/Company/CompanyResponse.dart';
import 'package:zuperr/Models/_job_response.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CompanyService {
  static Future<List<Company>> getCompanies() async {

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/company"),
    );

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      return CompanyResponse.fromJson(json).data;
    }

    return [];
  }


  static Future<List<CompanyJob>> getJobs(
    String companyId,
  ) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}/api/company/$companyId/jobs",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );print("URL: $url");
    print("from get company jobs service");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final result = CompanyJobsResponse.fromJson(json);

      return result.data.jobs;
    }

    throw Exception("Unable to fetch jobs");
  }
}