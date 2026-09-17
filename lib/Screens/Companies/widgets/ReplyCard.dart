import 'package:flutter/material.dart';
import 'package:zuperr/Models/Reviews/company_reviews_response.dart';

class ReplyCard extends StatelessWidget {
  final CompanyReview reply;

  const ReplyCard({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CircleAvatar(
            radius: 14,
            backgroundImage: reply.user.profilePicture.isNotEmpty
                ? NetworkImage(reply.user.profilePicture)
                : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  reply.user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  reply.content,
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: () {},
                  child: const Text("Reply"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}