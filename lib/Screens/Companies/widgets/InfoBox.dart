import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoBox({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 78,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xffF8FBFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xffDCE8FF),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xff1E6BE3),
              size: 22,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xff123D7A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}