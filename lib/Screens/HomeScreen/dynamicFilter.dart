import 'package:flutter/material.dart';

class DynamicFilterSection extends StatefulWidget {
  final String title;
  final List values;
  final Set<String> selectedValues;
  final Function(Set<String>) onChanged;

  const DynamicFilterSection({
    super.key,
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  State<DynamicFilterSection> createState() =>
      _DynamicFilterSectionState();
}

class _DynamicFilterSectionState extends State<DynamicFilterSection> {
  bool expanded = false;

  late Set<String> selected;

  @override
  void initState() {
    super.initState();

    // Load previously selected filters
    selected = Set<String>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(covariant DynamicFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedValues != widget.selectedValues) {
      selected = Set<String>.from(widget.selectedValues);
    }
  }

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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
            (item) {
              final String itemValue = item.toString();

              return CheckboxListTile(
                value: selected.contains(itemValue),

                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selected.add(itemValue);
                    } else {
                      selected.remove(itemValue);
                    }
                  });

                  // Send updated selection to FilterDrawer
                  widget.onChanged(
                    Set<String>.from(selected),
                  );
                },

                title: Text(itemValue),

                controlAffinity:
                    ListTileControlAffinity.leading,

                contentPadding: EdgeInsets.zero,

                dense: true,
              );
            },
          ),

        const SizedBox(height: 12),
      ],
    );
  }
}