class SavedJobsResponse {
  final List<SavedJob> savedJobs;

  SavedJobsResponse({
    required this.savedJobs,
  });

  factory SavedJobsResponse.fromJson(Map<String, dynamic> json) {
    return SavedJobsResponse(
      savedJobs: (json["savedJobs"] as List? ?? [])
          .map((e) => SavedJob.fromJson(e))
          .toList(),
    );
  }
}

class SavedJob {
  final String id;
  final String title;
  final String location;
  final int minimumExperienceInYears;
  final int maximumExperienceInYears;
  final int minimumSalaryLPA;
  final int maximumSalaryLPA;
  final String companyName;
  final String? companyLogo;
  final List<String> skills;

  SavedJob({
    required this.id,
    required this.title,
    required this.location,
    required this.minimumExperienceInYears,
    required this.maximumExperienceInYears,
    required this.minimumSalaryLPA,
    required this.maximumSalaryLPA,
    required this.companyName,
    this.companyLogo,
    required this.skills,
  });

  factory SavedJob.fromJson(Map<String, dynamic> json) {
    return SavedJob(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      location: json["location"] ?? "",
      minimumExperienceInYears:
          json["minimumExperienceInYears"] ?? 0,
      maximumExperienceInYears:
          json["maximumExperienceInYears"] ?? 0,
      minimumSalaryLPA:
          json["minimumSalaryLPA"] ?? 0,
      maximumSalaryLPA:
          json["maximumSalaryLPA"] ?? 0,
      companyName: json["companyName"] ?? "",
      companyLogo: json["companyLogo"],
      skills: List<String>.from(json["skills"] ?? []),
    );
  }
}