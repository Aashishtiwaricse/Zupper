import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/appliedJobs.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/saved_Jobs.dart';


class JobManagementScreen extends StatelessWidget {
  const JobManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          /// HEADER
          Container(
            height: 165,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Row(
                  children: [

                    GestureDetector(
                      onTap: () => Navigator.pop(context),

                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Text(
                      "Job Management",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [

                _menuTile(
                  title: "Saved Jobs",
                  subtitle: "Keep track of jobs you like",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SavedJobsScreen(),
                      ),
                    );
                  },
                ),

                _menuTile(
                  title: "Applied Jobs",
                  subtitle:
                      "View jobs you've already applied",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AppliedJobsScreen(),
                      ),
                    );
                  },
                ),

                _menuTile(
                  title: "Job Alerts",
                  subtitle:
                      "Get notified about new openings",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),

        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffECECEC),
            ),
          ),
        ),

        child: Row(
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}