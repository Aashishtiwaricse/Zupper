import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/Form/responsive_form.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/common/add_more_button.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/common/form_section_card.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/common/section_header.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/custom_textfield.dart';


class ProjectStep extends GetView<ResumeController> {
  const ProjectStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.projectFormKey,
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.all(24),
          children: [

            const Text(
              "Projects",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Showcase your best projects.",
            ),

            const SizedBox(height: 24),

            ...List.generate(
  controller.projectControllers.length,

              (index) => ProjectCard(index: index),
            ),

            const SizedBox(height: 20),

            AddMoreButton(
              title: "Add Another Project",
              onPressed: controller.addProject,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends GetView<ResumeController> {
  final int index;

  const ProjectCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    final item = controller.projectControllers[index];

    return FormSectionCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          SectionHeader(

            title: "Project ${index + 1}",

            onDelete: controller.projectControllers.length == 1
                ? null
                : () => controller.removeProject(index),
          ),

          const SizedBox(height: 20),

          ResponsiveForm(

            children: [

              CustomTextField(
                controller: item.projectName,
                label: "Project Name",
                hint: "Resume Builder",
                validator: (v) =>
                    v == null || v.isEmpty
                        ? "Required"
                        : null,
              ),

              CustomTextField(
                controller: item.role,
                label: "Role",
                hint: "Flutter Developer",
              ),

              CustomTextField(
                controller: item.technologies,
                label: "Technologies",
                hint: "Flutter, GetX, Firebase",
              ),

              CustomTextField(
                controller: item.github,
                label: "GitHub URL",
                hint: "https://github.com/",
              ),

              CustomTextField(
                controller: item.liveUrl,
                label: "Live URL",
                hint: "https://example.com",
              ),
            ],
          ),

          const SizedBox(height: 20),

          CustomTextField(
            controller: item.description,
            label: "Project Description",
            hint:
                "Describe your project, features, responsibilities and achievements.",
            maxLines: 6,
          ),
        ],
      ),
    );
  }
}