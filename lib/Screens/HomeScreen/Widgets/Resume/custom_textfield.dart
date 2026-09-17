import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
      this.isRequired = false,

    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        
        if (label != null && label!.trim().isNotEmpty) ...[
  Row(
    children: [
      Text(
        label!,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      if (isRequired) // only show * when label exists
        const Text(
          " *",
          style: TextStyle(
            color: Color(0xFF1877F2),
            fontWeight: FontWeight.w600,
          ),
        ),
    ],
  ),
  const SizedBox(height: 8),
],
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          validator: validator,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide(
                color: Color(0xff2563EB),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}