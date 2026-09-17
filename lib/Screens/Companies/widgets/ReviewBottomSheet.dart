import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:zuperr/Services/CompanyReviewService/CompanyReviewService.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String companyId;
  final String companyName;

  const ReviewBottomSheet({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int rating = 0;

  final reviewController = TextEditingController();

  bool isPosting = false;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  String _ratingText() {
    switch (rating) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent";
      default:
        return "Tap a star to rate";
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: Container(
          height: media.size.height * .88,
          decoration: const BoxDecoration(
            color: Color(0xffF7F8FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 14),

              Container(
                width: 56,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              const SizedBox(height: 22),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Write a review",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1A1A1A),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.close, size: 28),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// COMPANY CARD
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xffE8ECF2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 58,
                              width: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xffEEF4FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Color(0xff1E6BE3),
                                size: 32,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.companyName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  const Text(
                                    "Share your experience with others",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 34),

                      const Center(
                        child: Text(
                          "How would you rate this company?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final selected = index < rating;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                rating = index + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  selected
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: 46,
                                  color: selected
                                      ? const Color(0xffFFC107)
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: Text(
                          _ratingText(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      /// REVIEW LABEL
                      const Text(
                        "Write your review",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1A1A1A),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// REVIEW TEXTFIELD
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xffE3E8EF)),
                        ),
                        child: TextField(
                          controller: reviewController,
                          maxLines: 7,
                          minLines: 7,
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(fontSize: 15, height: 1.6),
                          decoration: InputDecoration(
                            hintText:
                                "Tell others about your experience working at ${widget.companyName}...",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15,
                              height: 1.5,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${reviewController.text.length}/1000",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isPosting
                              ? null
                              : () async {
                                  if (rating == 0) {
                                    Get.snackbar(
                                      "Validation",
                                      "Please give a rating.",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red.shade600,
                                      colorText: Colors.white,
                                      icon: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.all(12),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                      snackStyle: SnackStyle.FLOATING,
                                    );
                                    return;
                                  }

                                  if (reviewController.text.trim().length <
                                      10) {
                                    Get.snackbar(
                                      "Error",
                                      "Please write at least 10 characters..",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red.shade600,
                                      colorText: Colors.white,
                                      icon: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.all(12),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                      snackStyle: SnackStyle.FLOATING,
                                    );
                                    return;
                                  }

                                  setState(() {
                                    isPosting = true;
                                  });

                                  final result =
                                      await CompanyReviewService.postReview(
                                        companyId: widget.companyId,
                                        rating: rating,
                                        title: _ratingText(),
                                        content: reviewController.text.trim(),
                                        pros: "",
                                        cons: "",
                                      );

                                  if (!mounted) return;

                                  setState(() {
                                    isPosting = false;
                                  });

                                  if (result.success) {
                                    Navigator.pop(context, true);

                                    Get.snackbar(
                                      "Success",
                                      "Review submitted successfully.",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.green.shade600,
                                      colorText: Colors.white,
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.all(12),
                                      borderRadius: 12,
                                      snackStyle: SnackStyle.FLOATING,
                                    );
                                  } else {
                                   Get.snackbar(
  "Error",
  result.message,
  snackPosition: SnackPosition.TOP,
  backgroundColor: Colors.red.shade600,
  colorText: Colors.white,
  icon: const Icon(Icons.error, color: Colors.white),
  margin: const EdgeInsets.all(12),
  borderRadius: 12,
  snackStyle: SnackStyle.FLOATING,
);
                                  }

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text("Review submitted."),
                                  //   ),
                                  // );
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff1E6BE3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isPosting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Post Review",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
