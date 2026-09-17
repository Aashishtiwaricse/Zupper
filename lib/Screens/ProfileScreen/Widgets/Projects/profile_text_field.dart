import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool requiredField;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.requiredField = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  color: Color(0xff363B44),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (requiredField)
                const TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 17,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xffD9DEE8),
              ),
            ),
          ),
          validator: (value) {
            if (requiredField &&
                (value == null || value.trim().isEmpty)) {
              return "Required";
            }
            return null;
          },
        ),
      ],
    );
  }
}