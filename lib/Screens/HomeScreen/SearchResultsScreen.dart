import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zuperr/Screens/HomeScreen/HomeScrrenJobCards.dart';
import 'package:zuperr/Screens/HomeScreen/filterDrawer.dart';
import 'package:zuperr/Services/Filter/filterService.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchText;
  final List<dynamic> jobs;

  const SearchResultsScreen({
    super.key,
    required this.searchText,
    required this.jobs,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _controller;

  List<dynamic> jobs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchText);
    jobs = widget.jobs;
  }

  Future<void> searchJobs(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/jobs/search"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"searchText": query, "page": 1, "limit": 10}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        jobs = List<dynamic>.from(data["jobs"] ?? data["data"] ?? []);
        isLoading = false;
      });
    } else {
      setState(() {
        jobs = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xff1E6BE3),
                image: DecorationImage(
                  image: AssetImage("assets/Head.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        "Search Jobs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Search + Filter
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: _controller,
                            textInputAction: TextInputAction.search,
                            onSubmitted: searchJobs,
                            decoration: InputDecoration(
                              hintText: "Jobs, Company, Skill...",
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  searchJobs(_controller.text);
                                },
                              ),
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
          setState(() {
            isLoading = true;
          });

          final filtered =
              await FilterService.searchJobsByFilters(
            selectedFilters,
          );

          if (!mounted) return;

          setState(() {
            jobs = filtered;
            isLoading = false;
          });
        } catch (e) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

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
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/filter.png",
                              width: 26,
                              height: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (jobs.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No jobs found", style: TextStyle(fontSize: 16)),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, index) {
                    return JobCard(job: jobs[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
