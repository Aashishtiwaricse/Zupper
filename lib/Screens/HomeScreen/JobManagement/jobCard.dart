import 'package:flutter/material.dart';
import 'package:zuperr/Models/Jobs/savedJobs.dart';
import 'package:zuperr/Services/ApplyForJobs/applyForJobs.dart';

class JobCard extends StatefulWidget {
  final SavedJob job;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onBookmark;
  final VoidCallback? onApply;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onDelete,
    this.onBookmark,
    this.onApply,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyLogo(),
      
                  const SizedBox(width: 14),
      
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
      
                        const SizedBox(height: 6),
      
                        Text(
                          widget.job.companyName,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
      
                        const SizedBox(height: 10),
      
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
      
                            const SizedBox(width: 4),
      
                            Expanded(
                              child: Text(
                                widget.job.location,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      
                  Column(
                    children: [
                      IconButton(
                        splashRadius: 22,
                        icon: const Icon(
                          Icons.bookmark,
                          color: Color(0xff1E6BE3),
                        ),
                        onPressed: widget.onBookmark,
                      ),
      
                      Material(
                        child: IconButton(
                          splashRadius: 22,
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            print("Delete icon clicked");
                              
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Remove Saved Job"),
                                content: const Text(
                                  "Are you sure you want to remove this job from your saved jobs?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      print("Cancel pressed");
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                              
                                  TextButton(
                                    onPressed: () {
                                      print("Delete pressed");
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                              
                            print("Dialog result: $confirm");
                              
                            if (confirm == true) {
                              print("Deleting job id: ${widget.job.id}");
                              widget.onDelete?.call();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      
              const SizedBox(height: 18),
      
              Row(
                children: [
                  Expanded(
                    child: _infoChip(
                      Icons.work_outline,
                      "${widget.job.minimumExperienceInYears}-${widget.job.maximumExperienceInYears} Years",
                    ),
                  ),
      
                  const SizedBox(width: 12),
      
                  Expanded(
                    child: _infoChip(
                      Icons.currency_rupee,
                      "${widget.job.minimumSalaryLPA}-${widget.job.maximumSalaryLPA} LPA",
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 18),
      
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.job.skills
                    .take(5)
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffEEF5FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: Color(0xff1E6BE3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      
              const SizedBox(height: 18),
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
                              behavior: SnackBarBehavior.floating,
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
        ),
      ),
    );
  }

  Widget _buildCompanyLogo() {
    if (widget.job.companyLogo != null && widget.job.companyLogo!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          widget.job.companyLogo!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildAvatar(),
        ),
      );
    }

    return _buildAvatar();
  }

  Widget _buildAvatar() {
    final letter = widget.job.companyName.isNotEmpty
        ? widget.job.companyName[0].toUpperCase()
        : "C";

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff1E6BE3),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xff1E6BE3)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
