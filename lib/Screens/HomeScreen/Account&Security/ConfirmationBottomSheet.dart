import 'package:flutter/material.dart';
import 'package:zuperr/Services/DeleteAccount/deactivate.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String reason;
  final String password;

  const ConfirmationBottomSheet({
    super.key,
    required this.reason,
    required this.password,
  });
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

            const Row(
              children: [
                Icon(Icons.arrow_back_ios),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Temporary Account Deactivation",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 18),

            const Text(
              "Your profile and messages will pause until you log in.",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 18),

            const Text(
              "I understand that deactivating my Zuperr account will hide my profile from recruiters and pause all job-related communication. I won't receive any updates or alerts until I log in again to reactivate my account.",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(

onPressed: () async {
  print("Button Clicked");
  print("Reason: $reason");

  await deactivateAccount(
    context,
    reason,
  );

  print("API Finished");
},
style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF1877F2),
  disabledBackgroundColor: const Color(0xFF1877F2).withValues(alpha: 0.4),
  foregroundColor: Colors.white,
  disabledForegroundColor: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
),
                child: const Text(
                  "Deactivate & Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}