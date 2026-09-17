class AppliedJobsResponse {
  final List<AppliedJob> appliedJobs;

  AppliedJobsResponse({
    required this.appliedJobs,
  });

  factory AppliedJobsResponse.fromJson(Map<String, dynamic> json) {
    return AppliedJobsResponse(
      appliedJobs: (json["appliedJobs"] as List? ?? [])
          .map((e) => AppliedJob.fromJson(e))
          .toList(),
    );
  }
}

class AppliedJob {
  final String id;
  final String title;
  final String companyName;
  final String? companyLogo;
  final String location;

  // Old names
  final int minExp;
  final int maxExp;
  final int minSalary;
  final int maxSalary;

  final List<String> skills;
  final DateTime appliedDate;
  final String status;

  AppliedJob({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.minExp,
    required this.maxExp,
    required this.minSalary,
    required this.maxSalary,
    required this.skills,
    required this.appliedDate,
    required this.status,
  });

  factory AppliedJob.fromJson(Map<String, dynamic> json) {
    return AppliedJob(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      companyName: json["companyName"] ?? "",
      companyLogo: json["companyLogo"],
      location: json["location"] ?? "",
      minExp: json["minimumExperienceInYears"] ?? 0,
      maxExp: json["maximumExperienceInYears"] ?? 0,
      minSalary: json["minimumSalaryLPA"] ?? 0,
      maxSalary: json["maximumSalaryLPA"] ?? 0,
      skills: List<String>.from(json["skills"] ?? []),
      appliedDate: DateTime.parse(
        json["applicantInfo"]?["appliedDate"] ??
            DateTime.now().toIso8601String(),
      ),
      status: json["applicantInfo"]?["status"] ?? "Applied",
    );
  }
}