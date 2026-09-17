import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Models/Reviews/company_reviews_response.dart';
import 'package:zuperr/Services/Company/ReplyReviewService.dart';
import 'package:zuperr/Services/Company/ReviewsVote/ReviewVoteService.dart';

class ReviewCard extends StatefulWidget {
  final CompanyReview review;
  final int level;

  final bool expanded;
  final VoidCallback onToggleReplies;

  const ReviewCard({
    super.key,
    required this.review,
    this.level = 0,
    required this.expanded,
    required this.onToggleReplies,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  static const primary = Color(0xff1E6BE3);
  int userVote = 0;
  bool expanded = false;

  void showReplyBottomSheet(BuildContext context, CompanyReview review) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        Container(
                          width: 70,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade50, Colors.white],
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    review.user.profilePicture.isNotEmpty
                                    ? NetworkImage(review.user.profilePicture)
                                    : null,
                                child: review.user.profilePicture.isEmpty
                                    ? Text(
                                        review.user.initials,
                                        style: const TextStyle(fontSize: 28),
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 18),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.user.fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "@${review.user.firstname.toLowerCase()}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your Reply",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 14),

                              TextField(
                                controller: controller,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: "Write your thoughts here",

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          if (controller.text.trim().isEmpty) {
                                            return;
                                          }

                                          setModalState(() {
                                            loading = true;
                                          });

                                          final result =
                                              await ReplyReviewService.reply(
                                                reviewId: review.id,
                                                content: controller.text.trim(),
                                              );

                                          if (context.mounted) {
                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  result["message"],
                                                ),
                                              ),
                                            );

                                            if (result["success"]) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff80ADF2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Post Reply",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool loading = false;
  int upvotes = 0;
  int downvotes = 0;
  bool voting = false;
  @override
  void initState() {
    super.initState();

    upvotes = widget.review.upvotes;
    downvotes = widget.review.downvotes;
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final indent = widget.level == 0 ? 0.0 : 16.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //---------------------------------------
            // Timeline
            //---------------------------------------
            SizedBox(width: indent.toDouble()),

            SizedBox(
              width: 46,
              child: Column(
                children: [
                  Container(
                    width: 2,
                    height: 10,
                    color: widget.level == 0
                        ? Colors.transparent
                        : primary.withValues(alpha: .25),
                  ),

                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xffEAF2FF),

                    backgroundImage: review.user.profilePicture.isNotEmpty
                        ? NetworkImage(review.user.profilePicture)
                        : null,

                    child: review.user.profilePicture.isEmpty
                        ? Text(
                            review.user.initials,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          )
                        : null,
                  ),

                  Expanded(
                    child: Container(
                      width: 2,
                      color: primary.withValues(alpha: .20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            //---------------------------------------
            // Main Content
            //---------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //---------------------------------------
                  // Header
                  //---------------------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              review.user.fullName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Text(
                              DateFormat("dd/MM/yy").format(review.createdAt),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  //---------------------------------------
                  // Title
                  //---------------------------------------
                  if (review.title.isNotEmpty)
                    Text(
                      review.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                  if (review.title.isNotEmpty) const SizedBox(height: 10),

                  //---------------------------------------
                  // Review Text
                  //---------------------------------------
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),

                    crossFadeState: expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,

                    firstChild: Text(
                      review.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),

                    secondChild: Text(
                      review.content,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),

                  if (review.content.length > 120)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Text(
                          expanded ? "Read less" : "Read more",
                          style: const TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                  //---------------------------------------
                  // Pros
                  //---------------------------------------
                  if (review.pros.isNotEmpty)
                    _section(
                      Icons.thumb_up_alt,
                      Colors.green,
                      "Pros",
                      review.pros,
                    ),

                  //---------------------------------------
                  // Cons
                  //---------------------------------------
                  if (review.cons.isNotEmpty)
                    _section(
                      Icons.thumb_down_alt,
                      Colors.red,
                      "Cons",
                      review.cons,
                    ),

                  const SizedBox(height: 18),
                  const Divider(height: 28),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _actionButton(Icons.reply_rounded, "Reply", () {
                          showReplyBottomSheet(context, review);
                        }),

                        const SizedBox(width: 12),

                        _actionButton(
                          Icons.arrow_circle_up_outlined,
                          "$upvotes",
                          () async {
                            if (voting || userVote == 1) return;

                            voting = true;

                            final result = await ReviewVoteService.upvote(
                              review.id,
                            );

                            voting = false;

                            if (result["success"]) {
                              setState(() {
                                if (userVote == -1) {
                                  downvotes--;
                                }

                                upvotes++;
                                userVote = 1;
                              });
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result["message"])),
                                );
                              }
                            }
                          },
                            iconColor: userVote == 1 ? Colors.blue : primary,

                        ),

                        const SizedBox(width: 12),

                        _actionButton(
                          Icons.arrow_circle_down_outlined,
                          "$downvotes",
                          () async {
                            if (voting || userVote == -1) return;

                            voting = true;

                            final result = await ReviewVoteService.downvote(
                              review.id,
                            );

                            voting = false;

                            if (result["success"]) {
                              setState(() {
                                if (userVote == 1) {
                                  upvotes--;
                                }

                                downvotes++;
                                userVote = -1;
                              });
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result["message"])),
                                );
                              }
                            }
                          },  iconColor: userVote == -1 ? Colors.red : primary,

                          
                        ),

                        const SizedBox(width: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${review.helpfulCount} Helpful",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (review.replies.isNotEmpty) ...[
                    const SizedBox(height: 18),

                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: widget.onToggleReplies,

                      child: Row(
                        children: [
                          AnimatedRotation(
                            turns: widget.expanded ? .25 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: primary),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: primary,
                                size: 13,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            widget.expanded
                                ? "Hide replies"
                                : "${review.replies.length} more replies",
                            style: const TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(IconData icon, Color color, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),

          const SizedBox(width: 8),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget _actionButton(
  IconData icon,
  String title,
  VoidCallback onTap, {
  Color iconColor = primary,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withValues(alpha: .4)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 7),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}
}
