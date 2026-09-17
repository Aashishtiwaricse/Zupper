import 'package:flutter/material.dart';

class ResumeHeader extends StatelessWidget {
  const ResumeHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      color: const Color(0xff2563EB),

      child: Row(

        children: const [

          BackButton(
            color: Colors.white,
          ),

          SizedBox(width: 12),

          Text(
            "Resume Builder",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}