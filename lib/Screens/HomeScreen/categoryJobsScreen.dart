import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';

class CategoryJobsScreen extends StatelessWidget {
  final String title;
  final List<dynamic> jobs;

  const CategoryJobsScreen({
    super.key,
    required this.title,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: JobCard(job: jobs[index]),
          );
        },
      ),
    );
  }
}