import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/otpBotoomSheet.dart';
import 'package:zuperr/Services/AccountUpdateService/accountUpdate.dart';

class ChangeEmailBottomSheet extends StatefulWidget {
  const ChangeEmailBottomSheet({super.key});

  @override
  State<ChangeEmailBottomSheet> createState() => _ChangeEmailBottomSheetState();
}

class _ChangeEmailBottomSheetState extends State<ChangeEmailBottomSheet> {
  final oldEmailController = TextEditingController();
  final newEmailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  String? error;
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(email);
  }

  String? _validateInputs() {
    final newEmail = newEmailController.text.trim();
    final password = passwordController.text;

    if (newEmail.isEmpty) {
      return "Please enter your new email.";
    }

    if (!_isValidEmail(newEmail)) {
      return "Please enter a valid email address.";
    }

    if (newEmail == oldEmailController.text.trim()) {
      return "New email must be different from your current email.";
    }

    if (password.isEmpty) {
      return "Please enter your password.";
    }

    // if (password.length < 8) {
    //   return "Password must be at least 8 characters long.";
    // }

    // if (!RegExp(r'[A-Z]').hasMatch(password)) {
    //   return "Password must contain at least one uppercase letter.";
    // }

    // if (!RegExp(r'[a-z]').hasMatch(password)) {
    //   return "Password must contain at least one lowercase letter.";
    // }

    // if (!RegExp(r'[0-9]').hasMatch(password)) {
    //   return "Password must contain at least one number.";
    // }

    // if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=]').hasMatch(password)) {
    //   return "Password must contain at least one special character.";
    // }

    return null;
  }

  @override
  void initState() {
    super.initState();
    loadEmail();
  }

  Future<void> loadEmail() async {
    final email = await AccountSecurityService.getCurrentEmail();
    oldEmailController.text = email ?? "";
    setState(() {});
  }

  Widget buildField({
    required String title,
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff3A3A3A),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff6DA7F2)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Change Email",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
              ),

              const SizedBox(height: 6),

              const Text(
                "Update your registered email address",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 28),

              buildField(
                title: "Email Address",
                controller: oldEmailController,
                readOnly: true,
              ),

              const SizedBox(height: 22),

              buildField(
                title: "New Email",
                controller: newEmailController,
                hint: "Enter your new email",
              ),

              const SizedBox(height: 22),

              buildField(
                title: "Password",
                controller: passwordController,
                hint: "Enter your account password",
                obscure: hidePassword,
                suffix: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),

              if (error != null) ...[
                const SizedBox(height: 15),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7FB2F8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          final validationError = _validateInputs();

                          if (validationError != null) {
                            setState(() {
                              error = validationError;
                            });
                            return;
                          }

                          setState(() {
                            loading = true;
                            error = null;
                          });

                          final result =
                              await AccountSecurityService.validateEmployerEmail(
                                oldEmail: oldEmailController.text.trim(),
                                newEmail: newEmailController.text.trim(),
                                password: passwordController.text,
                              );

                          setState(() {
                            loading = false;
                          });

                          if (result["success"] == true) {
  final emailUpdateToken = result["EmailUpdatetoken"];
  print(result);
print(result["EmailUpdatetoken"]);

  Navigator.pop(context);

  Future.microtask(() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OtpBottomSheet(
        emailUpdateToken: emailUpdateToken,
      ),
    );
  });

  return;
}

setState(() {
  error = result["message"];
});

                          setState(() {
                            error = result["message"] ?? "Something went wrong";
                          });
                        },
                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
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
    );
  }
}
