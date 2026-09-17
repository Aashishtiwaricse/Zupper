import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/saved_Jobs.dart';
import 'package:zuperr/Screens/HomeScreen/SummarieswithAi.dart';
import 'package:zuperr/Screens/HomeScreen/similarJobs.dart';
import 'package:zuperr/Services/AnalyzieCandidate/analyziecandidate.dart';
import 'package:zuperr/Services/ApplyForJobs/applyForJobs.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/Jobs/UnsaveJobs/UnsaveJobs.dart';
import 'package:zuperr/Services/SaveJobs/saveJobs.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class JobDetailScreen extends StatefulWidget {
  final dynamic job;

  const JobDetailScreen({super.key, required this.job});
  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool isExpanded = false;
  bool _isApplying = false;
  bool _isBookmarkLoading = false;
  void openSummary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SummarizeWithAi(),
    );
  }

  Map<String, dynamic>? candidateData;
  bool _loadingCandidate = true;
  bool _isUserLoggedIn = false;
bool _checkingLogin = true;

  @override
void initState() {
  super.initState();
  loadCandidate();
  _checkLoginStatus();
}

Future<void> _checkLoginStatus() async {
  final loggedIn = await _isLoggedIn();

  if (!mounted) return;

  setState(() {
    _isUserLoggedIn = loggedIn;
    _checkingLogin = false;
  });
}

  Future<void> loadCandidate() async {
    final data = await CandidateService.getCandidateData();

    if (!mounted) return;

    setState(() {
      candidateData = data;
      _loadingCandidate = false;
    });
  }

Future<bool> _isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("auth_token");

  return token != null && token.isNotEmpty;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Stack(
              children: [
                // 👇 SCROLL CONTENT
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _jobInfo(),
                      _description(),

                      if (isExpanded) ...[
                        _tabsSection(),
                        const SizedBox(height: 20),
                        SimilarJobs(jobId: widget.job["_id"].toString()),
                      ],
                    ],
                  ),
                ),

                // 👇 BLUR OVERLAY (NOW IT WORKS)
                if (!isExpanded)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _blurSeeMore(),
                  ),
              ],
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xff1E6BE3),
        image: DecorationImage(
          image: AssetImage('assets/Head.png'),
          fit: BoxFit.cover, // adjust as needed
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

                  if (_isUserLoggedIn)

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
//      const SizedBox(width: 38),
          if (_isUserLoggedIn)

              Row(
                children: [
                  GestureDetector(
                    onTap: _isBookmarkLoading
                        ? null
                        : () async {
                          
                            // Already saved
                            if (widget.job["isSaved"] == true) {
                              final remove = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 72,
                                            height: 72,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.bookmark_remove_rounded,
                                              color: Colors.red,
                                              size: 38,
                                            ),
                                          ),

                                          const SizedBox(height: 22),

                                          const Text(
                                            "Remove Saved Job?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff111827),
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          const Text(
                                            "This job will be removed from your saved jobs list. You can always save it again later.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.5,
                                              color: Color(0xff6B7280),
                                            ),
                                          ),

                                          const SizedBox(height: 28),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                          52,
                                                        ),
                                                    side: const BorderSide(
                                                      color: Color(0xffD1D5DB),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff374151),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 14),

                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                          52,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text(
                                                    "Remove",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (remove != true) return;

                              setState(() => _isBookmarkLoading = true);

                              try {
                                final success =
                                    await UnsaveJobService.unsaveJob(
                                      widget.job["_id"],
                                    );

                                if (!mounted) return;

                                if (success) {
                                  setState(() {
                                    widget.job["isSaved"] = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Job removed from saved jobs.",
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isBookmarkLoading = false);
                                }
                              }

                              return;
                            }

                            // Save job
                            setState(() => _isBookmarkLoading = true);

                            try {
                              final success = await SaveJobService.saveJob(
                                widget.job["_id"].toString(),
                              );

                              if (!mounted) return;

                              if (success) {
                                setState(() {
                                  widget.job["isSaved"] = true;
                                });

                                final openSavedJobs = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Job Saved"),
                                    content: const Text(
                                      "Job saved successfully.\n\nWould you like to view your saved jobs?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Not Now"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text("View Saved Jobs"),
                                      ),
                                    ],
                                  ),
                                );

                                if (openSavedJobs == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SavedJobsScreen(),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to save job."),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _isBookmarkLoading = false);
                              }
                            }
                          },
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _isBookmarkLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Icon(
                                widget.job["isSaved"] == true
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      final jobId = widget.job["_id"].toString();

                      final jobTitle =
                          widget.job["jobTitle"] ?? "Job Opportunity";

                      final company = widget.job["companyName"] ?? "";
final link =
    "${ApiConstants.baseUrl}/api/public/jobs/$jobId";
                      print("from  job share");
                      print(link);

                      SharePlus.instance.share(
                        ShareParams(
                          subject: jobTitle,
                          text:
                              '''
🚀 $jobTitle

${company.isNotEmpty ? "Company: $company\n" : ""}

Apply now:
$link

Shared via Zuperr
''',
                        ),
                      );
                    },
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.share, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobInfo() {
    final List skills = widget.job['skills'] ?? [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
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
                      CustomPaint(
                        size: const Size(42, 8),
                        painter: _SmilePainter(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job['title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B2F38),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${widget.job['companyName'] ?? ''} • ${widget.job['location'] ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 19),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.isNotEmpty
                ? skills.map<Widget>((skill) {
                    return SkillChip(label: skill["Name"] ?? "");
                  }).toList()
                : [const SkillChip(label: "No Skills")],
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoBox(
                icon: Icons.access_time,
                text: widget.job['jobType'] ?? '',
              ),
              InfoBox(
                icon: Icons.work_outline,
                text:
                    "${widget.job['minimumExperienceInYears']}-${widget.job['maximumExperienceInYears']} Years",
              ),
              InfoBox(
                icon: Icons.credit_card_outlined,
                text:
                    widget.job['maximumSalaryLPA'] != null &&
                        widget.job['maximumSalaryLPA'] > 0
                    ? "${widget.job['minimumSalaryLPA']}-${widget.job['maximumSalaryLPA']} LPA"
                    : "Not Disclosed",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Job description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.job['jobDescription'] ?? 'No description available',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 80), // 👈 space for overlay
        ],
      ),
    );
  }

  Widget _blurSeeMore() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2), // 👈 MUST be > 0
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.7),
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFBFD4FF),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "See more",
                          style: TextStyle(
                            color: Color(0xFF1E6BE3),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.keyboard_double_arrow_down_rounded,
                          color: Color(0xFF1E6BE3),
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabsSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // 🔵 TAB BAR
          const TabBar(
            labelColor: Color(0xFF1E6BE3),
            unselectedLabelColor: Color(0xFF2B2F38),
            indicatorColor: Color(0xFF1E6BE3),
            indicatorWeight: 2.5,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: "Required Skills"),
              Tab(text: "Portfolio"),
              Tab(text: "Qualifications"),
            ],
          ),

          const SizedBox(height: 16),

          // 📄 TAB CONTENT
          SizedBox(
            height: 250, // 👈 important for layout
            child: TabBarView(
              children: [_requiredSkills(), _portfolio(), _qualification()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _requiredSkills() {
    final List skills = widget.job['skills'] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (skills.isNotEmpty)
              ...skills.map(
                (skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "• ${skill['Name']}",

                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

            if (skills.isEmpty)
              const Text(
                "No skills available",
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _portfolio() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile(
              Icons.category_outlined,
              "Job Category",
              widget.job["jobCategory"] ?? "Not Available",
            ),

            _infoTile(
              Icons.business_center_outlined,
              "Industry",
              widget.job["industry"] is List
                  ? (widget.job["industry"] as List).join(", ")
                  : "Not Available",
            ),

            _infoTile(
              Icons.work_outline,
              "Work Mode",
              widget.job["workMode"] ?? "Not Available",
            ),

            _infoTile(
              Icons.star_outline,
              "Experience Level",
              widget.job["experienceLevel"] ?? "Not Available",
            ),
          ],
        ),
      ),
    );
  }

  Widget _qualification() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile(
              Icons.school_outlined,
              "Education",
              widget.job["education"] ?? "Not Available",
            ),

            _infoTile(
              Icons.menu_book_outlined,
              "Degree",
              widget.job["degree"] ?? "Not Available",
            ),

            _infoTile(
              Icons.work_history_outlined,
              "Experience",
              "${widget.job["minimumExperienceInYears"]}-${widget.job["maximumExperienceInYears"]} Years",
            ),

            _infoTile(
              Icons.person_outline,
              "Gender",
              widget.job["gender"] ?? "Any",
            ),

            _infoTile(
              Icons.cake_outlined,
              "Age",
              "${widget.job["fromAge"]}-${widget.job["toAge"]} Years",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xff1E6BE3)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✨ Summarize Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.auto_awesome, color: Color(0xff1E6BE3)),
              label: const Text(
                "Summarize with AI",
                style: TextStyle(
                  color: Color(0xff1E6BE3),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xff1E6BE3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                if (candidateData == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Candidate not loaded")),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final summary = await AnalyzeCandidateService.analyzeCandidate(
                  candidateProfile: candidateData!,
                  jobDescription: {
                    "_id": widget.job.id,

                    "title": widget.job.title,

                    "jobDescription": widget.job.jobDescription,

                    "skills": widget.job.skills
                        .map((e) => {"Name": e.name})
                        .toList(),

                    "education": widget.job.education,

                    "degree": widget.job.degree,

                    "industry": widget.job.industry,

                    "jobCategory": widget.job.jobCategory,

                    "experienceLevel": widget.job.experienceLevel,

                    "workMode": widget.job.workMode,
                  },
                );

                Navigator.pop(context);

                if (summary == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Unable to generate AI summary"),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("AI Summary"),
                    content: SingleChildScrollView(child: Text(summary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // 🔵 Apply Button
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _isApplying
                  ? null
                  : () async {
                    // 🔐 Check authentication first
        final loggedIn = await _isLoggedIn();
                print("Share Button");

        print(loggedIn);

        if (!loggedIn) {
          Get.snackbar(
            "Login Required",
            "Please login to apply for this job.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
            icon: const Icon(
              Icons.lock_outline,
              color: Colors.white,
            ),
          );

          // Save this job as pending
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString(
            "pending_job_id",
            widget.job["_id"].toString(),
          );

          // Go to login
          Navigator.pushNamed(
            context,
            '/login',
          );

          return;
        }
                      setState(() {
                        _isApplying = true;
                      });

                      final result = await ApplyJobService.applyForJob(
                        widget.job["_id"].toString(),
                      );

                      if (!mounted) return;

                      setState(() {
                        _isApplying = false;
                      });

                      // Hide any existing snackbar
                      Get.closeAllSnackbars();

                      if (result["success"] == true) {
                        Get.snackbar(
                          "Success",
                          result["message"] ?? "Job applied successfully!",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          duration: const Duration(seconds: 3),
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          result["message"] ?? "Failed to apply for this job.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          duration: const Duration(seconds: 3),
                          icon: const Icon(Icons.error, color: Colors.white),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF2F6FE4), Color(0xFF2A6AD9)],
                  ),
                ),
                child: Center(
                  child: _isApplying
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 70,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FBFE), // very light bluish white
            Color(0xFFF1F5FB), // subtle cool gray-blue
          ],
        ),
        border: Border.all(color: const Color(0xffD9E7FF), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: const Color(0xff123D7A)),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xff123D7A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;

  const SkillChip({super.key, required this.label, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      deleteIcon: onDelete != null ? const Icon(Icons.close, size: 18) : null,
      onDeleted: onDelete,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
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
