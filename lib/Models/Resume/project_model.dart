class ProjectModel {
  final String projectName;
  final String role;
  final String technologies;
  final String github;
  final String liveUrl;
  final String description;

  ProjectModel({
    required this.projectName,
    required this.role,
    required this.technologies,
    required this.github,
    required this.liveUrl,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "projectName": projectName,
        "role": role,
        "technologies": technologies,
        "github": github,
        "liveUrl": liveUrl,
        "description": description,
      };
}