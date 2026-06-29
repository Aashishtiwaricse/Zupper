import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/homeScreen.dart'; // for JobCard

class FilteredJobsScreen extends StatelessWidget {
  final List<dynamic> jobs;

  const FilteredJobsScreen({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtered Jobs (${jobs.length})"),
      ),
      body: jobs.isEmpty
          ? const Center(
              child: Text("No jobs found"),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return JobCard(job: jobs[index]);
              },
            ),
    );
  }
}