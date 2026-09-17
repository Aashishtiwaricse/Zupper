import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';
import 'package:zuperr/Services/skills/SkillService.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class SkillsBottomSheet extends StatefulWidget {
  final List<dynamic> selectedSkills;
  final String profileSummary;
  final VoidCallback onSaved;

  const SkillsBottomSheet({
    super.key,
    required this.selectedSkills,
    required this.profileSummary,
    required this.onSaved,
  });

  @override
  State<SkillsBottomSheet> createState() => _SkillsBottomSheetState();
}
class _SkillsBottomSheetState extends State<SkillsBottomSheet> {

  final TextEditingController searchController =
      TextEditingController();

  final FocusNode searchFocus = FocusNode();

  List<Skill> allSkills = [];

  List<Skill> filteredSkills = [];

  List<Skill> selectedSkills = [];

  bool loading = true;

  bool saving = false;

  Timer? debounce;
    @override
  void initState() {
    super.initState();

    loadSkills();
  }
    @override
  void dispose() {

    debounce?.cancel();

    searchController.dispose();

    searchFocus.dispose();

    super.dispose();
  }
  Future<void> loadSkills() async {

  final skills = await SkillService.getAllSkills();

  selectedSkills = widget.selectedSkills
      .map((e) => Skill(
            id: e["_id"],
            name: e["Name"],
          ))
      .toList();

  allSkills = skills;

  filteredSkills = List.from(allSkills);

  loading = false;

  if (mounted) {
    setState(() {});
  }
}
void onSearch(String value) {

  debounce?.cancel();

  debounce = Timer(
    const Duration(milliseconds: 300),
    () {

      if(value.trim().isEmpty){

        filteredSkills = List.from(allSkills);

      }else{

        filteredSkills = allSkills.where((skill){

          return skill.name
              .toLowerCase()
              .contains(value.toLowerCase());

        }).toList();

      }

      if(mounted){
        setState(() {});
      }

    },
  );
}
void addSkill(Skill skill){

  if(selectedSkills.contains(skill)){
    return;
  }

  selectedSkills.add(skill);

  setState(() {});
}
void removeSkill(Skill skill){

  selectedSkills.remove(skill);

  setState(() {});
}
Future<void> saveSkills() async {

  if(saving) return;

  saving = true;

  setState(() {});

  final success = await CandidateUpdateService1.update(

    updatedFields: {
      "profileSummary": widget.profileSummary,
      "keySkills": selectedSkills.map((e) => e.id).toList(),
    },

  );

  saving = false;

  if(!mounted) return;

  if(success){

    widget.onSaved();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text("Skills updated successfully"),
      ),

    );

  }else{

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text("Unable to update skills"),
      ),

    );

  }

  setState(() {});
}
@override
Widget build(BuildContext context) {
  final bottom = MediaQuery.of(context).viewInsets.bottom;

  return AnimatedPadding(
    duration: const Duration(milliseconds: 250),
    padding: EdgeInsets.only(bottom: bottom),
    child: Container(
      height: MediaQuery.of(context).size.height * .88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [

                  const SizedBox(height: 12),

                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Key Skills",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Key Skills lets you highlight your core abilities and expertise, helping employers quickly identify your strengths.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Skills Expert in *",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 14),

                          TextField(
                            controller: searchController,
                            focusNode: searchFocus,
                            onChanged: onSearch,
                            decoration: InputDecoration(
                              hintText: "Search skills",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
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
                                  backgroundColor:
                                      const Color(0xffEEF4FF),
                                  side: BorderSide.none,
                                  onDeleted: () {
                                    removeSkill(skill);
                                  },
                                );

                              }).toList(),
                            ),

                          if (selectedSkills.isNotEmpty)
                            const SizedBox(height: 20),
                                                      Expanded(
                            child: filteredSkills.isEmpty
                                ? Center(
                                    child: Text(
                                      "No Skills Found",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filteredSkills.length,
                                    separatorBuilder: (_, _) =>
                                        Divider(
                                          color: Colors.grey.shade200,
                                          height: 1,
                                        ),
                                    itemBuilder: (_, index) {

                                      final skill =
                                          filteredSkills[index];

                                      final selected =
                                          selectedSkills.contains(skill);

                                      return InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        onTap: () {

                                          if (selected) {
                                            removeSkill(skill);
                                          } else {
                                            addSkill(skill);
                                          }

                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 6,
                                          ),
                                          child: Row(
                                            children: [

                                              Expanded(
                                                child: Text(
                                                  skill.name,
                                                  style:
                                                      const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              AnimatedContainer(
                                                duration:
                                                    const Duration(
                                                        milliseconds:
                                                            200),
                                                height: 24,
                                                width: 24,
                                                decoration:
                                                    BoxDecoration(
                                                  color: selected
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              6),
                                                  border: Border.all(
                                                    color: selected
                                                        ? Colors.blue
                                                        : Colors.grey
                                                            .shade400,
                                                  ),
                                                ),
                                                child: selected
                                                    ? const Icon(
                                                        Icons.check,
                                                        color:
                                                            Colors.white,
                                                        size: 16,
                                                      )
                                                    : null,
                                              )

                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                                                  ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            saving ? null : saveSkills,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: saving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Save Skills",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}
}




class CandidateUpdateService1 {
  
  static Future<bool> update({
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await Dio().post(
        "${ApiConstants.baseUrl}/api/employee/updatecandidatedata",
        data: {
          "updatedFields": updatedFields,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    }
  }
}