import 'package:flutter/material.dart';

class ResponsiveForm extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveForm({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        int columns = 1;

        if (constraints.maxWidth >= 1100) {
          columns = 3;
        } else if (constraints.maxWidth >= 700) {
          columns = 2;
        }

        final spacing = 20.0;

        final fieldWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth -
                    ((columns - 1) * spacing)) /
                columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((e) {
            return SizedBox(
              width: fieldWidth,
              child: e,
            );
          }).toList(),
        );
      },
    );
  }
}