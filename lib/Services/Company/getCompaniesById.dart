import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:zuperr/Models/CompanyById.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CompanyByIdService {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<CompanyById> getCompanyById(
    String companyId,
  ) async {
    final url = Uri.parse(
      "$baseUrl/api/company/$companyId",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData =
          jsonDecode(response.body);

      final result =
          CompanyByIdResponse.fromJson(
        jsonData,
      );

      return result.data;
    } else {
      throw Exception(
        "Failed to load company details",
      );
    }
  }
}