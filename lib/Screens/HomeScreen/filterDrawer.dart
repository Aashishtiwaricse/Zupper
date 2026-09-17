import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/dynamicFilter.dart';
import 'package:zuperr/Services/Filter/filterService.dart';

class FilterDrawer {
  static Map<String, Set<String>> selectedFilters = {};

  static void show(
    BuildContext context,
    Function(Map<String, Set<String>>) onApply,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => _FilterPanel(
        onApply: onApply,
      ),
      transitionBuilder: (_, animation, __, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        );

        return SlideTransition(
          position: offset,
          child: child,
        );
      },
    );
  }

  static void clearAllFilters() {
    selectedFilters.clear();
  }
}

class _FilterPanel extends StatefulWidget {
  final Function(Map<String, Set<String>>) onApply;

  const _FilterPanel({
    required this.onApply,
  });

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  Map<String, dynamic>? filterData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFilters();
  }

  Future<void> loadFilters() async {
    try {
      final data = await FilterService.getFilters();

      if (!mounted) return;

      setState(() {
        filterData = data["filters"];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Filter loading error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 26),

                          Row(
                            children: [
                              const Text(
                                "All Filters",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const Spacer(),

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    FilterDrawer.clearAllFilters();
                                  });
                                },
                                icon: const Icon(
                                  Icons.restart_alt,
                                  size: 28,
                                  color: Color(0xff1954A6),
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 38),

                          if (isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (filterData == null ||
                              filterData!.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Text(
                                  "No filters available",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          else
                            ...filterData!.entries.map((entry) {
                              final title = entry.key;

                              final values = List<String>.from(
                                entry.value,
                              );

                              return DynamicFilterSection(
                                title: title,
                                values: values,
                                selectedValues:
                                    FilterDrawer.selectedFilters[title] ??
                                        <String>{},
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected.isEmpty) {
                                      FilterDrawer.selectedFilters
                                          .remove(title);
                                    } else {
                                      FilterDrawer.selectedFilters[title] =
                                          Set<String>.from(selected);
                                    }
                                  });
                                },
                              );
                            }),

                          const SizedBox(height: 30),

                          GestureDetector(
                            onTap: () {
                              final Map<String, Set<String>> selected = {
                                for (final entry
                                    in FilterDrawer.selectedFilters.entries)
                                  entry.key:
                                      Set<String>.from(entry.value),
                              };

                              debugPrint(
                                "================================",
                              );
                              debugPrint("SELECTED FILTERS:");
                              debugPrint(selected.toString());
                              debugPrint(
                                "================================",
                              );

                              Navigator.pop(context);

                              // SEND SELECTED FILTERS TO SCREEN
                              widget.onApply(selected);
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
                              FilterDrawer.clearAllFilters();

                              setState(() {});

                              Navigator.pop(context);

                              widget.onApply({});
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

  Widget _button(
    String text,
    Color bg,
    Color txt,
  ) {
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