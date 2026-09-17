import 'package:flutter/material.dart';
import 'package:zuperr/Models/Jobs/savedJobs.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/jobCard.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/savedJobsBin.dart';
import 'package:zuperr/Services/Jobs/savedJobs.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedLocation = "All";
  String selectedExperience = "All";
  Color borderColor = Color(0xFFFF9E9A);
  Color contentColor = Color(0xFFF44336);
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

  void _showFilterSheet() {
    final locations = ["All", ...jobs.map((e) => e.location).toSet()];

    final experiences = ["All", "0-2 Years", "2-5 Years", "5+ Years"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        String tempLocation = selectedLocation;
        String tempExperience = selectedExperience;

        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Filter Jobs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  DropdownButton<String>(
                    value: tempLocation,
                    isExpanded: true,
                    items: locations
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setBottomState(() {
                        tempLocation = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Experience",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  DropdownButton<String>(
                    value: tempExperience,
                    isExpanded: true,
                    items: experiences
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setBottomState(() {
                        tempExperience = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        selectedLocation = tempLocation;
                        selectedExperience = tempExperience;

                        _applyFilters();

                        Navigator.pop(context);
                      },
                      child: const Text("Apply"),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      selectedLocation = "All";
                      selectedExperience = "All";
                      _applyFilters();
                      Navigator.pop(context);
                    },
                    child: const Center(child: Text("Clear Filters")),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    filteredJobs = jobs.where((job) {
      bool matchesLocation =
          selectedLocation == "All" || job.location == selectedLocation;

      bool matchesExperience = true;

      int minExp = job.minimumExperienceInYears;

      if (selectedExperience == "0-2 Years") {
        matchesExperience = minExp <= 2;
      } else if (selectedExperience == "2-5 Years") {
        matchesExperience = minExp >= 2 && minExp <= 5;
      } else if (selectedExperience == "5+ Years") {
        matchesExperience = minExp >= 5;
      }

      return matchesLocation && matchesExperience;
    }).toList();

    setState(() {});
  }

  Future<void> deleteJob(String jobId) async {
    debugPrint("Deleting Job ID: $jobId");

    final success = await SavedJobsService.deleteSavedJob(jobId);

    debugPrint("Delete API Response: $success");

    if (!mounted) return;

    if (success) {
      setState(() {
        jobs.removeWhere((e) => e.id == jobId);
        filteredJobs.removeWhere((e) => e.id == jobId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Job removed successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to remove job"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Future<void> unsaveJob(String jobId) async {
    final success = await SavedJobsService.unsaveJob(jobId);

    if (!mounted) return;

    if (success) {
      setState(() {
        jobs.removeWhere((e) => e.id == jobId);
        filteredJobs.removeWhere((e) => e.id == jobId);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Job unsaved successfully")));

      await fetchJobs();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to unsave job")));
    }
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
                          color: Colors.white.withValues(alpha: .12),
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
                    ),
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
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
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
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: _showFilterSheet,
                  ),
                ),

                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SavedJobsBinScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 65,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: contentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Bin",
                          style: TextStyle(
                            color: contentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            height: 1,
                          ),
                        ),
                      ],
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
                    return const Center(child: CircularProgressIndicator());
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
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filteredJobs.length,
                    itemBuilder: (_, index) {
                      return JobCard(
                        job: filteredJobs[index],
                        onBookmark: () async {
                          await unsaveJob(filteredJobs[index].id);
                        },
                        onDelete: () async {
                          await deleteJob(filteredJobs[index].id);
                        },
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
