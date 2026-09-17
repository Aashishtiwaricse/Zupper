import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';

import 'custom_datepicker.dart';
import 'custom_textfield.dart';

import 'custom_dropdown.dart';

class ExperienceCard extends GetView<ResumeController> {
  final int index;

  const ExperienceCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final item = controller.experienceControllers[index];

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.experienceControllers.length > 1)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.removeExperience(index);
                  },
                ),
              ),

            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                text: 'Total Work Experience',
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
            const SizedBox(height: 4),

            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    // label: "Months",
                    hintText: "Months",
                    value: item.months.value.isEmpty ? null : item.months.value,
                    items: List.generate(12, (i) => "${i + 1}"),
                    itemLabel: (e) => e,
                   validator: (value) {
  final months = int.tryParse(value ?? "0") ?? 0;
  final years = int.tryParse(item.years.value.isEmpty ? "0" : item.years.value) ?? 0;

  if (value == null || value.isEmpty) {
    return "Please select months";
  }

  if (years == 0 && months == 0) {
    return "Experience cannot be 0";
  }

  return null;
},
                    onChanged: (v) {
                      item.months.value = v ?? "";
                    },
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: CustomDropdown<String>(
                    //   label: "Years",
                    hintText: "Years",

                    value: item.years.value.isEmpty ? null : item.years.value,
                    items: List.generate(40, (i) => "$i"),
                    itemLabel: (e) => e,
                    validator: (value) {
  final years = int.tryParse(value ?? "0") ?? 0;
  final months = int.tryParse(item.months.value.isEmpty ? "0" : item.months.value) ?? 0;

  if (value == null || value.isEmpty) {
    return "Please select years";
  }

  if (years == 0 && months == 0) {
    return "Experience cannot be 0";
  }

  return null;
},
                    onChanged: (v) {
                      item.years.value = v ?? "";
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: item.company,
              label: "Company Name",
              isRequired: true,

              hint: "Google",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Company name is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: item.designation,
              label: "Job Title / Position",
              isRequired: true,

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Job title is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                text: 'Duration of Employement',
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
              children: [
                Expanded(
                  child: CustomDatePicker(
                    controller: item.fromDate,
                    // label: "From",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Select start date";
                      }

                      if (!item.currentlyWorking.value &&
                          item.toDate.text.isNotEmpty) {
                        final formatter = DateFormat("dd/MM/yyyy");

                        final from = formatter.parse(value);
                        final to = formatter.parse(item.toDate.text);

                        if (from.isAfter(to)) {
                          return "Wrong Start date";
                        }
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 5),
                Text('To'),
                const SizedBox(width: 5),

                Expanded(
                  child: Obx(() {
                    return item.currentlyWorking.value
                        ? const SizedBox()
                        : CustomDatePicker(
                            controller: item.toDate,
                            //  label: "To",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Select start date";
                              }

                              if (!item.currentlyWorking.value &&
                                  item.toDate.text.isNotEmpty) {
                                final formatter = DateFormat("dd/MM/yyyy");

                                final from = formatter.parse(value);
                                final to = formatter.parse(item.toDate.text);

                                if (from.isAfter(to)) {
                                  return "Start date cannot be after end date";
                                }
                              }

                              return null;
                            },
                          );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Obx(() {
              return CheckboxListTile(
                value: item.currentlyWorking.value,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("I currently work here"),
                onChanged: (v) {
                  item.currentlyWorking.value = v ?? false;

                  if (item.currentlyWorking.value) {
                    item.toDate.clear();
                  }
                },
              );
            }),

            const SizedBox(height: 18),

            CustomTextField(
              isRequired: true,

              controller: item.achievements,
              label: "Key Achievements",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Key achievements is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            CustomTextField(
              isRequired: true,

              controller: item.annualSalary,
              label: "Annual Salary (₹)",
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Annual salary is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: item.description,
              label: "Role Description",
              isRequired: true,

              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Role description is required";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
