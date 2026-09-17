import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_textfield.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;

  const CustomDatePicker({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hintText,
      readOnly: true,
      validator: validator,

      suffixIcon: const Icon(Icons.calendar_today),

      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1980),
          lastDate: DateTime.now(),
          initialDate: DateTime.now(),
        );

        if (picked != null) {
controller.text = DateFormat("dd/MM/yyyy").format(picked);
        }
      },
    );
  }
}