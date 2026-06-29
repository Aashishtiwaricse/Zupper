import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchText;
  final List<dynamic> jobs;

  const SearchResultsScreen({
    super.key,
    required this.searchText,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results for \"$searchText\""),
      ),
      body: jobs.isEmpty
          ? const Center(
              child: Text(
                "No jobs found",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return JobCard(
                  job: jobs[index],
                );
              },
            ),
    );
  }
}