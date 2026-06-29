import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/dynamicFilter.dart';
import 'package:zuperr/Screens/HomeScreen/filteredJobsScreen.dart';
import 'package:zuperr/Services/Filter/filterService.dart';

class FilterDrawer {
  static void show(
    BuildContext context,
    List<dynamic> recommendedJobs,
    Function(List<dynamic>) onApply,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) =>
          _FilterPanel(recommendedJobs: recommendedJobs, onApply: onApply),
      transitionBuilder: (_, animation, __, child) {
        final offset = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return SlideTransition(position: offset, child: child);
      },
    );
  }
}

class _FilterPanel extends StatefulWidget {
  final List<dynamic> recommendedJobs;
  final Function(List<dynamic>) onApply;

  const _FilterPanel({
    super.key,
    required this.recommendedJobs,
    required this.onApply,
  });

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  bool workingExpanded = false;
  Map<String, dynamic>? filterData;
  bool isLoading = true;
  Set<String> selectedLocations = {};
  Set<String> selectedWorkModes = {};
  Set<String> selectedJobTypes = {};
  Set<String> selectedExperienceLevels = {};

  @override
  void initState() {
    super.initState();
    loadFilters();
  }

  Future<void> loadFilters() async {
    final data = await FilterService.getFilters();

    setState(() {
      filterData = data["filters"];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * .84,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xffFAFAFA),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(38),
              bottomLeft: Radius.circular(38),
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 26),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "All Filters",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.close, size: 34),
                              ),
                            ],
                          ),

                          const SizedBox(height: 38),
                          if (isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else
                            ...filterData!.entries.map((entry) {
                              final title = entry.key;
                              final values = List<String>.from(entry.value);

                              return DynamicFilterSection(
                                title: title,
                                values: values,
                                onChanged: (selected) {
                                  setState(() {
                                    switch (title) {
                                      case "Cities":
                                        selectedLocations = selected;
                                        break;

                                      case "Work Mode":
                                        selectedWorkModes = selected;
                                        break;

                                      case "Working Schedule":
                                        selectedJobTypes = selected;
                                        break;

                                      case "Experience Level":
                                        selectedExperienceLevels = selected;
                                        break;
                                    }
                                  });
                                },
                              );
                            }).toList(),

                          const SizedBox(height: 30),

                          GestureDetector(
                            onTap: () {
                              // TODO: Apply filters

                              List<dynamic> filtered = widget.recommendedJobs
                                  .where((job) {
                                    final cityMatch =
                                        selectedLocations.isEmpty ||
                                        selectedLocations.contains(
                                          job["location"]?.toString(),
                                        );

                                    final workModeMatch =
                                        selectedWorkModes.isEmpty ||
                                        selectedWorkModes.contains(
                                          job["workMode"]?.toString(),
                                        );

                                    final scheduleMatch =
                                        selectedJobTypes.isEmpty ||
                                        selectedJobTypes.contains(
                                          job["workingSchedule"]?.toString(),
                                        );

                                    final experienceMatch =
                                        selectedExperienceLevels.isEmpty ||
                                        selectedExperienceLevels.contains(
                                          job["experienceLevel"]?.toString(),
                                        );

                                    return cityMatch &&
                                        workModeMatch &&
                                        scheduleMatch &&
                                        experienceMatch;
                                  })
                                  .toList();

                              Navigator.pop(context); // Close the filter drawer

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FilteredJobsScreen(jobs: filtered),
                                ),
                              );
                            },
                            child: _button(
                              "Apply Filters",
                              const Color(0xff2C7BEF),
                              Colors.white,
                            ),
                          ),

                          const SizedBox(height: 18),

                          GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: _button(
                              "Clear All",
                              const Color(0xffE8EEF7),
                              const Color(0xff1954A6),
                            ),
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  static Widget _checkbox(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff59606D)),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 17, color: Color(0xff343A46)),
          ),
        ],
      ),
    );
  }

  static Widget _accordion(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 30),
        ],
      ),
    );
  }

  static Widget _button(String text, Color bg, Color txt) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: txt,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
