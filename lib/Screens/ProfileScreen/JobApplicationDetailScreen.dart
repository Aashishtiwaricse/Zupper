import 'package:flutter/material.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/application_progress.dart';

class JobApplicationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobApplicationDetailScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobApplicationDetailScreen> createState() =>
      _JobApplicationDetailScreenState();
}

class _JobApplicationDetailScreenState
    extends State<JobApplicationDetailScreen> {

  int selectedTab = 0;
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "applied":
        return Colors.blue;

      case "viewed":
        return Colors.orange;

      case "under review":
        return Colors.deepPurple;

      case "interview":
        return Colors.green;

      case "offer":
        return Colors.teal;

      case "rejected":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) {
      return "${diff.inDays}D ago";
    }

    if (diff.inHours > 0) {
      return "${diff.inHours}h ago";
    }

    return "${diff.inMinutes}m ago";
  }

  @override
  Widget build(BuildContext context) {
    final String status = widget.job["status"] ?? "Applied";

    final int daysSinceApplication = widget.job["daysSinceApplication"] ?? 0;
    final List skills = widget.job["skills"] ?? [];
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Application Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                ///================ HEADER =================//

                ///================ BODY =================//
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: const Color(0xFFF3F4F6),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.25),
        const Color(0xFF1877F2).withOpacity(0.25),
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF1877F2).withOpacity(0.12),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ],
  ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "$daysSinceApplication D ago",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.job["jobTitle"] ?? "-",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          widget.job["companyName"] ?? "-",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1877F2),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      (widget.job["companyName"]
                                                  ?.toString()
                                                  .isNotEmpty ??
                                              false)
                                          ? widget.job["companyName"]
                                                .toString()[0]
                                                .toUpperCase()
                                          : "C",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              const Divider(color: Colors.black54, height: 1),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Recruiter's Action",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(
                                        status,
                                      ).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: getStatusColor(status),
                                      ),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(height: 8, color: const Color(0xffF3F4F7)),

                        const SizedBox(height: 20),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Application Progress",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Timeline widget will come in Part-2
                        ApplicationProgress(status: status),

                       
                        const SizedBox(height: 25),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Job Description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            (widget.job["description"] ?? "No description available")
                                .toString(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              height: 1.7,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        if ((widget.job["aboutCompany"] ?? "")
                            .toString()
                            .isNotEmpty) ...[
                          const SizedBox(height: 30),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "About Company",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.job["aboutCompany"],
                              style: const TextStyle(
                                height: 1.6,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),

const SizedBox(height: 30),
buildTabs(),
const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget buildTabs() {
  final tabs = [
    "Technical Skills",
    "Portfolio",
    "Soft Skills",
    "Responsibilities",
  ];

  return Column(
    children: [
      SizedBox(
        height: 54,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final selected = selectedTab == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 18),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                alignment: Alignment.center,
                decoration: selected
                    ? const BoxDecoration(
                        color: Color(0xff1877F2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(22),
                        ),
                      )
                    : const BoxDecoration(),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          },
        ),
      ),

      Container(
        height: 1,
        color: Colors.grey.shade400,
      ),

      const SizedBox(height: 24),

      buildTabBody(),
            const SizedBox(height: 24),

    ],
  );
}



Widget buildTabBody() {
  switch (selectedTab) {
    case 0:
      final skills = widget.job["skills"] ?? [];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: skills.map<Widget>((skill) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "•",
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff6B7280),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      skill["name"],
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff6B7280),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );

    case 1:
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Portfolio not available.",
          style: TextStyle(
            fontSize: 17,
            color: Color(0xff6B7280),
          ),
        ),
      );

   

    default:
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Responsibilities not available.",
          style: TextStyle(
            fontSize: 17,
            color: Color(0xff6B7280),
          ),
        ),
      );
  }
}

}
