class EducationModel {
  final String institute;
  final String degree;
  final String field;
  final String grade;
  final String startDate;
  final String endDate;
  final bool currentlyStudying;

  EducationModel({
    required this.institute,
    required this.degree,
    required this.field,
    required this.grade,
    required this.startDate,
    required this.endDate,
    required this.currentlyStudying,
  });

  Map<String, dynamic> toJson() => {
        "institute": institute,
        "degree": degree,
        "field": field,
        "grade": grade,
        "startDate": startDate,
        "endDate": endDate,
        "currentlyStudying": currentlyStudying,
      };
}