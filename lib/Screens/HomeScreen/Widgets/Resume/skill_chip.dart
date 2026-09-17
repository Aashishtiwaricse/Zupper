import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {

  final String title;

  final VoidCallback onDelete;

  const SkillChip({
    super.key,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Chip(

      label: Text(title),

      deleteIcon: const Icon(Icons.close),

      onDeleted: onDelete,

    );
  }
}