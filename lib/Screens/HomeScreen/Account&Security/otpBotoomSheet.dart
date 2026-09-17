import 'package:flutter/material.dart';
import 'package:zuperr/Services/AccountUpdateService/accountUpdate.dart';


class OtpBottomSheet extends StatefulWidget {
  final String emailUpdateToken;

  const OtpBottomSheet({
    super.key,
    required this.emailUpdateToken,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController otpController = TextEditingController();

  bool loading = false;
  String? errorMessage;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Please enter the OTP.";
      });
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

  final result = await AccountSecurityService.verifyEmailOtp(
  otp: otpController.text.trim(),
  emailUpdateToken: widget.emailUpdateToken,
);
    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (result["success"] == true) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"] ?? "Email updated successfully."),
        ),
      );

      // Navigate if required
      // Navigator.pushReplacement(...);
    } else {
      setState(() {
        errorMessage = result["message"] ?? "Invalid OTP";
      });
    }
  }

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
          Container(
            width: 70,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Verify OTP",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Enter the OTP sent to your email",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: "Enter OTP",
              counterText: "",
              errorText: errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: loading ? null : verifyOtp,
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Verify OTP"),
            ),
          ),
        ],
      ),
    );
  }
}