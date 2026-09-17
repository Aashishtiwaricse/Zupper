import 'package:flutter/material.dart';
import 'package:zuperr/Services/AccountUpdateService/updateUserData.dart';

class JobPreferenceBottomSheet extends StatefulWidget {
  const JobPreferenceBottomSheet({super.key});

  @override
  State<JobPreferenceBottomSheet> createState() =>
      _JobPreferenceBottomSheetState();
}

class _JobPreferenceBottomSheetState
    extends State<JobPreferenceBottomSheet> {
  int selectedJobType = 0;
  int selectedShift = 0;
  String selectedAvailability = "Immediate";
String selectedLocation = "";

RangeValues salary = const RangeValues(5, 15);

double locationKm = 25;

List<String> selectedJobTypes = [];
List<String> selectedRoles = [];
List<String> selectedStates = [];

  final List<String> jobTypes = [
    "Full Time",
    "Part Time",
    "Freelance",
  ];

  final List<String> shifts = [
    "Day",
    "Night",
    "Flexible",
  ];

  final List<String> salaries = [
        "₹0 LPA - ₹2 LPA",

    "₹2 LPA - ₹5 LPA",
    "₹5 LPA - ₹10 LPA",
    "₹10 LPA - ₹15 LPA",
    "₹15+ LPA",
  ];

  String selectedSalary = "Choose salary range";

  RangeValues values = const RangeValues(0, 50);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 70,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xff4B5563),
                borderRadius: BorderRadius.circular(30),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Job Preferences",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Set roles, locations, and expectations",
              style: TextStyle(
                color: Color(0xff6B7280),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    /// Job Type

                    const Text(
                      "Preferred Job Type",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(
                        jobTypes.length,
                        (i) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 8),
                            child: _choiceChip(
                              title: jobTypes[i],
                              selected:
                                  selectedJobType == i,
                              onTap: () {
                                setState(() {
                                  selectedJobType = i;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Shift

                    const Text(
                      "Preferred Shift",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(
                        shifts.length,
                        (i) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 8),
                            child: _choiceChip(
                              title: shifts[i],
                              selected:
                                  selectedShift == i,
                              onTap: () {
                                setState(() {
                                  selectedShift = i;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Salary

                    const Text(
                      "Salary Range",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffD1D5DB),
                        ),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSalary ==
                                  "Choose salary range"
                              ? null
                              : selectedSalary,
                          hint: const Padding(
                            padding:
                                EdgeInsets.only(left: 16),
                            child: Text(
                              "Choose salary range",
                            ),
                          ),
                          icon: const Padding(
                            padding:
                                EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                            ),
                          ),
                          isExpanded: true,
                          items: salaries
                              .map(
                                (e) =>
                                    DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(
                                            left: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedSalary = v!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Job Location Preference",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 20),

                    RangeSlider(
                      values: values,
                      min: 0,
                      max: 100,
                      activeColor:
                          const Color(0xff1877F2),
                      inactiveColor:
                          Colors.grey.shade300,
                      onChanged: (v) {
                        setState(() {
                          values = v;
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _bubble(
                              "${values.start.toInt()}km"),
                          _bubble(
                              "${values.end.toInt()}km"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff1877F2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () async {
      final List<String> jobTypes = [
        this.jobTypes[selectedJobType],
      ];

      final String preferredShift = shifts[selectedShift];

      int minSalary = salary.start.round();
      int maxSalary = salary.end.round();

      bool success =
          await UpdateJobPreferenceService.updateJobPreference(
        jobTypes: jobTypes,
        availability: selectedAvailability,
        preferredLocation: selectedLocation,
        minimumSalary: minSalary,
        maximumSalary: maxSalary,
        jobRoles: selectedRoles,
        preferredShift: preferredShift,
        locationPreferenceKM: locationKm.round(),
        preferredStates: selectedStates,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Job Preferences Updated"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update preferences"),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    child: const Text(
      "Save",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xff1877F2)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xff1877F2)
                : const Color(0xffD1D5DB),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : const Color(0xff4B5563),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bubble(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: .08),
          )
        ],
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}