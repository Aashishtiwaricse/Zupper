import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/ChangePasswordBottomSheet.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/DeactivateAccountBottomSheet.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/MobileNumberBottomSheet.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/OTPBottomSheet.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/changeEmailBotoom.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/deleteaccountBottom.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool twoFactorEnabled = false;
  final List<String> deactivateReasons = [
    "Taking a break",
    "Found another job",
    "Privacy concerns",
    "Too many notifications",
    "Not using the app",
    "Technical issues",
    "Other",
  ];

  final reasons = [
    "Found a new job",
    "Not receiving relevant jobs",
    "Getting too many emails",
    "Getting too many calls from recruiters",
    "Duplicate account",
    "Other reason",
  ];
  String? selectedReason;

  final feedbackController = TextEditingController();

  Future<void> requestTwoFactorSetup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/employee/2fa/setup/request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({}),
      );

      debugPrint("2FA setup request: ${response.statusCode}");
      debugPrint("2FA setup response: ${response.body}");

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        final challengeToken = data["challengeToken"];

        if (challengeToken == null || challengeToken.toString().isEmpty) {
          Get.snackbar(
            "Error",
            "Challenge token not received",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Open OTP popup directly
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => OTPBottomSheet(
            challengeToken: challengeToken.toString(),
            onVerified: () async {
              await saveTwoFactorStatus(true);

              if (!mounted) return;

              setState(() {
                twoFactorEnabled = true;
              });
            },
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to start 2FA setup",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("2FA setup error: $e");

      if (mounted) {
        Get.snackbar(
          "Error",
          "Something went wrong",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> disableTwoFactor() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.delete(
        Uri.parse("${ApiConstants.baseUrl}/api/employee/2fa"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("2FA disable: ${response.statusCode}");
      debugPrint("2FA disable response: ${response.body}");

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await saveTwoFactorStatus(false);

        setState(() {
          twoFactorEnabled = false;
        });

        Get.snackbar(
          "Success",
          "Two-Factor Authentication Disabled",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to disable Two-Factor Authentication",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("2FA disable error: $e");

      if (mounted) {
        Get.snackbar(
          "Error",
          "Something went wrong",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> saveTwoFactorStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("two_factor_enabled", value);
  }

  Future<void> loadTwoFactorStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      twoFactorEnabled = prefs.getBool("two_factor_enabled") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTwoFactorStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F8),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  _settingTile(
                    title: "Change Email",
                    subtitle: "Update your registered email address",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ChangeEmailBottomSheet(),
                      );
                    },
                  ),

                  _settingTile(
                    title: "Change Password",
                    subtitle: "Set a new secure password",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ChangePasswordBottomSheet(),
                      );
                    },
                  ),

                  _switchTile(
                    title: "Two-Factor Authentication",
                    subtitle: "Add extra protection to your account",
                  ),
                  _settingTile(
                    title: "Deactivate Account",
                    subtitle: "Temporarily pause your account activity",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const DeactivateAccountBottomSheet(),
                      );
                    },
                  ),
                  _settingTile(
                    title: "Delete Account Permanently",
                    subtitle: "Erase all data and access forever",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const DeleteAccountBottomSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xff135FCB)),
      child: Stack(
        children: [
          /// Grid Background
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          /// Stars
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: StarPainter())),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 35),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 38,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 28),

                      const Text(
                        "Account & Security",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xff7B7F8A),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  size: 34,
                  color: Color(0xff1D1D1F),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Divider(height: 1, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _switchTile({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff7B7F8A),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Switch(
  value: twoFactorEnabled,
  onChanged: (value) async {
    if (value) {
      await requestTwoFactorSetup();
    } else {
      await disableTwoFactor();
    }
  },
),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .06)
      ..strokeWidth = 1;

    const gap = 38.0;

    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .7);

    final points = [
      const Offset(30, 55),
      const Offset(105, 60),
      const Offset(220, 85),
      const Offset(285, 40),
      const Offset(420, 100),
      const Offset(515, 85),
      const Offset(650, 120),
      const Offset(150, 165),
      const Offset(260, 130),
      const Offset(360, 165),
    ];

    for (final p in points) {
      canvas.drawCircle(p, 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
