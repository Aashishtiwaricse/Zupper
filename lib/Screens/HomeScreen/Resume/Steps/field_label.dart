import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const FieldLabel({
    super.key,
    required this.text,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xff424756),
        ),
        children: required
            ? [
                const TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                )
              ]
            : [],
      ),
    );
  }
}