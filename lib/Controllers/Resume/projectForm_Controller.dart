import 'package:flutter/material.dart';

class ProjectFormController {
  final projectName = TextEditingController();
  final role = TextEditingController();
  final technologies = TextEditingController();
  final github = TextEditingController();
  final liveUrl = TextEditingController();
  final description = TextEditingController();

  void dispose() {
    projectName.dispose();
    role.dispose();
    technologies.dispose();
    github.dispose();
    liveUrl.dispose();
    description.dispose();
  }
}