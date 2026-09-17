import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zuperr/Models/_job_response.dart' show CompanyJob;
import 'package:zuperr/Screens/Companies/widgets/InfoBox.dart';
import 'package:zuperr/Screens/Companies/widgets/SkillChip.dart';
import 'package:zuperr/Screens/HomeScreen/similarJobs.dart';
import 'package:zuperr/Services/AnalyzieCandidate/analyziecandidate.dart';
import 'package:zuperr/Services/ApplyForJobs/applyForJobs.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/SaveJobs/saveJobs.dart';

import 'package:zuperr/Utils/AppConstants.dart';

class CompanyJobDetailScreen extends StatefulWidget {
  final CompanyJob job;

  const CompanyJobDetailScreen({super.key, required this.job});

  @override
  State<CompanyJobDetailScreen> createState() => _CompanyJobDetailScreenState();
}

class _CompanyJobDetailScreenState extends State<CompanyJobDetailScreen> {
  bool isExpanded = false;
  bool isSaved = false;
  bool _isApplying = false;

  Map<String, dynamic>? candidateData;
  bool _loadingCandidate = true;

  Widget _blurSeeMore() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 110,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2)),
          child: Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0),
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
                    border: Border.all(color: const Color(0xFFBFD4FF)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "See more",
                        style: TextStyle(
                          color: Color(0xFF1E6BE3),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_double_arrow_down_rounded,
                        color: Color(0xFF1E6BE3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadCandidate();
  }

  Future<void> loadCandidate() async {
    final data = await CandidateService.getCandidateData();

    if (!mounted) return;

    setState(() {
      candidateData = data;
      _loadingCandidate = false;
    });
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
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _jobInfo(),

                      _description(),

                      if (isExpanded) ...[
                        _tabsSection(),

                        //    const SizedBox(height: 24),

                        // Similar Jobs comes later
                      ],
                    ],
                  ),
                ),

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

  //==========================================================
  // HEADER
  //==========================================================

  Widget _header() {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(20),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),

              child: _headerButton(Icons.arrow_back_ios_new),
            ),

            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final success = await SaveJobService.saveJob(widget.job.id);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Job saved successfully"
                              : "Failed to save job",
                        ),
                      ),
                    );
                  },

                  child: _headerButton(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                  ),
                ),

                const SizedBox(width: 14),

                GestureDetector(
                  onTap: () {
                    final link =
                        "${ApiConstants.baseUrl}/jobs?jobId=${widget.job.id}";

                    SharePlus.instance.share(
                      ShareParams(
                        subject: widget.job.title,
                        text:
                            """

🚀 ${widget.job.title}

Company:
${widget.job.title}

Apply now:

$link

Shared via Zuperr

""",
                      ),
                    );
                  },

                  child: _headerButton(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerButton(IconData icon) {
    return Container(
      height: 40,
      width: 40,

      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  //==========================================================
  // JOB INFO
  //==========================================================

  Widget _jobInfo() {
    final skills = widget.job.skills;

    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              companyLogo(),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      widget.job.title,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2B2F38),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${widget.job.title} • ${widget.job.location}",

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: skills.isEmpty
                ? const [SkillChip(label: "No Skills")]
                : skills.map((e) => SkillChip(label: e.name)).toList(),
          ),

          const SizedBox(height: 22),
          Row(
            children: [
              InfoBox(icon: Icons.access_time, text: widget.job.jobType),
              InfoBox(
                icon: Icons.work_outline,
                text:
                    "${widget.job.minimumExperienceInYears}-${widget.job.maximumExperienceInYears} Years",
              ),
              InfoBox(
                icon: Icons.currency_rupee,
                text: widget.job.maximumSalaryLpa > 0
                    ? "${widget.job.minimumSalaryLpa}-${widget.job.maximumSalaryLpa} LPA"
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
          const SizedBox(height: 12),

          const Text(
            "Job Description",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff1A202C),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            widget.job.jobDescription.isNotEmpty
                ? widget.job.jobDescription
                : "No description available.",
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Color(0xff4A5568),
            ),
          ),

          const SizedBox(height: 32),


          if (isExpanded) ...[
            SimilarJobs(jobId: widget.job.id),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _tabsSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          const TabBar(
            labelColor: Color(0xff1E6BE3),
            unselectedLabelColor: Color(0xff6B7280),
            indicatorColor: Color(0xff1E6BE3),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            tabs: [
              Tab(text: "Required Skills"),
              Tab(text: "Portfolio"),
              Tab(text: "Qualifications"),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 340,
            child: TabBarView(
              children: [_requiredSkills(), _portfolio(), _qualification()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _requiredSkills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.job.skills.isEmpty)
              const Text(
                "No skills available",
                style: TextStyle(color: Color(0xff6B7280), fontSize: 15),
              ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.job.skills
                  .take(8)
                  .map((skill) => SkillChip(label: skill.name))
                  .toList(),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget companyLogo() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5EAF3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          widget.job.education,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return const Icon(
              Icons.business,
              size: 34,
              color: Color(0xff1E6BE3),
            );
          },
        ),
      ),
    );
  }

  Widget _portfolio() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _infoTile(
              Icons.category_outlined,
              "Job Category",
              widget.job.jobCategory,
            ),

            _infoTile(
              Icons.business_center_outlined,
              "Industry",
              widget.job.industry.join(", "),
            ),

            _infoTile(
              Icons.home_work_outlined,
              "Work Mode",
              widget.job.workMode,
            ),

            _infoTile(
              Icons.workspace_premium_outlined,
              "Experience Level",
              widget.job.experienceLevel,
            ),

            _infoTile(
              Icons.location_on_outlined,
              "Location",
              widget.job.location,
            ),

            _infoTile(Icons.badge_outlined, "Job Type", widget.job.jobType),
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
          children: [
            _infoTile(Icons.school_outlined, "Education", widget.job.education),

            _infoTile(Icons.menu_book_outlined, "Degree", widget.job.degree),

            _infoTile(
              Icons.work_outline,
              "Experience",
              "${widget.job.minimumExperienceInYears} - ${widget.job.maximumExperienceInYears} Years",
            ),

            //     _infoTile(Icons.person_outline, "Gender", widget.job.),
            _infoTile(
              Icons.attach_money,
              "Salary",
              "${widget.job.maximumSalaryLpa} - ${widget.job.maximumSalaryLpa} LPA",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5EAF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffEEF4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xff1E6BE3), size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff8B95A7),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value.isEmpty ? "Not Available" : value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1A202C),
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
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// AI SUMMARY BUTTON
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

          /// APPLY BUTTON
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _isApplying
                  ? null
                  : () async {
                      setState(() {
                        _isApplying = true;
                      });

                      final result = await ApplyJobService.applyForJob(
                        widget.job.id,
                      );

                      if (!mounted) return;

                      setState(() {
                        _isApplying = false;
                      });

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result["message"]),
                          backgroundColor: result["success"]
                              ? Colors.green
                              : Colors.red,
                        ),
                      );
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
                    colors: [Color(0xff2F6FE4), Color(0xff2A6AD9)],
                  ),
                ),
                child: Center(
                  child: _isApplying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
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
