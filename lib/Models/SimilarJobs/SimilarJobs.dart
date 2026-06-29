class SimilarJobModel {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String experienceLevel;
  final int minimumExperienceInYears;
  final int maximumExperienceInYears;
  final String workMode;
  final String jobType;
  final int minimumSalaryLPA;
  final int maximumSalaryLPA;
  final List<SkillModel> skills;

  SimilarJobModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.experienceLevel,
    required this.minimumExperienceInYears,
    required this.maximumExperienceInYears,
    required this.workMode,
    required this.jobType,
    required this.minimumSalaryLPA,
    required this.maximumSalaryLPA,
    required this.skills,
  });

  factory SimilarJobModel.fromJson(Map<String, dynamic> json) {
    return SimilarJobModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      companyName: json["companyName"] ?? "",
      location: json["location"] ?? "",
      experienceLevel: json["experienceLevel"] ?? "",
      minimumExperienceInYears: json["minimumExperienceInYears"] ?? 0,
      maximumExperienceInYears: json["maximumExperienceInYears"] ?? 0,
      workMode: json["workMode"] ?? "",
      jobType: json["jobType"] ?? "",
      minimumSalaryLPA: json["minimumSalaryLPA"] ?? 0,
      maximumSalaryLPA: json["maximumSalaryLPA"] ?? 0,
      skills: (json["skills"] as List? ?? [])
          .map((e) => SkillModel.fromJson(e))
          .toList(),
    );
  }
}

class SkillModel {
  final String id;
  final String name;

  SkillModel({
    required this.id,
    required this.name,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json["_id"] ?? "",
      name: json["Name"] ?? "",
    );
  }
}