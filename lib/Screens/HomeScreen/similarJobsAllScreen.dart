
import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs.dart';
import 'package:zuperr/Screens/HomeScreen/SimilarJobsCard/similarJobsCard.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';

class SimilarJobsAllScreen extends StatelessWidget {
  final List<SimilarJobModel> jobs;

  const SimilarJobsAllScreen({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Column(
        children: [
          // =========================================================
          // HEADER
          // =========================================================
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

                const SizedBox(width: 16),

                const Text(
                  "Similar Jobs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // =========================================================
          // JOB LIST
          // =========================================================
          Expanded(
            child: jobs.isEmpty
                ? const Center(
                    child: Text(
                      "No similar jobs found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];

                      return SimilarJobCard(
                        job: job,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}





class SimilarJobCard extends StatelessWidget {
  final SimilarJobModel job;

  const SimilarJobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xffDCE7FF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // TOP ROW
            // =====================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // COMPANY LOGO
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF4FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.business_rounded,
                      color: Color(0xff2563EB),
                      size: 30,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // TITLE + COMPANY
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff111827),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        job.companyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // BOOKMARK
                // Container(
                //   height: 38,
                //   width: 38,
                //   decoration: BoxDecoration(
                //     color: const Color(0xffF5F7FB),
                //     borderRadius: BorderRadius.circular(11),
                //   ),
                //   child: const Icon(
                //     Icons.bookmark_border_rounded,
                //     color: Color(0xff374151),
                //     size: 21,
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 18),

            // =====================================================
            // LOCATION
            // =====================================================
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 19,
                  color: Color(0xff2563EB),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    job.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // =====================================================
            // EXPERIENCE + WORK MODE
            // =====================================================
            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    icon: Icons.work_outline_rounded,
                    text:
                        "${job.minimumExperienceInYears}-${job.maximumExperienceInYears} Years",
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _infoItem(
                    icon: Icons.home_work_outlined,
                    text: job.workMode.isEmpty
                        ? "Not specified"
                        : job.workMode,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =====================================================
            // SKILLS
            // =====================================================
            if (job.skills.isNotEmpty)
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: job.skills
                    .take(5)
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF4F7FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xffDCE7FF),
                          ),
                        ),
                        child: Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            else
              const Text(
                "No skills specified",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

            const SizedBox(height: 16),

            // =====================================================
            // SALARY
            // =====================================================
            Row(
              children: [
                const Icon(
                  Icons.currency_rupee_rounded,
                  size: 19,
                  color: Color(0xff16A34A),
                ),

                const SizedBox(width: 5),

                Text(
                  job.maximumSalaryLPA > 0
                      ? "₹${job.minimumSalaryLPA} - ₹${job.maximumSalaryLPA} LPA"
                      : "Salary Not Disclosed",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff374151),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // =====================================================
            // DIVIDER
            // =====================================================
            const Divider(
              height: 1,
              color: Color(0xffE5E7EB),
            ),

            const SizedBox(height: 14),

            // =====================================================
            // APPLY BUTTON
            // =====================================================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailScreen(
                        job: {
                          "_id": job.id,
                          "title": job.title,
                          "companyName": job.companyName,
                          "location": job.location,
                          "experienceLevel": job.experienceLevel,
                          "minimumExperienceInYears":
                              job.minimumExperienceInYears,
                          "maximumExperienceInYears":
                              job.maximumExperienceInYears,
                          "minimumSalaryLPA":
                              job.minimumSalaryLPA,
                          "maximumSalaryLPA":
                              job.maximumSalaryLPA,
                          "jobType": job.jobType,
                          "workMode": job.workMode,
                          "skills": job.skills
                              .map(
                                (e) => {
                                  "_id": e.id,
                                  "Name": e.name,
                                },
                              )
                              .toList(),
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  "Apply Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // INFO ITEM
  // =============================================================
  Widget _infoItem({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: const Color(0xff2563EB),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff4B5563),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

