import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';

class JobCard extends StatelessWidget {
  final SimilarJobModel job;

  const JobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xffDCE7FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xff2563EB),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// Logo + Bookmark
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "a",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            job.companyName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.bookmark_border),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color(0xff2563EB),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        job.location,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 18,
                      color: Color(0xff2563EB),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${job.minimumExperienceInYears}-${job.maximumExperienceInYears} Years",
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.skills.isEmpty
                      ? [
                          const Chip(
                            label: Text("No Skills"),
                          ),
                        ]
                      : job.skills
                            .map(
                              (skill) => Chip(
                                label: Text(skill.name),
                              ),
                            )
                            .toList(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}