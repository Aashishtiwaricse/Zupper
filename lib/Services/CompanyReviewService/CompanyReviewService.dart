import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/Reviews/company_review_stats_response.dart';
import 'package:zuperr/Models/Reviews/company_reviews_response.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CompanyReviewService {
  static const String baseUrl = ApiConstants.baseUrl;

  /// Review Statistics
  static Future<ReviewStats> getReviewStats(String companyId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/company/$companyId/reviews/stats"),
      headers: {"Content-Type": "application/json"},
    );
    print("rating company");
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return CompanyReviewStatsResponse.fromJson(json).data;
    }

    throw Exception("Failed to load review statistics");
  }

  /// Company Reviews
  static Future<List<CompanyReview>> getReviews(
    String companyId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/api/company/$companyId/reviews?page=$page&limit=$limit",
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return CompanyReviewsResponse.fromJson(json).data.reviews;
    }

    throw Exception("Failed to load reviews");
  }

  //post company reviews
 static Future<ReviewResponse> postReview({
  required String companyId,
  required int rating,
  required String title,
  required String content,
  required String pros,
  required String cons,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    debugPrint("========== REVIEW API ==========");
    debugPrint("Company ID: $companyId");
    debugPrint("Token exists: ${token != null && token.isNotEmpty}");
    debugPrint("URL: $baseUrl/api/company/$companyId/reviews");
    debugPrint("================================");

    final response = await http.post(
      Uri.parse("$baseUrl/api/company/$companyId/reviews"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "rating": rating,
        "title": title,
        "content": content,
        "pros": pros,
        "cons": cons,
      }),
    );

    debugPrint("Review API Status: ${response.statusCode}");
    debugPrint("Review API Response: ${response.body}");

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewResponse(
        success: true,
        message: body["message"] ?? "Review submitted successfully.",
      );
    }

    return ReviewResponse(
      success: false,
      message: body["message"] ?? "Something went wrong.",
    );
  } catch (e) {
    debugPrint("Review API Exception: $e");

    return ReviewResponse(
      success: false,
      message: "Unable to connect to server.",
    );
  }
}
}

class ReviewResponse {
  final bool success;
  final String message;

  ReviewResponse({required this.success, required this.message});
}
