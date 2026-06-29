import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs/Jobs/savedJobs.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/jobCard.dart';
import 'package:zuperr/Services/Jobs/savedJobs.dart';


class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final TextEditingController searchController = TextEditingController();

  List<SavedJob> jobs = [];
  List<SavedJob> filteredJobs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();

    searchController.addListener(_searchJobs);
  }

  Future<void> fetchJobs() async {
    setState(() => isLoading = true);

    final data = await SavedJobsService.getSavedJobs();

    if (!mounted) return;

    setState(() {
      jobs = data;
      filteredJobs = data;
      isLoading = false;
    });
  }

  void _searchJobs() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredJobs = jobs.where((job) {
        return job.title.toLowerCase().contains(query) ||
            job.companyName.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query);
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
      backgroundColor: const Color(0xffF8F9FC),

      body: Column(
        children: [

          /// HEADER
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
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Text(
                      "Saved Jobs",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff1E6BE3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // filter bottom sheet (Part 3C)
                    },
                  ),
                ),

                const SizedBox(width: 12),

                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Bin",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(90, 50),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchJobs,
              child: Builder(
                builder: (_) {
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (filteredJobs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Saved Jobs",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(bottom: 20),
                    itemCount: filteredJobs.length,
                    itemBuilder: (_, index) {
                      return JobCard(
                        job: filteredJobs[index],
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