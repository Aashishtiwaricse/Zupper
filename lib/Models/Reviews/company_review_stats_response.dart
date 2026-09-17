class CompanyReviewStatsResponse {
  final bool success;
  final ReviewStats data;

  CompanyReviewStatsResponse({
    required this.success,
    required this.data,
  });

  factory CompanyReviewStatsResponse.fromJson(
      Map<String, dynamic> json) {
    return CompanyReviewStatsResponse(
      success: json["success"] ?? false,
      data: ReviewStats.fromJson(
        json["data"] ?? {},
      ),
    );
  }
}

class ReviewStats {
  final int totalReviews;
  final double averageRating;
  final StarBreakdown starBreakdown;

  ReviewStats({
    required this.totalReviews,
    required this.averageRating,
    required this.starBreakdown,
  });

  factory ReviewStats.fromJson(
      Map<String, dynamic> json) {
    return ReviewStats(
      totalReviews: json["totalReviews"] ?? 0,
      averageRating:
          (json["averageRating"] as num?)?.toDouble() ??
              0,
      starBreakdown: StarBreakdown.fromJson(
        json["starBreakdown"] ?? {},
      ),
    );
  }

  int get totalStars =>
      starBreakdown.one +
      starBreakdown.two +
      starBreakdown.three +
      starBreakdown.four +
      starBreakdown.five;

  double percentage(int count) {
    if (totalStars == 0) return 0;
    return count / totalStars;
  }
}

class StarBreakdown {
  final int one;
  final int two;
  final int three;
  final int four;
  final int five;

  StarBreakdown({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  });

  factory StarBreakdown.fromJson(
      Map<String, dynamic> json) {
    return StarBreakdown(
      one: json["1"] ?? 0,
      two: json["2"] ?? 0,
      three: json["3"] ?? 0,
      four: json["4"] ?? 0,
      five: json["5"] ?? 0,
    );
  }
}