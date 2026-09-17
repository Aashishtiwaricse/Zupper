import 'education_model.dart';
import 'experience_model.dart';
import 'project_model.dart';

class ResumeModel {
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String linkedIn;
  final String portfolio;
  final String summary;

  final List<String> skills;

  final List<ExperienceModel> experiences;

  final List<EducationModel> educations;

  final List<ProjectModel> projects;

  ResumeModel({
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.linkedIn,
    required this.portfolio,
    required this.summary,
    required this.skills,
    required this.experiences,
    required this.educations,
    required this.projects,
  });
}