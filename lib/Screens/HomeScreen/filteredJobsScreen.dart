import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/accoiunt&Security.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScrrenJobCards.dart';
import 'package:zuperr/Screens/HomeScreen/filterDrawer.dart';
import 'package:zuperr/Services/Filter/filterService.dart';

class FilteredJobsScreen extends StatefulWidget {
  final List<dynamic> jobs;

  const FilteredJobsScreen({super.key, required this.jobs});

  @override
  State<FilteredJobsScreen> createState() => _FilteredJobsScreenState();
}

class _FilteredJobsScreenState extends State<FilteredJobsScreen> {
  late List<dynamic> filteredJobs;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredJobs = widget.jobs;
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchJob(String value) {
  final query = value.trim().toLowerCase();

  if (query.isEmpty) {
    setState(() {
      filteredJobs = widget.jobs;
    });
    return;
  }

  setState(() {
    filteredJobs = widget.jobs.where((job) {
      final title = (job["title"] ?? "")
          .toString()
          .toLowerCase();

      final company = (job["company"] ?? "")
          .toString()
          .toLowerCase();

      return title.contains(query) ||
          company.contains(query);
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FC),

      body: SafeArea(
        child: Column(
          children: [
            _header(),

            /// Header
            const SizedBox(height: 18),
          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      Expanded(
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              searchJob(value);
              setState(() {});
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search Jobs",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        searchController.clear();
                        searchJob("");
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),

      const SizedBox(width: 12),

      GestureDetector(
        onTap: () {
         FilterDrawer.show(
  context,
  (selectedFilters) async {
    try {
      final jobs = await FilterService.searchJobsByFilters(
        selectedFilters,
      );

      if (!mounted) return;

      setState(() {
        filteredJobs = jobs;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to search jobs: $e",
          ),
        ),
      );
    }
  },
);
        },
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              "assets/filter.png",
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    ],
  ),
),

            Expanded(
              child: filteredJobs.isEmpty
                  ? const Center(
                      child: Text(
                        "No jobs found",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredJobs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (_, index) {
                        return JobCard(job: filteredJobs[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xff135FCB)),
      child: Stack(
        children: [
          /// Grid Background
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          /// Stars
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: StarPainter())),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 35),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 28),

                      const Text(
                        "Searched jobs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          filteredJobs.length.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
