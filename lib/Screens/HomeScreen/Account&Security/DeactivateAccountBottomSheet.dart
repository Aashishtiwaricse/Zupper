import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/passConfieBotmSheet.dart';

class DeactivateAccountBottomSheet extends StatefulWidget {
  const DeactivateAccountBottomSheet({super.key});

  @override
  State<DeactivateAccountBottomSheet> createState() =>
      _DeactivateAccountBottomSheetState();
}

class _DeactivateAccountBottomSheetState
    extends State<DeactivateAccountBottomSheet> {
  String? reason;

  final reasons = [
    "Taking a break",
    "Found another job",
    "Privacy concerns",
    "Too many notifications",
    "Not using the app",
    "Technical issues",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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

            const SizedBox(height: 24),

            const Text(
              "Deactivate Account",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),

            const SizedBox(height: 14),

            const Text(
              "Temporarily disables your profile; your details stay hidden, but Messenger remains active.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm with reason",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: reason,
              decoration: InputDecoration(
                hintText: "Select a reason",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: reasons.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (v) {
                setState(() {
                  reason = v;
                });
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7FAEEB),
                    disabledBackgroundColor: const Color(0xFF7FAEEB), // disabled color

                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: reason == null
                    ? null
                    : () {
                        Navigator.pop(context);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) =>
                              PasswordConfirmationBottomSheet(reason: reason!),
                        );
                      },

                child: const Text(
                  "Deactivate & Logout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
