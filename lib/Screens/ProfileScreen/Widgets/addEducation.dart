import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuperr/Services/PofileUpdate/profile_update.dart';

class AddEducationDialog extends StatefulWidget {
  final Map<String, dynamic>? educationData;
  final int? index;
  final List<dynamic> educationList;

  const AddEducationDialog({
    super.key,
    this.educationData,
    this.index,
    required this.educationList,
  });

  @override
  State<AddEducationDialog> createState() => _AddEducationDialogState();
}

class _AddEducationDialogState extends State<AddEducationDialog> {
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController acquiredController = TextEditingController();

  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  bool isLoading = false;

  bool isCgpa = true;

  String? education;
  String? course;
  String? specialization;
  String? totalValue;

  String courseType = "Full Time";

  final List<String> educations = [
    "Graduation",
    "Post Graduation",
    "Diploma",
    "PhD",
  ];

  final List<String> courses = [
    "B.Tech",
    "B.Sc",
    "BCA",
    "B.Com",
    "BA",
    "M.Tech",
    "MBA",
    "MCA",
    "M.Sc",
  ];

  final List<String> specializations = [
    "Computer Science",
    "Information Technology",
    "Mechanical",
    "Civil",
    "Electronics",
    "Electrical",
    "Finance",
    "Marketing",
    "Human Resources",
  ];
  @override
  void initState() {
    super.initState();

    if (widget.educationData != null) {
      final e = widget.educationData!;
      education =
          educations.any(
            (item) =>
                item.toLowerCase() ==
                e['educationLevel'].toString().toLowerCase(),
          )
          ? educations.firstWhere(
              (item) =>
                  item.toLowerCase() ==
                  e['educationLevel'].toString().toLowerCase(),
            )
          : null;
      course =
          courses.any(
            (item) =>
                item.toLowerCase() == e['courseName'].toString().toLowerCase(),
          )
          ? courses.firstWhere(
              (item) =>
                  item.toLowerCase() ==
                  e['courseName'].toString().toLowerCase(),
            )
          : null;
      specialization =
          specializations.any(
            (item) =>
                item.toLowerCase() ==
                e['specialization'].toString().toLowerCase(),
          )
          ? specializations.firstWhere(
              (item) =>
                  item.toLowerCase() ==
                  e['specialization'].toString().toLowerCase(),
            )
          : null;
      instituteController.text = e['instituteName'] ?? "";

      acquiredController.text = e['gradeValue'].toString();

      final grade = e['gradeOutOf']?.toString();

      totalValue = (isCgpa ? ["4", "5", "10"] : ["100"]).contains(grade)
          ? grade
          : null;

      isCgpa = e['grading'] == "CGPA";

      startController.text = e['courseStartDate'] ?? "";

      endController.text = e['courseEndDate'] ?? "";

      courseType = e['courseType'] ?? "Full Time";
    }
  }

  @override
  void dispose() {
    instituteController.dispose();
    acquiredController.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff4D8DFF)),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const Text(
            "*",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget typeChip(String title) {
    bool selected = courseType == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            courseType = title;
          });
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? const Color(0xffEEF5FF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? const Color(0xff4D8DFF) : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? const Color(0xff4D8DFF) : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveEducation() async {
    if (education == null ||
        course == null ||
        specialization == null ||
        instituteController.text.isEmpty ||
        acquiredController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    final educationData = {
      "educationLevel": education,
      "courseName": course,
      "specialization": specialization,
      "grading": isCgpa ? "CGPA" : "Percentage",

      "gradeValue": double.tryParse(acquiredController.text) ?? 0,

      "gradeOutOf": int.tryParse(totalValue ?? "10") ?? 10,

      "instituteName": instituteController.text.trim(),

      "courseStartDate": startController.text,

      "courseEndDate": endController.text,

      "courseType": courseType,
    };

    List<Map<String, dynamic>> updatedList = List<Map<String, dynamic>>.from(
      widget.educationList,
    );

    if (widget.index != null) {
      // EDIT
      updatedList[widget.index!] = educationData;
    } else {
      // ADD
      updatedList.add(educationData);
    }

    final success = await ProfileUpdateService().updateSingleField(
      fieldName: "educationAfter12th",
      value: updatedList,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update education")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Education",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),

              const SizedBox(height: 10),

              Text(
                "Highlighting your academic qualifications, degrees and certifications to boost your chances of finding the right opportunity.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.5),
              ),

              const SizedBox(height: 30),

              sectionTitle("Add Education"),

              DropdownButtonFormField<String>(
                initialValue: educations.contains(education) ? education : null,
                decoration: inputDecoration("Select education"),
                items: educations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() => education = v);
                },
              ),

              const SizedBox(height: 20),

              sectionTitle("Course Name"),

              DropdownButtonFormField<String>(
                initialValue: courses.contains(course) ? course : null,
                decoration: inputDecoration("Select your course name"),
                items: courses
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() => course = v);
                },
              ),

              const SizedBox(height: 20),

              sectionTitle("Specialization"),

              DropdownButtonFormField<String>(
                initialValue: specializations.contains(specialization)
                    ? specialization
                    : null,
                decoration: inputDecoration("Select your specialization"),
                items: specializations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() => specialization = v);
                },
              ),

              const SizedBox(height: 20),
              const SizedBox(height: 24),

              sectionTitle("Percentage / CGPA"),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "(CGPA out of 10, GPA out of 4, Percentage out of 100)",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: isCgpa,
                    activeColor: const Color(0xff4D8DFF),
                    onChanged: (v) {
                      setState(() {
                        isCgpa = false;
                        totalValue = "100";
                      });
                    },
                  ),
                  const Text("Percentage", style: TextStyle(fontSize: 16)),

                  const SizedBox(width: 20),

                  Radio<bool>(
                    value: true,
                    groupValue: isCgpa,
                    activeColor: const Color(0xff4D8DFF),
                    onChanged: (v) {
                      setState(() {
                        isCgpa = true;
                        totalValue = "10";
                      });
                    },
                  ),
                  const Text("CGPA / GPA", style: TextStyle(fontSize: 16)),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: acquiredController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: inputDecoration("Acquired"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Out Of",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: totalValue,
                      decoration: inputDecoration("Total"),
                      items: (isCgpa ? ["4", "5", "10"] : ["100"])
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          totalValue = v;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              sectionTitle("Institute / University Name"),

              TextFormField(
                controller: instituteController,
                decoration: inputDecoration(
                  "Enter your Institute / University Name",
                ),
              ),

              const SizedBox(height: 24),

              sectionTitle("Course Duration"),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: startController,
                      readOnly: true,
                      decoration: inputDecoration(
                        "MM/YYYY",
                      ).copyWith(suffixIcon: const Icon(Icons.calendar_month)),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime(2100),
                        );

                        if (date != null) {
                          startController.text =
                              "${date.month.toString().padLeft(2, '0')}/${date.year}";
                        }
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      "To",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      controller: endController,
                      readOnly: true,
                      decoration: inputDecoration(
                        "MM/YYYY",
                      ).copyWith(suffixIcon: const Icon(Icons.calendar_month)),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime(2100),
                        );

                        if (date != null) {
                          endController.text =
                              "${date.month.toString().padLeft(2, '0')}/${date.year}";
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              sectionTitle("Course Type"),

              Row(
                children: [
                  typeChip("Full Time"),
                  const SizedBox(width: 10),
                  typeChip("Part Time"),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: typeChip("Distance Learning")),
                  const Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6EA8FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : saveEducation,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
