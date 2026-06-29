import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/SummarieswithAi.dart';
import 'package:zuperr/Screens/HomeScreen/similarJobs.dart';
import 'package:zuperr/Services/ApplyForJobs/applyForJobs.dart';
import 'package:zuperr/Services/SaveJobs/saveJobs.dart';

class JobDetailScreen extends StatefulWidget {
  final dynamic job;

  const JobDetailScreen({super.key, required this.job});
  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool isExpanded = false;
  bool _isApplying = false;
  void openSummary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SummarizeWithAi(),
    );
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
                    children: [
                      _jobInfo(),
                      _description(),
                      if (isExpanded) _tabsSection(),
                                SimilarJobs(jobId: widget.job["_id"].toString()),

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
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print(widget.job);
                      print("Job ID: ${widget.job['_id']}");

                      final success = await SaveJobService.saveJob(
                        widget.job["_id"].toString(),
                      );

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
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.bookmark_border, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.share, color: Colors.white),
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
            spacing: 15,
            runSpacing: 15,
            children: (widget.job['skills'] as List?)?.isNotEmpty == true
                ? (widget.job['skills'] as List)
                      .map((skill) => SkillChip(label: skill.toString()))
                      .toList()
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
              color: Colors.white.withOpacity(0.2), // 👈 MUST be > 0
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.7),
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
              children: [
                _requiredSkills(),
                _requiredSkills(),
                _requiredSkills(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _requiredSkills() {
    final skills = widget.job['skills'] as List? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (skills.isNotEmpty)
            ...skills.map(
              (skill) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "• $skill",
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
    );
  }

  Widget _portfolio() {
    return const Center(
      child: Text(
        "Portfolio content here",
        style: TextStyle(color: Colors.black54),
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
            height: 56,
            child: OutlinedButton(
              onPressed: () => openSummary(context),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F8FF),
                side: const BorderSide(color: Color(0xFF2F6FE4), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, color: Color(0xFF2F6FE4), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Summarize with AI",
                    style: TextStyle(
                      color: Color(0xFF2F6FE4),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
                      setState(() {
                        _isApplying = true;
                      });

                      final success = await ApplyJobService.applyForJob(
                        widget.job["_id"].toString(),
                      );

                      if (!mounted) return;

                      setState(() {
                        _isApplying = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? "Job applied successfully"
                                : "Failed to apply for job",
                          ),
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

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        // color: const Color(0xFFF3F4F6), // soft gray background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black12, // subtle border
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black, // medium-dark gray
          fontWeight: FontWeight.w400,
        ),
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
