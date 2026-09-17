import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';
import 'package:zuperr/Models/_job_response.dart';
import 'package:zuperr/Screens/Companies/widgets/CompanyJobDetailScreen.dart';
import 'package:zuperr/Screens/Companies/widgets/CompanyJobsScreen.dart';
import 'package:zuperr/Screens/Companies/widgets/company_job_card.dart';
import 'package:zuperr/Services/Company/companyService.dart';

class PostedJobsSection extends StatefulWidget {
  final CompanyById company;

  const PostedJobsSection({super.key, required this.company});

  @override
  State<PostedJobsSection> createState() => _PostedJobsSectionState();
}

class _PostedJobsSectionState extends State<PostedJobsSection> {
  bool isLoading = true;

  List<CompanyJob> jobs = [];

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      jobs = await CompanyService.getJobs(widget.company.id);
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    double cardHeight;

    if (screenHeight < 700) {
      cardHeight = screenHeight * 0.72; // Small phones
    } else if (screenHeight < 850) {
      cardHeight = screenHeight * 0.66; // Medium phones
    } else {
      cardHeight = screenHeight * 0.60; // Large phones
    }
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (jobs.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: Row(
              children: [
                const Text(
                  "Posted Jobs",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF4FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    jobs.length.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const Spacer(),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyJobsScreen(
                          company: widget.company,
                          jobs: jobs,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(
                      color: Color(0xff1E6BE3),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          GestureDetector(
            child: SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: jobs.length > 3 ? 3 : jobs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (_, index) {
                  return GestureDetector(

                          onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompanyJobDetailScreen(
                job: jobs[index], // <-- pass single job
              ),
            ),
          );
        },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .84,
                      child: CompanyJobCard(job: jobs[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
