import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';
import 'package:zuperr/Services/skills/SkillService.dart';



class SkillStep extends StatefulWidget {
  const SkillStep({super.key});

  @override
  State<SkillStep> createState() => _SkillStepState();
}
class _SkillStepState extends State<SkillStep> {
  final ResumeController controller = Get.find();

  final TextEditingController searchController =
      TextEditingController();

  List<Skill> allSkills = [];
  List<Skill> filteredSkills = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  Future<void> loadSkills() async {
    final data = await SkillService.getAllSkills();

    allSkills = data;
    filteredSkills = List.from(data);

    setState(() {
      loading = false;
    });
  }

  void onSearch(String value) {
    if (value.trim().isEmpty) {
      filteredSkills = List.from(allSkills);
    } else {
      filteredSkills = allSkills.where((skill) {
        return skill!.name
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    }

    setState(() {});
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: AnimatedPadding(
       duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
      child: Form(
        key: controller.skillFormKey,
        child: SingleChildScrollView(
          
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const Text(
                  "Skills",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  "Search and add your technical & professional skills.",
                ),
                
                const SizedBox(height: 20),
                
                TextField(
                  controller: searchController,
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    hintText: "Search Skills",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 25),
                
                const Text(
                  "Your Skills",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Obx(() {
                  if (controller.skills.isEmpty) {
                    return const Text(
                      "No skills selected",
                      style: TextStyle(color: Colors.grey),
                    );
                  }
                
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () {
                          controller.removeSkill(skill);
                          setState(() {});
                        },
                      );
                    }).toList(),
                  );
                }),
                
                const SizedBox(height: 25),
                
                const Divider(),
                
                const SizedBox(height: 15),
                
                const Text(
                  "Available Skills",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                SizedBox(
                    height: 350,

                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : filteredSkills.isEmpty
                          ? const Center(
                              child: Text("No Skills Found"),
                            )
                          : ListView.builder(
                              itemCount: filteredSkills.length,
                              itemBuilder: (context, index) {
                                final skill = filteredSkills[index];
                
                                final selected = controller.skills.contains(skill.name);
                
                                return ListTile(
                                  title: Text(skill.name),
                                  trailing: Icon(
                                    selected
                                        ? Icons.check_circle
                                        : Icons.add_circle_outline,
                                    color: selected
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
                                  onTap: () {
                                    if (selected) {
                                      controller.removeSkill(skill.name);
                                    } else {
                                      controller.addSkill(skill.name);
                                    }
                
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
