import 'package:flutter/material.dart';

class AddCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddCategoryCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue),
          color: Colors.blue.withValues(alpha: .05),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit,size: 10,),
              SizedBox(width: 8),
              Text(
                "Edit Categories",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}