import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';
import 'package:zuperr/Models/Reviews/company_review_stats_response.dart';
import 'package:zuperr/Models/Reviews/company_reviews_response.dart';
import 'package:zuperr/Screens/Companies/widgets/CompanyReviewsScreen.dart';
import 'package:zuperr/Screens/Companies/widgets/RatingBarChart.dart';
import 'package:zuperr/Screens/Companies/widgets/ReviewBottomSheet.dart';
import 'package:zuperr/Screens/Companies/widgets/trust_score_card.dart';
import 'package:zuperr/Services/CompanyReviewService/CompanyReviewService.dart';

class ReviewNode {
  final CompanyReview review;
  final int level;

  ReviewNode({required this.review, required this.level});
}

final Set<String> expandedReviewIds = {};

List<ReviewNode> flattenReviews(
  List<CompanyReview> reviews,
  Set<String> expandedIds, {
  int level = 0,
}) {
  final result = <ReviewNode>[];

  for (final review in reviews) {
    result.add(ReviewNode(review: review, level: level));

    // Only include children if this review is expanded
    if (expandedIds.contains(review.id)) {
      result.addAll(
        flattenReviews(review.replies, expandedIds, level: level + 1),
      );
    }
  }

  return result;
}

class RatingsReviewsCard extends StatefulWidget {
  final CompanyById company;

  const RatingsReviewsCard({super.key, required this.company});

  @override
  State<RatingsReviewsCard> createState() => _RatingsReviewsCardState();
}

class _RatingsReviewsCardState extends State<RatingsReviewsCard> {
  bool loading = true;

  ReviewStats? stats;

  List<CompanyReview> reviews = [];

  String? error;

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

Future<void> loadReviews() async {
  if (mounted) {
    setState(() {
      loading = true;
      error = null;
    });
  }

  try {
    final result = await Future.wait([
      CompanyReviewService.getReviewStats(widget.company.id),
      CompanyReviewService.getReviews(
        widget.company.id,
        page: 1,
        limit: 2,
      ),
    ]);

    stats = result[0] as ReviewStats;
    reviews = result[1] as List<CompanyReview>;
  } catch (e) {
    error = e.toString();
  } finally {
    loading = false;

    if (mounted) {
      setState(() {});
    }
  }
}

Future<void> showReviewBottomSheet(
  BuildContext context, {
  required String companyId,
  required String companyName,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => ReviewBottomSheet(
      companyId: companyId,
      companyName: companyName,
    ),
  );

  if (result == true && mounted) {
    await loadReviews();
  }
}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        child: Center(child: Text(error!)),
      );
    }

    if (stats == null) {
      return const SizedBox();
    }
    final reviewItems = flattenReviews(reviews, expandedReviewIds);

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              const Text(
                "Ratings & Reviews",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompanyReviewsScreen(
                        companyId: widget.company.id,
                        companyName: widget.company.companyName,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E6BE3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "Company reviews are submitted by current and former employees.",
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),

          const SizedBox(height: 26),

          RatingBarChart(stats: stats!),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                showReviewBottomSheet(
                  context,
                  companyId: widget.company.id,
                  companyName: widget
                      .company
                      .companyName, // or pass from CompanyDetailsScreen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),

              icon: const Icon(Icons.rate_review, color: Colors.black),

              label: const Text(
                "Write Review",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),
      ...reviewItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: ReviewCard(
                  review: item.review,
                  level: item.level,
                  expanded: expandedReviewIds.contains(item.review.id),
                  onToggleReplies: () {
                    setState(() {
                      if (expandedReviewIds.contains(item.review.id)) {
                        expandedReviewIds.remove(item.review.id);
                      } else {
                        expandedReviewIds.add(item.review.id);
                      }
                      print(expandedReviewIds);
                      print(item.review.replies.length);
                    });
                  },
                  
                ),
              ),
            ),
          if (stats!.totalReviews > 2)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyReviewsScreen(
                          companyId: widget.company.id,
                          companyName: widget.company.companyName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "View all ${stats!.totalReviews} reviews",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
