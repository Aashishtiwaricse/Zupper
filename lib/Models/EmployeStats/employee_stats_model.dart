class EmployeeStatsModel {
  final bool success;
  final Range range;
  final Totals totals;
  final List<StatsData> data;

  EmployeeStatsModel({
    required this.success,
    required this.range,
    required this.totals,
    required this.data,
  });

  factory EmployeeStatsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeStatsModel(
      success: json["success"],
      range: Range.fromJson(json["range"]),
      totals: Totals.fromJson(json["totals"]),
      data: (json["data"] as List)
          .map((e) => StatsData.fromJson(e))
          .toList(),
    );
  }
}

class Range {
  final String startDate;
  final String endDate;

  Range({
    required this.startDate,
    required this.endDate,
  });

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      startDate: json["startDate"],
      endDate: json["endDate"],
    );
  }
}

class Totals {
  final int jobsViewed;
  final int jobsApplied;

  Totals({
    required this.jobsViewed,
    required this.jobsApplied,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      jobsViewed: json["jobsViewed"],
      jobsApplied: json["jobsApplied"],
    );
  }
}

class StatsData {
  final String date;
  final int jobsViewed;
  final int jobsApplied;

  StatsData({
    required this.date,
    required this.jobsViewed,
    required this.jobsApplied,
  });

  factory StatsData.fromJson(Map<String, dynamic> json) {
    return StatsData(
      date: json["date"],
      jobsViewed: json["jobsViewed"],
      jobsApplied: json["jobsApplied"],
    );
  }
}