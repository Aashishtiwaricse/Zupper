import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs/AppliedJobs/appliedJobs.dart';
import 'package:zuperr/Screens/ProfileScreen/JobApplicationDetailScreen.dart';



class AppliedJobCard extends StatelessWidget {
  final AppliedJob job;

  const AppliedJobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobApplicationDetailScreen(
              job: {
                "_id": job.id,
                "title": job.title,
                "companyName": job.companyName,
                "companyLogo": job.companyLogo,
                "location": job.location,
                "minimumExperienceInYears":
                    job.minExp,
                "maximumExperienceInYears":
                    job..maxExp,
                "minimumSalaryLPA":
                    job.minSalary,
                "maximumSalaryLPA":
                    job.maxSalary,
                "skills": job.skills,
                "applicantInfo": {
                  "status": job.status,
                  "appliedDate":
                      job.appliedDate,
                }
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                _companyLogo(),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        job.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        job.companyName,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [

                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              job.location,
                              style: TextStyle(
                                color:
                                    Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                _statusChip(),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _infoBox(
                    Icons.work_outline,
                    "${job.minExp}-${job.maxExp} Years",
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _infoBox(
                    Icons.currency_rupee,
                    "${job.minExp}-${job.maxSalary} LPA",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.skills
                  .take(5)
                  .map(
                    (skill) => Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xffEEF5FF),
                        borderRadius:
                            BorderRadius.circular(
                                18),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color:
                              Color(0xff1E6BE3),
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Icon(
                  Icons.access_time,
                  size: 18,
                  color: Colors.grey[600],
                ),

                const SizedBox(width: 6),

                Text(
                  "Applied ${timeAgo(job.appliedDate)}",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff1E6BE3),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            JobApplicationDetailScreen(
                          job: {
                            "_id": job.id,
                            "title": job.title,
                            "companyName":
                                job.companyName,
                            "companyLogo":
                                job.companyLogo,
                            "location":
                                job.location,
                            "minimumExperienceInYears":
                                job.minExp,
                            "maximumExperienceInYears":
                                job.maxExp,
                            "minimumSalaryLPA":
                                job.minSalary,
                            "maximumSalaryLPA":
                                job.maxSalary,
                            "skills": job.skills,
                            "applicantInfo": {
                              "status": job
                                  .status
                                  ,
                              "appliedDate": job
                                  
                                  .appliedDate,
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyLogo() {
    if (job.companyLogo != null &&
        job.companyLogo!.isNotEmpty) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(14),
        child: Image.network(
          job.companyLogo!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _avatar(),
        ),
      );
    }

    return _avatar();
  }

  Widget _avatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff1E6BE3),
        borderRadius:
            BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        job.companyName[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statusChip() {
    Color bg = Colors.blue.shade50;
    Color fg = Colors.blue;

    switch (job.status) {
      case "Applied":
        bg = Colors.orange.shade50;
        fg = Colors.orange;
        break;

      case "Under Review":
        bg = Colors.blue.shade50;
        fg = Colors.blue;
        break;

      case "Rejected":
        bg = Colors.red.shade50;
        fg = Colors.red;
        break;

      case "Selected":
        bg = Colors.green.shade50;
        fg = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        job.status,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _infoBox(
      IconData icon,
      String value,
      ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xff1E6BE3),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow:
                  TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

 String timeAgo(DateTime appliedDate) {
  final diff = DateTime.now().difference(appliedDate);

  if (diff.inDays > 0) {
    return "${diff.inDays} days ago";
  }

  if (diff.inHours > 0) {
    return "${diff.inHours} hours ago";
  }

  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} mins ago";
  }

  return "Just now";
}
}