import 'package:flutter/material.dart';
import 'package:get/get.dart';
class EducationFormController {
  final field = TextEditingController();
  final grade = TextEditingController();

  final degree = "Bachelor".obs;

  /// Dropdowns
  final education = "Bachelor".obs;
  final course = "B.Tech".obs;
  final specialization = "Computer Science".obs;

  /// Marks
  final marksType = "CGPA".obs;

  final acquiredMarks = TextEditingController();
  final totalMarks = TextEditingController();

  /// Institute
  final institute = TextEditingController();

  /// Dates
  final startDate = TextEditingController();
  final endDate = TextEditingController();

  /// Course Type
  final courseType = "Full Time".obs;

  final currentlyStudying = false.obs;

  void dispose() {
    institute.dispose();
    field.dispose();
    grade.dispose();
    acquiredMarks.dispose();
    totalMarks.dispose();
    startDate.dispose();
    endDate.dispose();
  }
}