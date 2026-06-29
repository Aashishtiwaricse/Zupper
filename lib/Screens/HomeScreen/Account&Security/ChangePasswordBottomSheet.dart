import 'package:flutter/material.dart';
import 'package:zuperr/Services/AccountUpdateService/accountUpdate.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState
    extends State<ChangePasswordBottomSheet> {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Change Password",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: oldPass,
            decoration: const InputDecoration(
              hintText: "Old Password",
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: newPass,
            decoration: const InputDecoration(
              hintText: "New Password",
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);

                      final success =
                          await AccountSecurityService
                              .updatePassword(
                                oldPass.text,
                                newPass.text,
                              );

                      setState(() => loading = false);

                      if (success) {
                        Navigator.pop(context);
                      }
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}