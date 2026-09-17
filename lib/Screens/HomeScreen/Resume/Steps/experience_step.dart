import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/experience_Card.dart';

class ExperienceStep extends GetView<ResumeController> {
  const ExperienceStep({super.key});

  @override
  Widget build(BuildContext context) {
     return Form(
      key: controller.experienceFormKey,
    child: Obx(() {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [

         


          ...List.generate(
            controller.experienceControllers.length,
            (index) => ExperienceCard(index: index),
          ),

          const SizedBox(height: 25),

          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Another Experience"),
            onPressed: controller.addExperience,
          ),
        ],
      );
    }));
  }
}