import 'package:flutter/material.dart';

class AddMoreButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const AddMoreButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: Text(title),
      ),
    );
  }
}