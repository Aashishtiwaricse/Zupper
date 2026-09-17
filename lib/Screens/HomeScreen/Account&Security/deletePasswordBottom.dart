import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Services/DeleteAccount/deleteAccount.dart';

class DeletePasswordBottomSheet extends StatefulWidget {
  final String reason;
  final String feedback;

  const DeletePasswordBottomSheet({
    super.key,
    required this.reason,
    required this.feedback,
  });

  @override
  State<DeletePasswordBottomSheet> createState() =>
      _DeletePasswordBottomSheetState();
}

class _DeletePasswordBottomSheetState extends State<DeletePasswordBottomSheet> {

final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .68,
      minChildSize: .68,
      maxChildSize: .68,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Drag Handle
                Center(
                  child: Container(
                    width: 90,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// Header
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.arrow_back_ios_new, size: 22),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "Please enter your Password",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    "Please enter your Password to continue",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                 // obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff135FCB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: loading
    ? null
    : () async {
        if (passwordController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please enter Password"),
            ),
          );
          return;
        }

        final prefs = await SharedPreferences.getInstance();

        final savedPassword = prefs.getString("saved_password");
        final savedEmail = prefs.getString("saved_email");

        if (savedPassword == null || savedEmail == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User information not found"),
            ),
          );
          return;
        }

        if (passwordController.text.trim() != savedPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Incorrect password"),
            ),
          );
          return;
        }

        setState(() {
          loading = true;
        });

        try {
          await deleteAccount(
            reason: widget.reason,
            email: savedEmail, // Send saved email
          );

          
        } finally {
          if (mounted) {
            setState(() {
              loading = false;
            });
          }
        }
      },
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
