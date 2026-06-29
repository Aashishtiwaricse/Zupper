import 'package:flutter/material.dart';

class DynamicFilterSection extends StatefulWidget {
  final String title;
  final List<String> values;
  final Function(Set<String>) onChanged;


  const DynamicFilterSection({
    required this.title,
    required this.values,
    required this.onChanged,

  });

  @override
  State<DynamicFilterSection> createState() =>
      _DynamicFilterSectionState();
}

class _DynamicFilterSectionState
    extends State<DynamicFilterSection> {
  bool expanded = false;
  final Map<String, bool> selected = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          ...widget.values.map(
            (item) => CheckboxListTile(
              value: selected[item] ?? false,
              onChanged: (value) {
                setState(() {
                  selected[item] = value ?? false;
                });
              },
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}