import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zuperr/Utils/AppConstants.dart';

class FilterService {
  /// GET ALL DYNAMIC FILTERS
  static Future<Map<String, dynamic>> getFilters() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employee/jobs/filters",
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to load filters: ${response.statusCode}",
    );
  }

  /// SEARCH JOBS USING SELECTED FILTERS
static Future<List<dynamic>> searchJobsByFilters(
  Map<String, Set<String>> selectedFilters,
) async {
  final List<dynamic> allJobs = [];

  // Go through every filter
  for (final entry in selectedFilters.entries) {
    // Example:
    // Cities = {Bangalore, Mumbai}

    for (final value in entry.value) {
      final searchText = value.trim();

      if (searchText.isEmpty) {
        continue;
      }

      debugPrint("================================");
      debugPrint("SEARCHING FILTER VALUE: $searchText");
      debugPrint("FILTER TYPE: ${entry.key}");
      debugPrint("================================");

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}/api/employee/jobs/search",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "searchText": searchText,
          "page": 1,
          "limit": 10,
        }),
      );

      debugPrint(
        "SEARCH STATUS ($searchText): ${response.statusCode}",
      );

      debugPrint(
        "SEARCH RESPONSE ($searchText): ${response.body}",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> jobs = List<dynamic>.from(
          data["jobs"] ??
              data["data"] ??
              [],
        );

        allJobs.addAll(jobs);
      }
    }
  }

  // Remove duplicate jobs
  final Map<String, dynamic> uniqueJobs = {};

  for (final job in allJobs) {
    final id =
        job["_id"] ??
        job["id"] ??
        job["jobId"];

    if (id != null) {
      uniqueJobs[id.toString()] = job;
    } else {
      // If API doesn't provide an ID,
      // keep the job anyway.
      uniqueJobs[job.toString()] = job;
    }
  }

  debugPrint("================================");
  debugPrint("TOTAL FILTERED JOBS: ${uniqueJobs.length}");
  debugPrint("================================");

  return uniqueJobs.values.toList();
}}