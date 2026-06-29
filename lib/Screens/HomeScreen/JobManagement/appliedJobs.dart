import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs/AppliedJobs/appliedJobs.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/appliedJobsCard.dart';

import '../../../Services/Jobs/appliedJobs.dart';


class AppliedJobsScreen extends StatefulWidget {
  const AppliedJobsScreen({super.key});

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  final TextEditingController searchController =
      TextEditingController();

  List<AppliedJob> jobs = [];
  List<AppliedJob> filteredJobs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadJobs();

    searchController.addListener(searchJobs);
  }

  Future<void> loadJobs() async {
    setState(() {
      isLoading = true;
    });

    final data =
        await AppliedJobsService.getAppliedJobs();

    if (!mounted) return;

    setState(() {
    
      isLoading = false;
    });
  }

  void searchJobs() {
    final query =
        searchController.text.toLowerCase();

    setState(() {
      filteredJobs = jobs.where((job) {
        return job.title
                .toLowerCase()
                .contains(query) ||
            job.companyName
                .toLowerCase()
                .contains(query) ||
            job.location
                .toLowerCase()
                .contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: Column(
        children: [

          /// Header
          Container(
            height: 165,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Row(
                  children: [

                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(context),

                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(.15),
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Text(
                      "Applied Jobs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Search
          Padding(
            padding:
                const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.search),
                hintText: "Search Jobs",

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadJobs,

              child: Builder(
                builder: (_) {
                  if (isLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (filteredJobs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Applied Jobs",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(
                            bottom: 20),
                    itemCount:
                        filteredJobs.length,
                    itemBuilder:
                        (_, index) {

                      return AppliedJobCard(
                        job:
                            filteredJobs[index],
                      );
                    },
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