import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEEF5FF),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xffD5E5FF),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff1E6BE3),
        ),
      ),
    );
  }
}