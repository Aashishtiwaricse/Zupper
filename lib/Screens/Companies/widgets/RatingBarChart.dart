import 'package:flutter/material.dart';
import 'package:zuperr/Models/Reviews/company_review_stats_response.dart';

class RatingBarChart extends StatelessWidget {
  final ReviewStats stats;

  const RatingBarChart({super.key, required this.stats});

  static const Color primary = Color(0xff1E6BE3);
  static const Color starColor = Color(0xffFFB800);
  String _formatReviews(int value) {
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}k";
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 420;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Left Side (Bars)
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _bar(5, stats.starBreakdown.five),
                  const SizedBox(height: 2),
                  _bar(4, stats.starBreakdown.four),
                  const SizedBox(height: 2),
                  _bar(3, stats.starBreakdown.three),
                  const SizedBox(height: 2),
                  _bar(2, stats.starBreakdown.two),
                  const SizedBox(height: 2),
                  _bar(1, stats.starBreakdown.one),
                ],
              ),
            ),

            SizedBox(width: mobile ? 18 : 28),

            /// Right Side
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        stats.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff2D3340),
                          height: 1,
                        ),
                      ),

                      const SizedBox(width:5),

                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xffF9A825),
                        size: 28,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Average review",
                    style: TextStyle(fontSize: 15, color: Color(0xff707784)),
                  ),

                  const SizedBox(height: 34),

                  Text(
                    _formatReviews(stats.totalReviews),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2D3340),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Total reviews",
                    style: TextStyle(fontSize: 15, color: Color(0xff707784)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bar(int star, int count) {
    final progress = stats.percentage(count);

    Color color;

    Gradient? gradient;

    switch (star) {
      case 5:
        color = const Color(0xff19B463);
        break;

      case 4:
        gradient = const LinearGradient(
          colors: [Color(0xffFF9800), Color(0xff41C352)],
        );
        color = Colors.transparent;
        break;

      case 3:
        color = const Color(0xffF39C12);
        break;

      case 2:
        color = const Color(0xffF57C00);
        break;

      default:
        color = const Color(0xffF44336);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              "$star",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff4B5563),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * progress;

                return Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xffE7EAF0),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                      width: width,
                      height: 12,
                      decoration: BoxDecoration(
                        color: gradient == null ? color : null,
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
