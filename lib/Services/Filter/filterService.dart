


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zuperr/Utils/AppConstants.dart';

class FilterService {
  static Future<Map<String, dynamic>> getFilters() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/jobs/filters"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load filters");
  }
}