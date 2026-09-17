import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileMonthPicker extends StatelessWidget {
  final String label;
  final bool requiredField;
  final TextEditingController controller;

  const ProfileMonthPicker({
    super.key,
    required this.label,
    required this.controller,
    this.requiredField = false,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime initial = DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        initial = DateFormat("MMM yyyy").parse(controller.text);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat("MMM yyyy").format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xff363B44),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: label),
                if (requiredField)
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.blue),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () => _pickDate(context),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_month),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            validator: (v) {
              if (requiredField && (v == null || v.isEmpty)) {
                return "Required";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}