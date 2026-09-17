class CompanyReviewsResponse {
  final bool success;
  final CompanyReviewsData data;

  CompanyReviewsResponse({
    required this.success,
    required this.data,
  });

  factory CompanyReviewsResponse.fromJson(
      Map<String, dynamic> json) {
    return CompanyReviewsResponse(
      success: json["success"] ?? false,
      data: CompanyReviewsData.fromJson(
        json["data"] ?? {},
      ),
    );
  }
}

class CompanyReviewsData {
  final List<CompanyReview> reviews;
  final int total;
  final int page;
  final int pages;

  CompanyReviewsData({
    required this.reviews,
    required this.total,
    required this.page,
    required this.pages,
  });

  factory CompanyReviewsData.fromJson(
      Map<String, dynamic> json) {
    return CompanyReviewsData(
      reviews: (json["reviews"] as List? ?? [])
          .map(
            (e) => CompanyReview.fromJson(e),
          )
          .toList(),

      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      pages: json["pages"] ?? 1,
    );
  }
}

class CompanyReview {
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
  final bool isFlagged;

  final int helpfulCount;

  final int upvotes;
  final int downvotes;

  final List<String> upvotedBy;
  final List<String> downvotedBy;

  final String? parentReviewId;

  final List<CompanyReview> replies;

  final DateTime createdAt;

  CompanyReview({
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
    required this.isFlagged,
    required this.helpfulCount,
    required this.upvotes,
    required this.downvotes,
    required this.upvotedBy,
    required this.downvotedBy,
    required this.parentReviewId,
    required this.replies,
    required this.createdAt,
  });

  factory CompanyReview.fromJson(
      Map<String, dynamic> json) {
    return CompanyReview(
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

      isFlagged:
          json["isFlagged"] ?? false,

      helpfulCount:
          json["helpfulCount"] ?? 0,

      upvotes: json["upvotes"] ?? 0,

      downvotes:
          json["downvotes"] ?? 0,

      upvotedBy:
          List<String>.from(
        json["upvotedBy"] ?? [],
      ),

      downvotedBy:
          List<String>.from(
        json["downvotedBy"] ?? [],
      ),

      parentReviewId:
          json["parentReviewId"],

      replies:
          (json["replies"] as List? ?? [])
              .map(
                (e) => CompanyReview.fromJson(e),
              )
              .toList(),

      createdAt:
          DateTime.tryParse(
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
      Map<String, dynamic> json) {
    return ReviewUser(
      id: json["_id"] ?? "",

      firstname:
          json["firstname"] ?? "",

      lastname:
          json["lastname"] ?? "",

      profilePicture:
          json["profilePicture"] ?? "",
    );
  }

  String get fullName =>
      "$firstname $lastname";

  String get initials {
    String first =
        firstname.isNotEmpty
            ? firstname[0]
            : "";

    String last =
        lastname.isNotEmpty
            ? lastname[0]
            : "";

    return "$first$last";
  }
}