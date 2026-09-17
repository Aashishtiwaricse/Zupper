import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ExperienceFormController {
  final months = "".obs;
  final years = "".obs;

  final company = TextEditingController();
  final designation = TextEditingController();

  final fromDate = TextEditingController();
  final toDate = TextEditingController();

  final achievements = TextEditingController();
  final annualSalary = TextEditingController();
  final location = TextEditingController();
  final description = TextEditingController();

  final currentlyWorking = false.obs;

  void dispose() {
    company.dispose();
    designation.dispose();
    fromDate.dispose();
    toDate.dispose();
    achievements.dispose();
    annualSalary.dispose();
    description.dispose();
  }
}