class JobApplicationStatus {
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String location;
  final int daysSinceApplication;
  final String status;
  final String description;
  final String experienceLevel;

  JobApplicationStatus({
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.daysSinceApplication,
    required this.status,
    required this.description,
    required this.experienceLevel,
  });

  factory JobApplicationStatus.fromJson(Map<String, dynamic> json) {
    return JobApplicationStatus(
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
      daysSinceApplication: json['daysSinceApplication'] ?? 0,
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      experienceLevel: json['experienceLevel'] ?? '',
    );
  }
}