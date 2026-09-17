import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    this.label,
    this.hintText,
    required this.items,
    required this.value,
    required this.itemLabel,
    required this.onChanged,
      this.validator,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.trim().isNotEmpty) ...[
          Text(
            label!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                )
              : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}