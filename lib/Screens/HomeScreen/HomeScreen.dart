import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zuperr/Screens/HomeScreen/SearchResultsScreen.dart';
import 'package:zuperr/Screens/HomeScreen/allJobs.dart';
import 'package:zuperr/Screens/HomeScreen/categoryJobsScreen.dart';
import 'package:zuperr/Screens/HomeScreen/filterDrawer.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart'
    show JobDetailScreen;
import 'package:zuperr/Screens/HomeScreen/notificationScreen.dart';
import 'package:zuperr/Screens/ProfileScreen/userProfile.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/RecommendedJobs/recommendedJobs.dart';
import 'package:zuperr/Utils/AppConstants.dart';

//Email: john.doe@example.com
//Password: TestPass@123

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const blue = Color(0xff1E6BE3);
  static const bg = Color(0xffF8F8F8);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> recommendedJobs = [];
  List<dynamic> filteredJobs = [];
  bool isLoading = false;
  Map<String, dynamic>? candidateData;
  String? selectedCategory;
  final TextEditingController searchController = TextEditingController();
  bool isFilterApplied = false;
bool isServiceSuspended = false;

  @override
  void initState() {
    super.initState();
    loadRecommendedJobs();
    loadCandidateData();
  }

  Future<void> loadCandidateData() async {
    final data = await CandidateService.getCandidateData();

    if (mounted) {
      setState(() {
        candidateData = data;
      });
    }
  }

  Future<void> loadRecommendedJobs() async {
    setState(() {
      isLoading = true;
    });

    final jobs = await RecommendedJobsService.getRecommendedJobs();

    if (mounted) {
      setState(() {
        recommendedJobs = jobs;
        isLoading = false;
      });
    }
  }

  static const bg = Color(0xffF8F8F8);

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: 
         Column(
          children: [
            Headersection(
              candidateData: candidateData,
              recommendedJobs: recommendedJobs,
              onFilterApplied: (List<dynamic> jobs) {
                setState(() {
                  filteredJobs = jobs;
                  isFilterApplied = true;
                });
              },
            ),
             recommendedJobs.isEmpty 

        ? _buildLoadingOrEmptyState()
      :
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const SectionTitle("Quick Access"),
                  const SizedBox(height: 18),
                  QuickAccessRow(
                    jobs: recommendedJobs,
                    onCategoryTap: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  const SizedBox(height: 34),
                  RecommendedHeader(jobs: recommendedJobs),
                  const SizedBox(height: 22),

                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (recommendedJobs.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: recommendedJobs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          return JobCard(job: recommendedJobs[index]);
                        },
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLoadingOrEmptyState() {
  if (isLoading) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.7,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "No Jobs Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pull down or tap refresh to try again",
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: loadRecommendedJobs,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
          ),
        ],
      ),
    ),
  );
}
}

class Headersection extends StatefulWidget {
  final Map<String, dynamic>? candidateData;
  final List<dynamic> recommendedJobs;
  final Function(List<dynamic>) onFilterApplied;

  const Headersection({
    super.key,
    required this.candidateData,
    required this.recommendedJobs,
    required this.onFilterApplied,
  });

  @override
  State<Headersection> createState() => _HeadersectionState();
}

class _HeadersectionState extends State<Headersection> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> searchJobs(String query) async {
    if (query.trim().isEmpty) return;

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/jobs/search"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"searchText": query, "page": 1, "limit": 10}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _searchController.clear();

      // Replace "jobs" with the correct key from your API if needed.
      final List<dynamic> jobs = List<dynamic>.from(
        data["jobs"] ?? data["data"] ?? [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsScreen(searchText: query, jobs: jobs),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 430,
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: HomeScreen.blue,
        image: DecorationImage(
          image: AssetImage("assets/Head.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Zuperr",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage:
                      widget.candidateData?['profilePicture'] != null
                      ? NetworkImage(widget.candidateData!['profilePicture'])
                      : const AssetImage("assets/profile.png") as ImageProvider,
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.candidateData?['firstname'] ?? ''} ${widget.candidateData?['lastname'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${widget.candidateData?['address']?['district'] ?? ''}"
                        "${widget.candidateData?['address']?['state'] != null ? ', ${widget.candidateData!['address']['state']}' : ''}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 34),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(.18),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                const Icon(Icons.search, color: Colors.grey, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: "Jobs, Company, Skill...",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        searchJobs(value);
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FilterDrawer.show(context, widget.recommendedJobs, (
                      List<dynamic> jobs,
                    ) {
                      widget.onFilterApplied(jobs);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 60,
                    decoration: BoxDecoration(
                      color: HomeScreen.blue,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
  
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    );
  }
}

class QuickAccessRow extends StatelessWidget {
  final List<dynamic> jobs;
  final Function(String) onCategoryTap;

  const QuickAccessRow({
    super.key,
    required this.jobs,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, int> categoryCounts = {};

    for (var job in jobs) {
      final category = job['jobCategory']?.toString() ?? 'Other';
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    final categories = categoryCounts.entries.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onCategoryTap(entry.key),
              child: QuickCard(
                entry.key,
                Colors.blue,
                entry.value,
                onTap: () {
                  final categoryJobs = jobs.where((job) {
                    return job['jobCategory'] == entry.key;
                  }).toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryJobsScreen(
                        title: entry.key,
                        jobs: categoryJobs,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class QuickCard extends StatelessWidget {
  final String title;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const QuickCard(
    this.title,
    this.color,
    this.count, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 120,
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border(top: BorderSide(color: color, width: 5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(
              "$count Jobs",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendedHeader extends StatelessWidget {
  final List<dynamic> jobs;

  const RecommendedHeader({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Recommended Jobs",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xffECECEC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("${jobs.length}"),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllJobsScreen(jobs: jobs)),
            );
          },
          child: const Text(
            "See all",
            style: TextStyle(
              color: HomeScreen.blue,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

// Jobbs card

class JobCard extends StatelessWidget {
  final dynamic job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffDCE7FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2563EB).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Blue top accent bar
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xff2563EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),

          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              children: [
                // Logo + Bookmark row
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'a',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                  height: 1.1,
                                ),
                              ),
                              // Amazon smile arrow
                              CustomPaint(
                                size: const Size(42, 8),
                                painter: _SmilePainter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      // Bookmark icon top-right
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: const Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Job title
                Text(
                  job['title'] ?? '',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff0F172A),
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Company & salary
                Text(
                  job['companyName'] ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // Location & experience row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: job['location'] ?? '',
                      iconColor: const Color(0xff2563EB),
                    ),
                    const SizedBox(width: 20),
                    _InfoChip(
                      icon: Icons.work_outline_rounded,
                      label:
                          "${job['minimumExperienceInYears']}-${job['maximumExperienceInYears']} Years",
                      iconColor: const Color(0xff2563EB),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Dashed divider
          _DashedDivider(color: const Color(0xffDCE7FF)),

          // Skills section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children:
                  (job['skillDetails'] != null &&
                      (job['skillDetails'] as List).isNotEmpty)
                  ? (job['skillDetails'] as List)
                        .map<Widget>(
                          (skill) => _SkillChip(
                            label: skill['Name']?.toString() ?? '',
                          ),
                        )
                        .toList()
                  : [const _SkillChip(label: 'No Skills')],
            ),
          ),

          // Dashed divider
          _DashedDivider(color: const Color(0xffDCE7FF)),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailScreen(job: job),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info chip (location / experience) ────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: iconColor),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff475569),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Skill pill chip ───────────────────────────────────────────────────────────
class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xffDCE7FF), width: 1.2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xff475569),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Dashed divider ────────────────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    double x = 0;
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

// ── Amazon smile arrow painter ────────────────────────────────────────────────
class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffFF9900)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(2, 2);
    path.quadraticBezierTo(size.width / 2, size.height + 4, size.width - 2, 2);

    canvas.drawPath(path, paint);

    // Arrow tip
    final arrowPaint = Paint()
      ..color = const Color(0xffFF9900)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width - 2, 2),
      Offset(size.width - 6, 5),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(_SmilePainter old) => false;
}
