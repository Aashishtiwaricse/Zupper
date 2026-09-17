import 'package:flutter/material.dart';
import 'package:zuperr/Models/Reviews/company_review_stats_response.dart';
import 'package:zuperr/Models/Reviews/company_reviews_response.dart';
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

class CompanyReviewsScreen extends StatefulWidget {
  final String companyId;
  final String companyName;

  const CompanyReviewsScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<CompanyReviewsScreen> createState() => _CompanyReviewsScreenState();
}

class _CompanyReviewsScreenState extends State<CompanyReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  ReviewStats? stats;

  List<CompanyReview> reviews = [];

  bool loading = true;
  bool loadingMore = false;
  bool hasMore = true;

  int page = 1;
  final int limit = 10;

  String? error;

  @override
  void initState() {
    super.initState();

    _loadInitial();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 250 &&
        !loadingMore &&
        hasMore) {
      _loadMore();
    }
  }

  void showReviewBottomSheet(
    BuildContext context, {
    required String companyId,
    required String companyName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) =>
          ReviewBottomSheet(companyId: companyId, companyName: companyName),
    );
  }

  Future<void> _loadInitial() async {
    setState(() {
      loading = true;
      error = null;
      page = 1;
    });

    try {
      final result = await Future.wait([
        CompanyReviewService.getReviewStats(widget.companyId),
        CompanyReviewService.getReviews(
          widget.companyId,
          page: 1,
          limit: limit,
        ),
      ]);

      stats = result[0] as ReviewStats;

      reviews = result[1] as List<CompanyReview>;

      hasMore = reviews.length == limit;
    } catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> _loadMore() async {
    loadingMore = true;

    page++;

    try {
      final more = await CompanyReviewService.getReviews(
        widget.companyId,
        page: page,
        limit: limit,
      );

      reviews.addAll(more);

      hasMore = more.length == limit;
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      loadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!)),
      );
    }
    final reviewItems = flattenReviews(reviews, expandedReviewIds);
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Ratings & Reviews",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff1E6BE3),
        onPressed: () {
          showReviewBottomSheet(
            context,
            companyId: widget.companyId,
            companyName:
                widget.companyName, // or pass from CompanyDetailsScreen
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text("Write Review"),
      ),

      body: RefreshIndicator(
        onRefresh: _loadInitial,

        child: ListView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: RatingBarChart(stats: stats!),
            ),

            const SizedBox(height: 24),

            const Text(
              "Reviews",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 18),
            if (reviews.isEmpty)
              Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "No Reviews Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Be the first one to review this company.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

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

            if (loadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              ),

            if (!loadingMore && !hasMore && reviews.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    "You've reached the end",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
