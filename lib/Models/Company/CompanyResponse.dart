class CompanyResponse {
  final bool success;
  final List<Company> data;

  CompanyResponse({
    required this.success,
    required this.data,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List? ?? [])
          .map((e) => Company.fromJson(e))
          .toList(),
    );
  }
}

class Company {
  final String id;
  final String companyName;
  final String companyLogo;
  final String companyWebsite;
  final String companySize;
  final List<String> industries;
  final String gstNumber;
  final bool isGstVerified;
  final Address address;
  final String description;
  final double averageRating;
  final int totalReviews;
  final double trustScore;
  final TrustMetrics trustMetrics;
  final TrustBadge trustBadge;
  final bool analyticsEnabled;
  final String sponsoredTier;
  final DateTime createdAt;

  Company({
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
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["_id"] ?? "",
      companyName: json["companyName"] ?? "",
      companyLogo: json["companyLogo"] ?? "",
      companyWebsite: json["companyWebsite"] ?? "",
      companySize: json["companySize"] ?? "",
      industries: List<String>.from(json["industries"] ?? []),
      gstNumber: json["gstNumber"] ?? "",
      isGstVerified: json["isGstVerified"] ?? false,
      address: Address.fromJson(json["address"] ?? {}),
      description: json["description"] ?? "",
      averageRating:
          (json["averageRating"] as num?)?.toDouble() ?? 0,
      totalReviews: json["totalReviews"] ?? 0,
      trustScore:
          (json["trustScore"] as num?)?.toDouble() ?? 0,
      trustMetrics:
          TrustMetrics.fromJson(json["trustMetrics"] ?? {}),
      trustBadge:
          TrustBadge.fromJson(json["trustBadge"] ?? {}),
      analyticsEnabled:
          json["analyticsEnabled"] ?? false,
      sponsoredTier:
          json["sponsoredTier"] ?? "",
      createdAt: DateTime.parse(
        json["createdAt"] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Address {
  final String district;
  final String state;
  final String country;
  final String line1;
  final String landmark;
  final String pincode;

  Address({
    required this.district,
    required this.state,
    required this.country,
    required this.line1,
    required this.landmark,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
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

  factory TrustMetrics.fromJson(Map<String, dynamic> json) {
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

  factory TrustBadge.fromJson(Map<String, dynamic> json) {
    return TrustBadge(
      theme: json["theme"] ?? "",
      rating:
          (json["rating"] as num?)?.toDouble() ??0,
      stars: json["stars"] ?? 0,
    );
  }
}

