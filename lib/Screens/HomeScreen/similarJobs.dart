import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart' hide JobCard;
import 'package:zuperr/Screens/HomeScreen/SimilarJobsCard/similarJobsCard.dart';
import 'package:zuperr/Screens/HomeScreen/allJobs.dart' hide JobCard;
import 'package:zuperr/Screens/HomeScreen/similarJobsAllScreen.dart';
import 'package:zuperr/Services/SimilarJobs/similarJobs.dart';

class SimilarJobs extends StatelessWidget {
  final String jobId;

  const SimilarJobs({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SimilarJobModel>>(
      future: SimilarJobsService.fetchSimilarJobs(jobId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load similar jobs"));
        }

        final jobs = snapshot.data ?? [];

        if (jobs.isEmpty) {
          return const Center(child: Text("No similar jobs found"));
        }

        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        const Text(
                          "Similar Jobs",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffECECEC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("${jobs.length}"),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SimilarJobsAllScreen(jobs: jobs),
                          ),
                        );
                      },
                      child: const Text(
                        "See all",
                        style: TextStyle(
                          color: HomeScreen.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 420, // Adjust based on your JobCard height
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: jobs.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.82,
                      child: JobCard(job: jobs[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
