import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/Form/custom_checkbox.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/Form/responsive_form.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/common/add_more_button.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/common/form_section_card.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/common/section_header.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/custom_datepicker.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/custom_dropdown.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/custom_textfield.dart';

class EducationStep extends GetView<ResumeController> {
  const EducationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.educationFormKey,
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ...List.generate(
              controller.educationControllers.length,
              (index) => _EducationCard(index: index),
            ),

            const SizedBox(height: 20),

            AddMoreButton(
              title: "Add Another Education",
              onPressed: controller.addEducation,
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends GetView<ResumeController> {
  final int index;

  const _EducationCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final item = controller.educationControllers[index];

    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "Education ${index + 1}",
            onDelete: controller.educationControllers.length == 1
                ? null
                : () => controller.removeEducation(index),
          ),

          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              text: 'Add Education',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFF1877F2)),
                ),
              ],
            ),
          ),

          ResponsiveForm(
            children: [
              CustomDropdown<String>(
                hintText: "Select education",
                value: item.education.value,
                items: const ["10th", "12th", "Bachelor", "Master"],
                itemLabel: (e) => e,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select education";
                  }
                  return null;
                },
                onChanged: (v) {
                  item.education.value = v!;
                },
              ),
              RichText(
                text: const TextSpan(
                  text: 'Course Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFF1877F2)),
                    ),
                  ],
                ),
              ),

              TextFormField(
                initialValue: item.course.value,
                decoration: InputDecoration(
                  hintText: "Enter course name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Course name is required";
                  }

                  if (value.trim().length < 2) {
                    return "Enter valid course";
                  }

                  return null;
                },
                onChanged: (value) {
                  item.course.value = value;
                },
              ),

              RichText(
                text: const TextSpan(
                  text: 'Specialization',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFF1877F2)),
                    ),
                  ],
                ),
              ),

              TextFormField(
                initialValue: item.specialization.value,
                decoration: InputDecoration(
                  // labelText: "Specialization",
                  hintText: "Enter specialization",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter specialization";
                  }
                  if (value.trim().length < 2) {
                    return "Specialization must be at least 2 characters";
                  }
                  return null;
                },
                onChanged: (value) {
                  item.specialization.value = value;
                },
              ),

              Obx(
                () => Row(
                  children: [
                    Radio<String>(
                      value: "Percentage",
                      groupValue: item.marksType.value,
                      onChanged: (v) {
                        item.marksType.value = v!;
                      },
                    ),

                    Text("Percentage", style: TextStyle(fontSize: 18)),

                    SizedBox(width: 25),

                    Radio<String>(
                      value: "CGPA/GPA",
                      groupValue: item.marksType.value,
                      onChanged: (v) {
                        item.marksType.value = v!;
                      },
                    ),

                    Text("CGPA/GPA", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: item.acquiredMarks,
                      label: "Acquired",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Required";
                        }

                        final mark = double.tryParse(value);

                        if (mark == null) {
                          return "Invalid";
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: CustomTextField(
                      controller: item.totalMarks,
                      label: "Out Of",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Required";
                        }

                        final total = double.tryParse(value);

                        if (total == null) {
                          return "Invalid";
                        }

                        final obtained = double.tryParse(
                          item.acquiredMarks.text,
                        );

                        if (obtained != null && obtained > total) {
                          return "Must be ≥ acquired";
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

              CustomTextField(
                controller: item.field,
                label: "Field of Study",
                hint: "Computer Science",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Field of study is required";
                  }
                  return null;
                },
              ),

              CustomTextField(
                controller: item.grade,
                label: "Grade / CGPA",
                hint: "8.5",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required";
                  }

                  final grade = double.tryParse(value);

                  if (grade == null) {
                    return "Invalid";
                  }

                  return null;
                },
              ),
              CustomTextField(
                controller: item.institute,
                label: "Institute",
                isRequired: false,
                hint: "University Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Institute is required";
                  }

                  if (value.trim().length < 3) {
                    return "Invalid institute";
                  }

                  return null;
                },
              ),
              RichText(
                text: const TextSpan(
                  text: 'Course Duration',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFF1877F2)),
                    ),
                  ],
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      controller: item.startDate,

                      /// label: "Start Date",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select start date";
                        }

                        if (!item.currentlyStudying.value &&
                            item.endDate.text.isNotEmpty) {
                          final formatter = DateFormat("dd/MM/yyyy");

                          final start = formatter.parse(value);
                          final end = formatter.parse(item.endDate.text);

                          if (start.isAfter(end)) {
                            return "Start date cannot be after end date";
                          }
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Obx(
                      () => item.currentlyStudying.value
                          ? const SizedBox()
                          : CustomDatePicker(
                              controller: item.endDate,
                              //  label: "End Date",
                              validator: (value) {
                                if (!item.currentlyStudying.value &&
                                    (value == null || value.trim().isEmpty)) {
                                  return "Please select end date";
                                }

                                if (!item.currentlyStudying.value &&
                                    item.startDate.text.isNotEmpty &&
                                    value != null &&
                                    value.isNotEmpty) {
                                  final formatter = DateFormat("dd/MM/yyyy");

                                  final start = formatter.parse(
                                    item.startDate.text,
                                  );
                                  final end = formatter.parse(value);

                                  if (end.isBefore(start)) {
                                    return "End date cannot be before start date";
                                  }
                                }

                                return null;
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Obx(
            () => CustomCheckbox(
              title: "Currently Studying",
              value: item.currentlyStudying.value,
              onChanged: (value) {
                item.currentlyStudying.value = value ?? false;

                if (item.currentlyStudying.value) {
                  item.endDate.clear();
                }
              },
            ),
          ),
          Obx(
            () => Wrap(
              spacing: 12,
              runSpacing: 12,

              children: [
                CourseButton(
                  title: "Full Time",
                  selected: item.courseType.value == "Full Time",
                  onTap: () {
                    item.courseType.value = "Full Time";
                  },
                ),

                CourseButton(
                  title: "Part Time",
                  selected: item.courseType.value == "Part Time",
                  onTap: () {
                    item.courseType.value = "Part Time";
                  },
                ),

                CourseButton(
                  title: "Distance Learning",
                  selected: item.courseType.value == "Distance Learning",
                  onTap: () {
                    item.courseType.value = "Distance Learning";
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CourseButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        width: title == "Distance Learning" ? 290 : 140,
        height: 60,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: selected ? Colors.blue : const Color(0xffD9DCE3),
            width: selected ? 1.5 : 1,
          ),
        ),

        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.blue : const Color(0xff424756),
          ),
        ),
      ),
    );
  }
}
