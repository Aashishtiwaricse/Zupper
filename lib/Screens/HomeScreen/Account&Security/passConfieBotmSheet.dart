import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/ConfirmationBottomSheet.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/DeactivateAccountBottomSheet.dart';

class PasswordConfirmationBottomSheet extends StatefulWidget {
  final String reason;

  const PasswordConfirmationBottomSheet({super.key, required this.reason});

  @override
  State<PasswordConfirmationBottomSheet> createState() =>
      _PasswordConfirmationBottomSheetState();
}

class _PasswordConfirmationBottomSheetState
    extends State<PasswordConfirmationBottomSheet> {
  final TextEditingController passwordController = TextEditingController();

  bool obscure = true;
  bool loading = false;

  Future<bool> verifyPassword(String enteredPassword) async {
    final prefs = await SharedPreferences.getInstance();

    final savedPassword = prefs.getString("saved_password");

    if (savedPassword == null) {
      return false;
    }

    return enteredPassword == savedPassword;
  }

  Future<void> onNextPressed() async {
    final isValid = await verifyPassword(passwordController.text.trim());

    if (!isValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Incorrect password")));
      return;
    }

    // Close current password bottom sheet
    Navigator.pop(context);

    // Open confirmation bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfirmationBottomSheet(
        reason: widget.reason,
        password: passwordController.text.trim(),
      ),
    );
  }

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


            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const DeactivateAccountBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                  const Text(
              "Please enter your password",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
              ],
            ),

          

            const SizedBox(height: 10),

            const Text(
              "Please enter your password to continue",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (passwordController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter your password"),
                            ),
                          );
                          return;
                        }

                        final prefs = await SharedPreferences.getInstance();
                        final savedPassword = prefs.getString("saved_password");

                        if (savedPassword == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No saved password found"),
                            ),
                          );
                          return;
                        }

                        if (savedPassword != passwordController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Incorrect password")),
                          );
                          return;
                        }

                        // Password matched
                        Navigator.pop(context);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ConfirmationBottomSheet(
                            reason: widget.reason,
                            password: passwordController.text.trim(),
                          ),
                        );
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
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
