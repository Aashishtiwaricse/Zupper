import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/accoiunt&Security.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/job_management_screen.dart';
import 'package:zuperr/Screens/HomeScreen/PrivacyVisibility/privacyVisibility.dart';
import 'package:zuperr/Screens/HomeScreen/Profile&Preference/profilePreference.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/resume_intro_screen.dart';
import 'package:zuperr/Screens/SignInScreen/signIn.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? candidateData;

  const ProfileScreen({super.key, required this.candidateData});

  static const textColor = Color(0xff2F3542);
  static const subText = Color(0xff6B7280);
  static const divider = Color(0xffE5E7EB);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();

                // Clear all saved data
await prefs.remove("auth_token");
await prefs.remove("user_id");
await prefs.remove("email");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👤 PROFILE HEADER
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              widget.candidateData?["profilePicture"] != null
                              ? NetworkImage(
                                  widget.candidateData!["profilePicture"],
                                )
                              : const AssetImage("assets/profile.png")
                                    as ImageProvider,
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "${widget.candidateData?['firstname'] ?? ''} ${widget.candidateData?['lastname'] ?? ''}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: AppColors.subtitle,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "${widget.candidateData?['address']?['district'] ?? ''}, ${widget.candidateData?['address']?['state'] ?? ''}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: AppColors.subtitle,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                  //  const Divider(color: Colors.black54),

                    // 📋 MENU ITEMS
                                      _divider(),


                    _menuItem(
                      title: "Account & Security",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountSecurityScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),
                

                     _menuItem(
                      title: "Profile & Preferences",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _menuItem(
                      title: "Job Management",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JobManagementScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),

                    _menuItem(
                      title: "Privacy & Visibility Settings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyVisibilityScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),

                    const SizedBox(height: 10),

                    // ➕ CREATE RESUME
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResumeIntroScreen(),
                          ),
                        );
                      },

                      child: Row(
                        children: const [
                          Icon(Icons.add, size: 22),
                          SizedBox(width: 10),
                          Text(
                            "Create Resume",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              //color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // 🔴 LOGOUT BUTTON
                   SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.logoutBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    onPressed: () => _showLogoutDialog(context),
    child: const Text(
      "Logout",
      style: TextStyle(
        color: AppColors.logout,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
                    const SizedBox(height: 16),

                    // VERSION
                   const Padding(
  padding: EdgeInsets.only(top: 18),
  child: Center(
    child: Text(
      "V.1.20",
      style: TextStyle(
        color: AppColors.subtitle,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Menu Item
  Widget _menuItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: AppColors.divider);
  }
}

class AppColors {
  static const text = Color(0xff2F3542);
  static const subtitle = Color(0xff6B7280);
  static const divider = Color(0xffE5E7EB);
  static const logoutBg = Color(0xffFFF1F1);
  static const logout = Color(0xffFF3B30);
}
