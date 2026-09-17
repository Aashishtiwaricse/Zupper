import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zuperr/Utils/AppConstants.dart';

class ReactivateAccountBottomSheet extends StatefulWidget {
  const ReactivateAccountBottomSheet({super.key});

  @override
  State<ReactivateAccountBottomSheet> createState() =>
      _ReactivateAccountBottomSheetState();
}

class _ReactivateAccountBottomSheetState
    extends State<ReactivateAccountBottomSheet> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool obscure = true;

  Future<void> reactivate() async {
    if (emailController.text.trim().isEmpty) {
      _showMessage("Please enter your email.", false);
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      _showMessage("Enter a valid email.", false);
      return;
    }

    if (passwordController.text.length < 8) {
      _showMessage(
        "Password must be at least 8 characters.",
        false,
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/reactivateaccount"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text,
        }),
      );

      final body = jsonDecode(response.body);

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body["message"] ?? "Success"),
          backgroundColor:
              response.statusCode == 200 ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage("Something went wrong.", false);
    }

    setState(() {
      loading = false;
    });
  }

  void _showMessage(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Reactivate Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email and password to reactivate your account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: decoration("Email"),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: passwordController,
                obscureText: obscure,
                decoration: decoration("Password").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : reactivate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Reactivate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
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