import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Models/Resume/resume_model.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/resumePdfGenerator.dart';

class ResumePreviewScreen extends StatelessWidget {
  final ResumeModel resume;

  const ResumePreviewScreen({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resume.fullName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                resume.jobTitle,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),

              Text(resume.email),
              Text(resume.phone),
              Text(
                '${resume.city}, ${resume.state}, ${resume.country}',
              ),

              const Divider(height: 30),

              const Text(
                'Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(resume.summary),

              const SizedBox(height: 20),

              const Text(
                'Skills',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: resume.skills
                    .map(
                      (e) => Chip(label: Text(e)),
                    )
                    .toList(),
              ),

              const SizedBox(height: 20),

              const Text(
                'Experience',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...resume.experiences.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.designation,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(e.company),
                      Text('${e.startDate} - ${e.endDate}'),
                      Text(e.description),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Education',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...resume.educations.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.degree,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(e.institute),
                      Text('${e.startDate} - ${e.endDate}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Projects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...resume.projects.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.projectName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(e.role),
                      Text(e.technologies),
                      Text(e.description),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download PDF'),
                onPressed: () async {

  await ResumePdfGenerator.generate(resume);

},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}