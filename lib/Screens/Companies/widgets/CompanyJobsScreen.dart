import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';
import 'package:zuperr/Models/_job_response.dart';
import 'package:zuperr/Screens/Companies/widgets/company_job_card.dart';

class CompanyJobsScreen extends StatelessWidget {
  final CompanyById company;
  final List<CompanyJob> jobs;

  const CompanyJobsScreen({
    super.key,
    required this.company,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(
          company.companyName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {},

        child: jobs.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 160),

                  Icon(
                    Icons.work_outline,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "No Jobs Available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.all(20),

                itemCount: jobs.length + 1,

                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 22,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Posted Jobs",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration:
                                BoxDecoration(
                              color: const Color(
                                  0xffEEF4FF),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
                            ),
                            child: Text(
                              jobs.length
                                  .toString(),
                              style:
                                  const TextStyle(
                                color: Color(
                                    0xff1E6BE3),
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final job = jobs[index - 1];

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 18,
                    ),
                    child: CompanyJobCard(
                      job: job,
                      onTap: () {
                        // TODO:
                        // Navigate to Job Details
                      },
                      onApply: () {
                        // TODO:
                        // Apply Job API
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}