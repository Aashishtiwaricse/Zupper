import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/saved_Jobs.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';
import 'package:zuperr/Services/Jobs/UnsaveJobs/UnsaveJobs.dart';
import 'package:zuperr/Services/SaveJobs/saveJobs.dart';

class JobCard extends StatefulWidget {
  final dynamic job;

  const JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final cardWidth = screenWidth > 600 ? 390.0 : screenWidth - 32;

    return Center(
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffDCE7FF)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(.05),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top blue line
            Container(
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xff2563EB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),

            //   const SizedBox(height: 30),
            _HeaderSection(
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
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to save job.")),
                  );
                }
              },
            ),

            const SizedBox(height: 22),

            const TicketDivider(),

            GestureDetector(
              onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(job: widget.job),
      ),
    );
  },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: _SkillSection(skills: widget.job['skills'] ?? []),
              ),
            ),

            const TicketDivider(),

            Padding(
              padding: const EdgeInsets.all(22),
              child: _ApplyButton(
                isApplied: widget.job["isApplied"] == true,
                onPressed: () {
                  if (widget.job["isApplied"] == true) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailScreen(job: widget.job),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Header Section

class _HeaderSection extends StatelessWidget {
  final dynamic job;
  final VoidCallback onSaved;

  const _HeaderSection({required this.job, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Stack(
              children: [
                const Align(alignment: Alignment.center, child: _CompanyLogo()),

                Positioned(
                  right: 0,
                  top: 6,
                  child: _BookmarkButton(
                    saved: job["isSaved"] == true,
                    onTap: onSaved,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          GestureDetector(
            onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(job: job),
      ),
    );
  },
            child: _JobTitle(title: job["title"] ?? "")),

          const SizedBox(height: 14),

          GestureDetector(
            onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(job: job),
      ),
    );
  },
            child: _CompanySalary(
              company: job["companyName"] ?? "",
              salary: job["salary"] ?? "",
            ),
          ),

          const SizedBox(height: 24),

          GestureDetector(
            onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(job: job),
      ),
    );
  },
            child: _InfoRow(job: job)),
        ],
      ),
    );
  }
}

//job title widget
class _JobTitle extends StatelessWidget {
  final String title;

  const _JobTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -.4,
        color: Color(0xff111827),
      ),
    );
  }
}

class _CompanySalary extends StatelessWidget {
  final String company;
  final String salary;

  const _CompanySalary({required this.company, required this.salary});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: company),
          const TextSpan(text: " • "),
          TextSpan(text: salary),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
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
  }
}

class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "a",
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            CustomPaint(size: const Size(40, 10), painter: SmilePainter()),
          ],
        ),
      ),
    );
  }
}

class SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffF59E0B)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(4, 3);

    path.quadraticBezierTo(size.width / 2, size.height + 4, size.width - 6, 2);

    canvas.drawPath(path, paint);

    final arrow = Path();

    arrow.moveTo(size.width - 6, 2);
    arrow.lineTo(size.width - 10, 0);
    arrow.moveTo(size.width - 6, 2);
    arrow.lineTo(size.width - 9, 5);

    canvas.drawPath(arrow, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _InfoRow extends StatelessWidget {
  final dynamic job;

  const _InfoRow({required this.job});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 26,
      runSpacing: 12,
      children: [
        _InfoItem(
          icon: Icons.location_on_outlined,
          text: job["location"] ?? "Location",
        ),
        _InfoItem(
          icon: Icons.work_outline,
          text:
              "${job["minimumExperienceInYears"] ?? 0}-${job["maximumExperienceInYears"] ?? 0} Years",
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xff2563EB), size: 18),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xff475569),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillSection extends StatelessWidget {
  final List skills;

  const _SkillSection({required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const Center(child: _SkillChip(text: "No Skills"));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 7,
      runSpacing: 7,
      children: skills.take(5).map((skill) {
        return _SkillChip(text: skill["Name"] ?? "");
      }).toList(),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String text;

  const _SkillChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffD1D5DB)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xff111827),
        ),
      ),
    );
  }
}

class TicketDivider extends StatelessWidget {
  const TicketDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xffF8FAFC),
              borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ),

          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: DashedLinePainter(),
            ),
          ),

          Container(
            width: 12,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xffF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final paint = Paint()
      ..color = const Color(0xffD6E4FF)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ApplyButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isApplied;

  const _ApplyButton({required this.onPressed, required this.isApplied});

  @override
  State<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<_ApplyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isApplied
          ? null
          : (_) {
              setState(() => _pressed = true);
            },

      onTapCancel: widget.isApplied
          ? null
          : () {
              setState(() => _pressed = false);
            },

      onTapUp: widget.isApplied
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed();
            },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: 58,
        width: double.infinity,
        transform: Matrix4.identity()..scale(_pressed ? .98 : 1.0),
        decoration: BoxDecoration(
          color: widget.isApplied
              ? Colors.grey.shade400
              : const Color(0xff2563EB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: widget.isApplied
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xff2563EB).withOpacity(.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.isApplied ? "Applied" : "Apply",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}
