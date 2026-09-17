import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/saved_Jobs.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';
import 'package:zuperr/Services/Jobs/UnsaveJobs/UnsaveJobs.dart';
import 'package:zuperr/Services/SaveJobs/saveJobs.dart';

class AllJobsScreen extends StatelessWidget {
  final List<dynamic> jobs;

  const AllJobsScreen({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final styles = [
      {
        "accent": Color(0xff2563EB),
        "gradient": [Color(0xffFFFFFF), Color(0xffEEF4FF)],
      },
      {
        "accent": Color(0xffF59E0B),
        "gradient": [Color(0xffFFFFFF), Color(0xffFFF6E8)],
      },
      {
        "accent": Color(0xff22C55E),
        "gradient": [Color(0xffFFFFFF), Color(0xffECFDF5)],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Column(
        children: [
          // 🔵 HEADER WITH BACKGROUND IMAGE
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage('assets/Head.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
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
                SizedBox(width: 16),
                Text(
                  "All Jobs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 📜 LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final style = styles[index % styles.length];
                final job = jobs[index];

                return JobCard(
                  job: job,
                  accentColor: style["accent"] as Color,
                  gradient: style["gradient"] as List<Color>,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  final dynamic job;
  final List<Color> gradient;
  final Color accentColor;

  const JobCard({
    super.key,
    required this.job,
    required this.gradient,
    required this.accentColor,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _isBookmarkLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              border: Border.all(
                color: widget.accentColor.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _cardContent(context),
            ),
          ),

          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: widget.accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DATE + BOOKMARK
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.job['createdAt'] != null
                  ? widget.job['createdAt'].toString().split('T')[0]
                  : '',
              style: const TextStyle(color: Colors.black54),
            ),
          //   const SizedBox(height: 30),
            SizedBox(
              child: _HeaderSection(
                job: widget.job,
                onSaved: () async {
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
                                          minimumSize: const Size.fromHeight(52),
                                          side: const BorderSide(
                                            color: Color(0xffD1D5DB),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
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
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          minimumSize: const Size.fromHeight(52),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          "Remove",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
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
              
                    final success = await UnsaveJobService.unsaveJob(
                      widget.job["_id"],
                    );
              
                    if (!mounted) return;
              
                    if (success) {
                      setState(() {
                      widget.job["isSaved"] = false;
                      });
              
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Job removed from saved jobs."),
                        ),
                      );
                    }
              
                    return;
                  }
              setState(() => _isBookmarkLoading = true);

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
                      builder: (context) => AlertDialog(
                        title: const Text("Job Saved"),
                        content: const Text(
                          "Job saved successfully.\n\nWould you like to view your saved jobs?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Not Now"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
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
                      if (mounted) {
    setState(() => _isBookmarkLoading = false);
  }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to save job.")),
                    );
                    if (mounted) {
    setState(() => _isBookmarkLoading = false);
  }
                  }
                },
                         
              ),
            ),

          ],
        ),

        const SizedBox(height: 12),

        // LOGO + TITLE
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.android, color: Colors.white),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.job['companyName'] ?? '',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // LOCATION + EXPERIENCE
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: widget.accentColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.job['location'] ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 20),
            Icon(Icons.work_outline, size: 18, color: widget.accentColor),
            const SizedBox(width: 4),
            Text(
              '${widget.job['minimumExperienceInYears']}-${widget.job['maximumExperienceInYears']} Years',
            ),
          ],
        ),

        const SizedBox(height: 12),

        // SKILLS
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (widget.job['skills'] as List?)?.isNotEmpty == true
              ? (widget.job['skills'] as List)
                    .take(4)
                    .map((skill) => _SkillChip(label: skill["Name"] ?? ''))
                    .toList()
              : [const _SkillChip(label: 'No Skills')],
        ),

        const Divider(height: 24),

        // SALARY + APPLY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.job['maximumSalaryLPA'] != null && widget.job['maximumSalaryLPA'] > 0
                  ? '₹ ${widget.job['minimumSalaryLPA']} - ${widget.job['maximumSalaryLPA']} LPA'
                  : 'Salary Not Disclosed',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JobDetailScreen(job: widget.job)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Apply', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}

// SKILL CHIP
class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xffDCE7FF)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final dynamic job;
  final VoidCallback onSaved;

  const _HeaderSection({
    required this.job,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: _BookmarkButton(
        saved: job["isSaved"] == true,
        onTap: onSaved,
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool saved;
  final VoidCallback onTap;

  const _BookmarkButton({required this.saved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          saved ? Icons.bookmark : Icons.bookmark_border,
          size: 28,
          color: const Color(0xff374151),
        ),
      ),
    );
  }}