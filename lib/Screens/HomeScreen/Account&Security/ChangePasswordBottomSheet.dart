import 'package:flutter/material.dart';
import 'package:zuperr/Services/AccountUpdateService/accountUpdate.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool loading = false;

  bool hideOld = true;
  bool hideNew = true;
  bool hideConfirm = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Handle
                  Container(
                    width: 72,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xff50535E),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2F3443),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Your password must be at least 6 characters and\n"
                    "should include a combination of number, letter and\n"
                    "special characters (!\$@%)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xff8A8F9D),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _label("Old Password"),

                  const SizedBox(height: 10),

                  _passwordField(
                    controller: oldPass,
                    hint: "Enter your old password",
                    obscure: hideOld,
                    onTap: () {
                      setState(() {
                        hideOld = !hideOld;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  _label("New Password"),

                  const SizedBox(height: 10),

                  _passwordField(
                    controller: newPass,
                    hint: "Enter your new password",
                    obscure: hideNew,
                    onTap: () {
                      setState(() {
                        hideNew = !hideNew;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  _label("Confirm New Password"),

                  const SizedBox(height: 10),

                  _passwordField(
                    controller: confirmPass,
                    hint: "Confirm your new password",
                    obscure: hideConfirm,
                    onTap: () {
                      setState(() {
                        hideConfirm = !hideConfirm;
                      });
                    },
                  ),

                  const SizedBox(height: 34),

                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7FAEEB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                              if (newPass.text != confirmPass.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Passwords do not match"),
                                  ),
                                );
                                return;
                              }

                              setState(() => loading = true);

                              final result =
                                  await AccountSecurityService.updatePassword(
                                    oldPass.text.trim(),
                                    newPass.text.trim(),
                                  );

                              setState(() => loading = false);
                                                              Navigator.pop(context);


                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result.message),
                                  backgroundColor: result.success
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );

                              if (result.success) {
                                Navigator.pop(context);
                              }
                            },
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xff3B4252),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 60,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 16, color: Color(0xff3B4252)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xffA6ACB8), fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey.shade500,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff7FAEEB), width: 1.5),
          ),
        ),
      ),
    );
  }
}
