import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/accoiunt&Security.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/job_management_screen.dart';
import 'package:zuperr/Screens/HomeScreen/PrivacyVisibility/privacyVisibility.dart';
import 'package:zuperr/Screens/HomeScreen/Profile&Preference/profilePreference.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const textColor = Color(0xff2F3542);
  static const subText = Color(0xff6B7280);
  static const divider = Color(0xffE5E7EB);

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
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 34,
                          backgroundImage: AssetImage("assets/profile.png"),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Guillem B.",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: subText,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Dombivli, Maharashtra",
                                  style: TextStyle(
                                    color: subText,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Divider(color: divider),

                    // 📋 MENU ITEMS
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountSecurityScreen(),
                          ),
                        );
                      },
                      child: _menuItem("Account & Security"),
                    ),
                    _divider(),
                    GestureDetector(
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      
                      
                      
                      child: _menuItem("Profile & Preferences")),
                    _divider(),
                    GestureDetector(
                      
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JobManagementScreen(),
                          ),
                        );
                      },
                      child: _menuItem("Job Management")),
                    _divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyVisibilityScreen(),
                          ),
                        );
                      },

                      child: _menuItem("Privacy & Visibility Settings"),
                    ),
                    _divider(),

                    const SizedBox(height: 10),

                    // ➕ CREATE RESUME
                    Row(
                      children: const [
                        Icon(Icons.add, size: 22, color: textColor),
                        SizedBox(width: 10),
                        Text(
                          "Create Resume",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // 🔴 LOGOUT BUTTON
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xffFDECEC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // VERSION
                    const Center(
                      child: Text(
                        "v.1.01",
                        style: TextStyle(color: subText, fontSize: 14),
                      ),
                    ),
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
  Widget _menuItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(color: divider);
  }
}
