import 'package:flutter/material.dart';
import 'package:zuperr/Models/_job_response.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/saved_Jobs.dart';
import 'package:zuperr/Services/ApplyForJobs/applyForJobs.dart';
import 'package:zuperr/Services/Jobs/UnsaveJobs/UnsaveJobs.dart';
import 'package:zuperr/Services/SaveJobs/saveJobs.dart';

class CompanyJobCard extends StatefulWidget {
  final CompanyJob job;
  final VoidCallback? onApply;
  final VoidCallback? onTap;

  const CompanyJobCard({
    super.key,
    required this.job,
    this.onApply,
    this.onTap,
  });

  @override
  State<CompanyJobCard> createState() => _CompanyJobCardState();
}

class _CompanyJobCardState extends State<CompanyJobCard> {

  static const blue = Color(0xff1E6BE3);
    bool _isApplying = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 335,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xffDCE7FF),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              decoration: const BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(14),
                          color: Colors.grey.shade100,
                        ),
                        child: const Icon(
                          Icons.business,
                          color: blue,
                          size: 34,
                        ),
                      ),

                      const Spacer(),

                          _HeaderSection(
              job: widget.job,
              onSaved: () async {
                if (widget.job == true) {
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
                    widget.job.id,
                  );

                  if (!mounted) return;

                  if (success) {
                    setState(() {
                  //    widget.job["isSaved"] = false;
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
                  widget.job.id,
                );

                if (!mounted) return;

                if (success) {
                  setState(() {
                 //   widget.job.isSaved = true;
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
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.job.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${widget.job.createdBy.companyName} • ₹${widget.job.minimumSalaryLpa.toInt()}-${widget.job.maximumSalaryLpa.toInt()} LPA",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.job.distance.toInt()} KM",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Icon(
                        Icons.work_outline,
                        size: 18,
                        color: blue,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${widget.job.minimumExperienceInYears}-${widget.job.maximumExperienceInYears} Years",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.apartment,
                        color: blue,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.job.workMode,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.job.skills.take(5).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20),
                          color:
                              const Color(0xffF5F7FA),
                        ),
                        child: Text(
                          skill.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
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

                      if (result["success"]) {
                        final openAppliedJobs = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 10),
Text(
  "Application Submitted",
  style: TextStyle(
    fontSize: 16,
  ),
)                              ],
                            ),
                            content: const Text(
                              "Your job application has been submitted successfully.\n\nWould you like to view your applied jobs?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Not Now"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("View Applied Jobs"),
                              ),
                            ],
                          ),
                        );

                        if (openAppliedJobs == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SavedJobsScreen(),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result["message"]),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Apply Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _HeaderSection extends StatelessWidget {
  final CompanyJob job;
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
            child: Positioned(
              right: 0,
              top: 6,
              child: _BookmarkButton(
                saved: job.jobType == true,
                onTap: onSaved,
              ),
            ),
          ),

        

        ],
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
  }
}
