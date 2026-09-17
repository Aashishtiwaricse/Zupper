class CompanyJobsResponse {
  final bool success;
  final CompanyJobsData data;

  CompanyJobsResponse({required this.success, required this.data});

  factory CompanyJobsResponse.fromJson(Map<String, dynamic> json) {
    return CompanyJobsResponse(
      success: json["success"] ?? false,
      data: CompanyJobsData.fromJson(json["data"] ?? {}),
    );
  }
}

class CompanyJobsData {
  final List<CompanyJob> jobs;

  CompanyJobsData({required this.jobs});

  factory CompanyJobsData.fromJson(Map<String, dynamic> json) {
    return CompanyJobsData(
      jobs: (json["jobs"] as List? ?? [])
          .map((e) => CompanyJob.fromJson(e))
          .toList(),
    );
  }
}

class CompanyJob {
  final String id;
  final String title;

  final String experienceLevel;
  final int minimumExperienceInYears;
  final int maximumExperienceInYears;

  final String jobCategory;
  final String jobType;
  final String workMode;

  final double minimumSalaryLpa;
  final double maximumSalaryLpa;

  final List<JobSkill> skills;

  final String education;
  final List<String> industry;
  final String degree;

  final String jobDescription;

  final String location;
  final double distance;

  final bool isActive;
  final bool isSponsored;

  final int jobViewsCount;

  final CompanyRecruiter createdBy;

  final List<JobApplicant> applicants;

  final String jobStatus;

  final DateTime createdAt;

  CompanyJob({
    required this.id,
    required this.title,
    required this.experienceLevel,
    required this.minimumExperienceInYears,
    required this.maximumExperienceInYears,
    required this.jobCategory,
    required this.jobType,
    required this.workMode,
    required this.minimumSalaryLpa,
    required this.maximumSalaryLpa,
    required this.skills,
    required this.education,
    required this.industry,
    required this.degree,
    required this.jobDescription,
    required this.location,
    required this.distance,
    required this.isActive,
    required this.isSponsored,
    required this.jobViewsCount,
    required this.createdBy,
    required this.applicants,
    required this.jobStatus,
    required this.createdAt,
  });

  factory CompanyJob.fromJson(Map<String, dynamic> json) {
    return CompanyJob(
      id: json["_id"] ?? "",

      title: json["title"] ?? "",

      experienceLevel: json["experienceLevel"] ?? "",

      minimumExperienceInYears: json["minimumExperienceInYears"] ?? 0,

      maximumExperienceInYears: json["maximumExperienceInYears"] ?? 0,

      jobCategory: json["jobCategory"] ?? "",

      jobType: json["jobType"] ?? "",

      workMode: json["workMode"] ?? "",

      minimumSalaryLpa: (json["minimumSalaryLPA"] as num?)?.toDouble() ?? 0,

      maximumSalaryLpa: (json["maximumSalaryLPA"] as num?)?.toDouble() ?? 0,

      skills: (json["skills"] as List? ?? [])
          .map((e) => JobSkill.fromJson(e))
          .toList(),

      education: json["education"] ?? "",

      industry: List<String>.from(json["industry"] ?? []),

      degree: json["degree"] ?? "",

      jobDescription: json["jobDescription"] ?? "",

      location: json["location"] ?? "",

      distance: (json["distance"] as num?)?.toDouble() ?? 0,

      isActive: json["isActive"] ?? false,

      isSponsored: json["isSponsored"] ?? false,

      jobViewsCount: json["jobViewsCount"] ?? 0,

      createdBy: CompanyRecruiter.fromJson(json["createdBy"] ?? {}),

      applicants: (json["applicants"] as List? ?? [])
          .map((e) => JobApplicant.fromJson(e))
          .toList(),

      jobStatus: json["jobStatus"] ?? "",

      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }
}

class JobSkill {
  final String id;
  final String name;

  JobSkill({required this.id, required this.name});

  factory JobSkill.fromJson(Map<String, dynamic> json) {
    return JobSkill(id: json["_id"] ?? "", name: json["Name"] ?? "");
  }
}

class CompanyRecruiter {
  final String companyId;
  final String companyName;

  CompanyRecruiter({required this.companyId, required this.companyName});

  factory CompanyRecruiter.fromJson(Map<String, dynamic> json) {
    return CompanyRecruiter(
      companyId: json["companyId"] ?? "",
      companyName: json["companyName"] ?? "",
    );
  }
}

class JobApplicant {
  final String id;
  final String status;
  final int score;
  final DateTime appliedDate;

  JobApplicant({
    required this.id,
    required this.status,
    required this.score,
    required this.appliedDate,
  });

  factory JobApplicant.fromJson(Map<String, dynamic> json) {
    return JobApplicant(
      id: json["_id"] ?? "",
      status: json["status"] ?? "",
      score: json["score"] ?? 0,
      appliedDate:
          DateTime.tryParse(json["appliedDate"] ?? "") ?? DateTime.now(),
    );
  }
}
