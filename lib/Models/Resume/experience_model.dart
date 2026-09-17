class ExperienceModel {
  final String company;
  final String designation;
  final String location;
  final String startDate;
  final String endDate;
  final String description;
  final bool currentlyWorking;

  ExperienceModel({
    required this.company,
    required this.designation,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.currentlyWorking,
  });

  Map<String, dynamic> toJson() => {
        "company": company,
        "designation": designation,
        "location": location,
        "startDate": startDate,
        "endDate": endDate,
        "description": description,
        "currentlyWorking": currentlyWorking,
      };
}