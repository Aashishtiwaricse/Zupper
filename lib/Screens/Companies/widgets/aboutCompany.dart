import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';




class AboutCompany extends StatefulWidget {
  final CompanyById company;

  const AboutCompany({
    super.key,
    required this.company,
  });

  @override
  State<AboutCompany> createState() => _AboutCompanyState();
}

class _AboutCompanyState extends State<AboutCompany>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  static const Color titleColor = Color(0xff2C3141);
  static const Color bodyColor = Color(0xff6F7685);
  static const Color blue = Color(0xff2D74FF);

  @override
  Widget build(BuildContext context) {
    final description = widget.company.description.trim().isEmpty
        ? "No description available."
        : widget.company.description;

    final showButton = description.length > 180;

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 34, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          const Text(
            "About Company",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),

          const SizedBox(height: 18),

          /// DESCRIPTION
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Text(
              description,
              maxLines: expanded ? null : 5,
              overflow:
                  expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: bodyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          if (showButton) ...[
            const SizedBox(height: 20),

            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  expanded ? "Read less" : "Read more",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: blue,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}