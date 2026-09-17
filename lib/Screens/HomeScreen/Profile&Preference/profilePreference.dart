import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/PrivacyVisibility/privacyVisibility.dart';
import 'package:zuperr/Screens/HomeScreen/Profile&Preference/job_preferences_bottom_sheet.dart';
import 'package:zuperr/Screens/ProfileScreen/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Profile & Preferences",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _tile(
                  context,
                  title: "My Profile",
                  subtitle: "View and edit your personal details",
                   onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                  
                  
                  
                  
                  
                ),
                _tile(
                  context,
                  title: "Job Preferences",
                  subtitle: "Set roles, locations, and expectations",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const JobPreferenceBottomSheet(),
                    );
                  },
                ),
                _tile(
                  context,
                  title: "Privacy Settings",
                  subtitle: "Manage visibility and data sharing",
 onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyVisibilityScreen(),
                          ),
                        );
                      },


                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 28,
            )
          ],
        ),
      ),
    );
  }
}