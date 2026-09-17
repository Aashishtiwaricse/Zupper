import 'package:zuperr/Models/Reviews/company_reviews_response.dart';


class ReviewNode {
  final CompanyReview review;
  final int level;

  ReviewNode({
    required this.review,
    required this.level,
  });
}

List<ReviewNode> flattenReviews(
  List<CompanyReview> reviews, {
  int level = 0,
}) {
  final result = <ReviewNode>[];

  for (final review in reviews) {
    result.add(
      ReviewNode(
        review: review,
        level: level,
      ),
    );

    if (review.replies.isNotEmpty) {
      result.addAll(
        flattenReviews(
          review.replies,
          level: level + 1,
        ),
      );
    }
  }

  return result;
}