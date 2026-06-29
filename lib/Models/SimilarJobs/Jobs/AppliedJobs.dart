class AppliedJobsResponse {
  final List<AppliedJob> appliedJobs;

  AppliedJobsResponse({
    required this.appliedJobs,
  });

  factory AppliedJobsResponse.fromJson(
      Map<String, dynamic> json) {
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
  final String location;
  final int minimumExperienceInYears;
  final int maximumExperienceInYears;
  final int minimumSalaryLPA;
  final int maximumSalaryLPA;
  final String companyName;
  final String? companyLogo;
  final List<String> skills;
  final ApplicantInfo applicantInfo;

  AppliedJob({
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
    required this.applicantInfo,
  });

  factory AppliedJob.fromJson(
      Map<String, dynamic> json) {
    return AppliedJob(
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
      applicantInfo: ApplicantInfo.fromJson(
        json["applicantInfo"] ?? {},
      ),
    );
  }
}

class ApplicantInfo {
  final String appliedDate;
  final String status;

  ApplicantInfo({
    required this.appliedDate,
    required this.status,
  });

  factory ApplicantInfo.fromJson(
      Map<String, dynamic> json) {
    return ApplicantInfo(
      appliedDate: json["appliedDate"] ?? "",
      status: json["status"] ?? "Applied",
    );
  }
}