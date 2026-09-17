class SkillModel {
  final List<Skill> skills;

  SkillModel({
    required this.skills,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "skills": skills.map((e) => e.toJson()).toList(),
    };
  }
}

class Skill {
  final String id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json["_id"] ?? "",
      name: json["Name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "Name": name,
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}