import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zuperr/Utils/app_text_style.dart';
import 'package:zuperr/Utils/colors.dart';

class FeatureTile extends StatelessWidget {

  final String title;
  final String subtitle;

  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            Icons.check_circle_outline,
            color: AppColors.primary,
            size: 21,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

              //  const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}