import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuperr/Services/PofileUpdate/profile_update.dart';

class AddSchoolEducationDialog extends StatefulWidget {
  final Map<String, dynamic>? educationData;
  final int? index;
  final List<dynamic> educationList;

  const AddSchoolEducationDialog({
    super.key,
    this.educationData,
    this.index,
    required this.educationList,
  });

  @override
  State<AddSchoolEducationDialog> createState() =>
      _AddSchoolEducationDialogState();
}

class _AddSchoolEducationDialogState
    extends State<AddSchoolEducationDialog> {
  final TextEditingController acquiredController =
      TextEditingController();

  bool isLoading = false;

  bool isCgpa = false;

  String? educationType;
  String? board;
  String? totalValue;
  String? year;

  final List<String> educationTypes = [
    "10th Board",
    "12th Board",
  ];

  final List<String> boards = [
    "CBSE",
    "ICSE",
    "BSEB",
    "UP Board",
    "Jharkhand Board",
    "State Board",
    "NIOS",
    "Other",
  ];

  @override
  void initState() {
    super.initState();


    

    if (widget.educationData != null) {
      final e = widget.educationData!;

      educationType =
    e["education"] == "10th"
        ? "10th Board"
        : "12th Board";

board = e["examinationBoard"];

year = e["passingYear"];

acquiredController.text =
    e["gradeValue"]?.toString() ?? "";

isCgpa = e["gradeType"] == "CGPA";

totalValue =
    e["gradingOutOf"]?.toString() ??
    (isCgpa ? "10" : "100");
    } else {
      totalValue = "100";
    }
  }

  @override
  void dispose() {
    acquiredController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xff4D8DFF),
        ),
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const Text(
            " *",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

Future<void> saveSchoolEducation() async {
  if (educationType == null ||
      board == null ||
      acquiredController.text.isEmpty ||
      year == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all required fields"),
      ),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  final schoolEducation = {
    "education": educationType == "10th Board" ? "10th" : "12th",
    "examinationBoard": board,
    "gradeType": isCgpa ? "CGPA" : "Percentage",
    "gradingOutOf": totalValue ?? (isCgpa ? "10" : "100"),
    "gradeValue": acquiredController.text.trim(),
    "passingYear": year,
  };

  List<Map<String, dynamic>> updatedList =
      List<Map<String, dynamic>>.from(widget.educationList);

  if (widget.index != null) {
    updatedList[widget.index!] = schoolEducation;
  } else {
    updatedList.add(schoolEducation);
  }

 final success = await ProfileUpdateService().updateSingleField(
  fieldName: "educationTill12th",
  value: updatedList,
);

setState(() {
  isLoading = false;
});

if (!mounted) return;

if (success) {
  Navigator.pop(context, true);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Profile updated successfully."),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Failed to update profile. Please try again."),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding:
          const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints:
            const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Education",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Highlighting your academic qualifications to boost your chances of finding the right opportunity.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              sectionTitle("Add Education"),

              DropdownButtonFormField<String>(
                value: educationType,
                decoration:
                    inputDecoration(
                        "Select Education"),
                items: educationTypes
                    .map(
                      (e) =>
                          DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    educationType = v;
                  });
                },
              ),

              const SizedBox(height: 24),

              sectionTitle(
                  "Examination Board"),

              DropdownButtonFormField<String>(
                value: board,
                decoration:
                    inputDecoration(
                        "Select examination board"),
                items: boards
                    .map(
                      (e) =>
                          DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    board = v;
                  });
                },
              ),

              const SizedBox(height: 24),

              sectionTitle("Percentage / CGPA"),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  "(CGPA out of 10, GPA out of 4, Percentage out of 100)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Radio<bool>(
                    value: false,
                    groupValue: isCgpa,
                    activeColor:
                        const Color(
                            0xff4D8DFF),
                    onChanged: (v) {
                      setState(() {
                        isCgpa = false;
                        totalValue = "100";
                      });
                    },
                  ),

                  const Text("Percentage"),

                  const SizedBox(width: 20),

                  Radio<bool>(
                    value: true,
                    groupValue: isCgpa,
                    activeColor:
                        const Color(
                            0xff4D8DFF),
                    onChanged: (v) {
                      setState(() {
                        isCgpa = true;
                        totalValue = "10";
                      });
                    },
                  ),

                  const Text("CGPA / GPA"),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [

                  Expanded(
                    child: TextFormField(
                      controller:
                          acquiredController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                              r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration:
                          inputDecoration(
                              "Acquired"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Out Of",
                    style: TextStyle(
                        fontWeight:
                            FontWeight.w600),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                        DropdownButtonFormField<
                            String>(
                      value: totalValue,
                      decoration:
                          inputDecoration(
                              "Total"),
                      items: (isCgpa
                              ? [
                                  "4",
                                  "5",
                                  "10"
                                ]
                              : [
                                  "100"
                                ])
                          .map(
                            (e) =>
                                DropdownMenuItem(
                              value: e,
                              child:
                                  Text(e),
                            ),
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

              sectionTitle(
                  "Year of Passing"),

              DropdownButtonFormField<String>(
                value: year,
                decoration:
                    inputDecoration(
                        "Select year"),
                items: List.generate(
                  50,
                  (index) =>
                      (DateTime.now()
                                  .year -
                              index)
                          .toString(),
                )
                    .map(
                      (e) =>
                          DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    year = v;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                            0xff6EA8FF),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : saveSchoolEducation,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color:
                              Colors.white,
                        )
                      : const Text(
                          "Save",
                          style:
                              TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .w600,
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