class InternshipModel {
  String? companyName;
  String? role;
  InternshipDuration? duration;
  String? projectName;
  String? description;
  String? keySkills;
  String? projectURL;

  InternshipModel({
    this.companyName,
    this.role,
    this.duration,
    this.projectName,
    this.description,
    this.keySkills,
    this.projectURL,
  });

  factory InternshipModel.fromJson(Map<String, dynamic> json) {
    return InternshipModel(
      companyName: json["companyName"],
      role: json["role"],
      duration: json["duration"] != null
          ? InternshipDuration.fromJson(json["duration"])
          : InternshipDuration(),
      projectName: json["projectName"],
      description: json["description"],
      keySkills: json["keySkills"],
      projectURL: json["projectURL"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "companyName": companyName,
      "role": role,
      "duration": duration?.toJson(),
      "projectName": projectName,
      "description": description,
      "keySkills": keySkills,
      "projectURL": projectURL,
    };
  }
}

class InternshipDuration {
  String? from;
  String? to;

  InternshipDuration({
    this.from,
    this.to,
  });

  factory InternshipDuration.fromJson(Map<String, dynamic> json) {
    return InternshipDuration(
      from: json["from"],
      to: json["to"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "to": to,
    };
  }
}