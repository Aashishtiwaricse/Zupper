import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/profile_bottom_sheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/profile_month_picker.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/profile_primary_button.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/profile_text_field.dart';
import 'package:zuperr/Services/PofileUpdate/profile_update.dart';
import 'package:zuperr/Services/skills/SkillService.dart';

class ProjectBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? project;
  final int? index;
  final List<dynamic> projects;
  final VoidCallback onSaved;

  const ProjectBottomSheet({
    super.key,
    this.project,
    this.index,
    required this.projects,
    required this.onSaved,
  });

  @override
  State<ProjectBottomSheet> createState() => _ProjectBottomSheetState();
}

class _ProjectBottomSheetState extends State<ProjectBottomSheet> {
  final projectController = TextEditingController();

  final descriptionController = TextEditingController();

  final resultController = TextEditingController();

  final urlController = TextEditingController();

  final fromController = TextEditingController();

  final toController = TextEditingController();

  final formKey = GlobalKey<FormState>();





  final skillsController = TextEditingController();
final FocusNode skillsFocus = FocusNode();

bool saving = false;
bool skillsLoading = true;

List<Skill> allSkills = [];
List<Skill> filteredSkills = [];
List<Skill> selectedSkills = [];

Timer? skillsDebounce;


Future<void> loadSkills() async {
  try {
    final skills = await SkillService.getAllSkills();

    allSkills = skills;
    filteredSkills = List.from(allSkills);

    // Load existing project skills in EDIT mode
    if (widget.project != null) {
      final existingSkills =
          widget.project!["keySkills"]?.toString() ?? "";

      if (existingSkills.trim().isNotEmpty) {
        final names = existingSkills
            .split(",")
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toSet();

        selectedSkills = allSkills
            .where(
              (skill) => names.contains(skill.name.trim().toLowerCase()),
            )
            .toList();

        // Keep skills that may not exist in API
        for (final name in existingSkills.split(",")) {
          final cleanName = name.trim();

          if (cleanName.isEmpty) continue;

          final alreadyExists = selectedSkills.any(
            (skill) =>
                skill.name.trim().toLowerCase() ==
                cleanName.toLowerCase(),
          );

          if (!alreadyExists) {
            selectedSkills.add(
              Skill(
                id: "",
                name: cleanName,
              ),
            );
          }
        }
      }
    }
  } catch (e) {
    debugPrint("Skills loading error: $e");
  }

  if (!mounted) return;

  setState(() {
    skillsLoading = false;
  });
}


void searchSkills(String value) {
  skillsDebounce?.cancel();

  skillsDebounce = Timer(
    const Duration(milliseconds: 300),
    () {
      if (value.trim().isEmpty) {
        filteredSkills = List.from(allSkills);
      } else {
        final query = value.trim().toLowerCase();

        filteredSkills = allSkills.where((skill) {
          return skill.name.toLowerCase().contains(query);
        }).toList();
      }

      if (mounted) {
        setState(() {});
      }
    },
  );
}
void addSkill(Skill skill) {
  final alreadySelected = selectedSkills.any(
    (item) => item.id == skill.id,
  );

  if (alreadySelected) return;

  setState(() {
    selectedSkills.add(skill);
  });
}

void removeSkill(Skill skill) {
  setState(() {
    selectedSkills.removeWhere(
      (item) => item.id == skill.id,
    );
  });
}
  String apiDate(String value) {
    final date = DateFormat("MMM yyyy").parse(value);
    return DateFormat("yyyy-MM-01").format(date);
  }

  String formatMonth(String? value) {
    if (value == null || value.isEmpty) return "";

    try {
      final date = DateTime.parse(value);
      return DateFormat("MMM yyyy").format(date);
    } catch (e) {
      return "";
    }
  }

  Future<void> saveProject() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      saving = true;
    });

    List<dynamic> projects = List.from(widget.projects);

    final projectData = {
      "projectName": projectController.text.trim(),
      "duration": {
        "from": apiDate(fromController.text),
        "to": apiDate(toController.text),
      },
      "description": descriptionController.text.trim(),
"keySkills": selectedSkills
    .map((skill) => skill.name)
    .join(", "),
      "endResult": resultController.text.trim(),
      "projectURL": urlController.text.trim(),
    };

    if (widget.index == null) {
      projects.add(projectData);
    } else {
      projects[widget.index!] = projectData;
    }

    final success = await ProfileUpdateService().updateProfile(
      data: {"projects": projects},
    );

    setState(() {
      saving = false;
    });

    if (success) {
      widget.onSaved();
      if (mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.index == null
                ? "Project added successfully"
                : "Project updated successfully",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save project")));
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.project != null) {
      loadProject();
    }
      loadSkills();

  }

  void loadProject() {
    final p = widget.project!;

    projectController.text = p["projectName"] ?? "";

    descriptionController.text = p["description"] ?? "";

    resultController.text = p["endResult"] ?? "";

    urlController.text = p["projectURL"] ?? "";

    if (p["duration"] != null) {
      fromController.text = formatMonth(p["duration"]["from"]);

      toController.text = formatMonth(p["duration"]["to"]);
    }

  
  }

  @override
void dispose() {
  projectController.dispose();
  descriptionController.dispose();
  resultController.dispose();
  urlController.dispose();
  fromController.dispose();
  toController.dispose();

  skillsController.dispose();
  skillsFocus.dispose();

  skillsDebounce?.cancel();

  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return ProfileBottomSheet(
      title: widget.project == null ? "Add Project" : "Edit Project",

      subtitle:
          "Projects let you showcase your hands-on experience, highlighting how you're applying your skills in real-world scenarios and helping employers assess your practical abilities for the right job match.",

      bottomButton: ProfilePrimaryButton(
        title: "Save",

        loading: saving,

        onPressed: saveProject,
      ),

      child: Form(
        key: formKey,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileTextField(
              label: "Project Name",

              hint: "Enter project name",

              controller: projectController,

              requiredField: true,
            ),

            const SizedBox(height: 20),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Project Duration",
                    style: const TextStyle(
                      color: Color(0xff363B44),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ProfileMonthPicker(
                  label: "",

                  requiredField: false,

                  controller: fromController,
                ),

                const SizedBox(width: 7),
                Text(
                  "To",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                                const SizedBox(width: 7),


                ProfileMonthPicker(
                  label: "",

                  requiredField: false,

                  controller: toController,
                ),
              ],
            ),

            const SizedBox(height: 20),

            ProfileTextField(
              label: "Description",

              hint: "Describe your project",

              controller: descriptionController,

              maxLines: 5,

              maxLength: 300,
            ),

            const SizedBox(height: 20),

           const Text(
  "Key Skills used in the project (Optional)",
  style: TextStyle(
    color: Color(0xff363B44),
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 12),

TextField(
  controller: skillsController,
  focusNode: skillsFocus,
  onChanged: searchSkills,
  decoration: InputDecoration(
    hintText: "Search skills",
    prefixIcon: const Icon(Icons.search),
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 14,
      horizontal: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
),

const SizedBox(height: 14),

// Selected skills
if (selectedSkills.isNotEmpty)
  Wrap(
    spacing: 10,
    runSpacing: 10,
    children: selectedSkills.map((skill) {
      return Chip(
        label: Text(skill.name),
        deleteIcon: const Icon(
          Icons.close,
          size: 18,
        ),
        backgroundColor: const Color(0xffEEF4FF),
        side: BorderSide.none,
        onDeleted: () {
          removeSkill(skill);
        },
      );
    }).toList(),
  ),

if (selectedSkills.isNotEmpty)
  const SizedBox(height: 15),

// Skills from API
if (skillsLoading)
  const Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  )
else
  SizedBox(
    height: 220,
    child: filteredSkills.isEmpty
        ? Center(
            child: Text(
              "No Skills Found",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        : ListView.separated(
            itemCount: filteredSkills.length,
            separatorBuilder: (_, __) => Divider(
              color: Colors.grey.shade200,
              height: 1,
            ),
            itemBuilder: (_, index) {
              final skill = filteredSkills[index];

              final selected = selectedSkills.any(
                (item) => item.id == skill.id,
              );

              return InkWell(
                onTap: () {
                  if (selected) {
                    removeSkill(skill);
                  } else {
                    addSkill(skill);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.blue
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(6),
                          border: Border.all(
                            color: selected
                                ? Colors.blue
                                : Colors.grey.shade400,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  ),

            const SizedBox(height: 20),

            ProfileTextField(
              label: "Result / Conclusion",

              hint: "What was the result of the project?",

              controller: resultController,
            ),

            const SizedBox(height: 20),

            ProfileTextField(
              label: "Project URL",

              hint: "Enter project URL",

              controller: urlController,

              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }
}
