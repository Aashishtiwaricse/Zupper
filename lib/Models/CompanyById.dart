class CompanyByIdResponse {
  final bool success;
  final CompanyById data;

  CompanyByIdResponse({
    required this.success,
    required this.data,
  });

  factory CompanyByIdResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompanyByIdResponse(
      success: json["success"] ?? false,
      data: CompanyById.fromJson(
        json["data"] ?? {},
      ),
    );
  }
}

class CompanyById {
  final String id;
  final String companyName;
  final String companyLogo;
  final String companyWebsite;
  final String companySize;
  final List<String> industries;
  final String gstNumber;
  final bool isGstVerified;
  final CompanyAddress address;
  final String description;
  final double averageRating;
  final int totalReviews;
  final double trustScore;
  final TrustMetrics trustMetrics;
  final TrustBadge trustBadge;
  final bool analyticsEnabled;
  final String sponsoredTier;
  final DateTime createdAt;
  final List<RecentReview> recentReviews;

  CompanyById({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.companyWebsite,
    required this.companySize,
    required this.industries,
    required this.gstNumber,
    required this.isGstVerified,
    required this.address,
    required this.description,
    required this.averageRating,
    required this.totalReviews,
    required this.trustScore,
    required this.trustMetrics,
    required this.trustBadge,
    required this.analyticsEnabled,
    required this.sponsoredTier,
    required this.createdAt,
    required this.recentReviews,
  });

  factory CompanyById.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompanyById(
      id: json["_id"] ?? "",
      companyName: json["companyName"] ?? "",
      companyLogo: json["companyLogo"] ?? "",
      companyWebsite: json["companyWebsite"] ?? "",
      companySize: json["companySize"] ?? "",

      industries: List<String>.from(
        json["industries"] ?? [],
      ),

      gstNumber: json["gstNumber"] ?? "",
      isGstVerified: json["isGstVerified"] ?? false,

      address: CompanyAddress.fromJson(
        json["address"] ?? {},
      ),

      description: json["description"] ?? "",

      averageRating:
          (json["averageRating"] as num?)?.toDouble() ?? 0,

      totalReviews: json["totalReviews"] ?? 0,

      trustScore:
          (json["trustScore"] as num?)?.toDouble() ?? 0,

      trustMetrics: TrustMetrics.fromJson(
        json["trustMetrics"] ?? {},
      ),

      trustBadge: TrustBadge.fromJson(
        json["trustBadge"] ?? {},
      ),

      analyticsEnabled:
          json["analyticsEnabled"] ?? false,

      sponsoredTier:
          json["sponsoredTier"] ?? "",

      createdAt: DateTime.tryParse(
            json["createdAt"] ?? "",
          ) ??
          DateTime.now(),

      recentReviews:
          (json["recentReviews"] as List? ?? [])
              .map(
                (e) => RecentReview.fromJson(e),
              )
              .toList(),
    );
  }
}
class CompanyAddress {
  final String district;
  final String state;
  final String country;
  final String line1;
  final String landmark;
  final String pincode;

  CompanyAddress({
    required this.district,
    required this.state,
    required this.country,
    required this.line1,
    required this.landmark,
    required this.pincode,
  });

  factory CompanyAddress.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompanyAddress(
      district: json["district"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
      line1: json["line1"] ?? "",
      landmark: json["landmark"] ?? "",
      pincode: json["pincode"] ?? "",
    );
  }
}
class TrustMetrics {
  final int profileCompleteness;
  final int verifiedDocuments;
  final int responseTime;
  final int jobFulfillment;

  TrustMetrics({
    required this.profileCompleteness,
    required this.verifiedDocuments,
    required this.responseTime,
    required this.jobFulfillment,
  });

  factory TrustMetrics.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrustMetrics(
      profileCompleteness:
          json["profileCompleteness"] ?? 0,

      verifiedDocuments:
          json["verifiedDocuments"] ?? 0,

      responseTime:
          json["responseTime"] ?? 0,

      jobFulfillment:
          json["jobFulfillment"] ?? 0,
    );
  }
}
class TrustBadge {
  final String theme;
  final double rating;
  final int stars;

  TrustBadge({
    required this.theme,
    required this.rating,
    required this.stars,
  });

  factory TrustBadge.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrustBadge(
      theme: json["theme"] ?? "",

      rating:
          (json["rating"] as num?)?.toDouble() ?? 0,

      stars: json["stars"] ?? 0,
    );
  }
}
class RecentReview {
  final String id;
  final String companyId;
  final ReviewUser user;
  final int rating;
  final String title;
  final String content;
  final String pros;
  final String cons;
  final bool isCurrentCompany;
  final bool isApproved;
  final int helpfulCount;
  final DateTime createdAt;

  RecentReview({
    required this.id,
    required this.companyId,
    required this.user,
    required this.rating,
    required this.title,
    required this.content,
    required this.pros,
    required this.cons,
    required this.isCurrentCompany,
    required this.isApproved,
    required this.helpfulCount,
    required this.createdAt,
  });

  factory RecentReview.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecentReview(
      id: json["_id"] ?? "",
      companyId: json["companyId"] ?? "",

      user: ReviewUser.fromJson(
        json["userId"] ?? {},
      ),

      rating: json["rating"] ?? 0,
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      pros: json["pros"] ?? "",
      cons: json["cons"] ?? "",

      isCurrentCompany:
          json["isCurrentCompany"] ?? false,

      isApproved:
          json["isApproved"] ?? false,

      helpfulCount:
          json["helpfulCount"] ?? 0,

      createdAt: DateTime.tryParse(
            json["createdAt"] ?? "",
          ) ??
          DateTime.now(),
    );
  }
}
class ReviewUser {
  final String id;
  final String firstname;
  final String lastname;
  final String profilePicture;

  ReviewUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.profilePicture,
  });

  factory ReviewUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReviewUser(
      id: json["_id"] ?? "",
      firstname: json["firstname"] ?? "",
      lastname: json["lastname"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
    );
  }
}