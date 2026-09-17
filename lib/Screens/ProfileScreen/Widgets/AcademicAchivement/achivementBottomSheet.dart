import 'package:flutter/material.dart';

class AcademicAchievementBottomSheet extends StatefulWidget {
  const AcademicAchievementBottomSheet({
    super.key,
    required this.initialData,
    required this.onSave,
    this.loading = false,
  });

  final Map<String, dynamic> initialData;
  final Future<void> Function(Map<String, dynamic>) onSave;
  final bool loading;

  @override
  State<AcademicAchievementBottomSheet> createState() =>
      _AcademicAchievementBottomSheetState();
}

class _AcademicAchievementBottomSheetState
    extends State<AcademicAchievementBottomSheet> {
  final educationReferenceController = TextEditingController();

  final List<String> achievementOptions = [
    "College topper",
    "Department topper",
    "Top 3 in class",
    "Top 10 in class",
    "Gold medalist",
    "Received scholarship",
    "All rounder",
    "Other",
  ];

  List<String> selectedAchievements = [];

  String? selectedReceivedDuring;

  @override
  void initState() {
    super.initState();

    educationReferenceController.text =
        widget.initialData["educationReference"] ?? "";

    if (widget.initialData["achievement"] != null) {
      selectedAchievements = [
        widget.initialData["achievement"],
      ];
    }

    selectedReceivedDuring =
        widget.initialData["receivedDuring"];
  }

  @override
  void dispose() {
    educationReferenceController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xffE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xff4F8EF7),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Academic Achievements",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                "Academic Achievements are highlighting your educational milestones, honors, and recognitions that reflect your dedication and excellence in learning.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Education Reference (Optional)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller:
                            educationReferenceController,
                        decoration: decoration(
                          "Enter education reference",
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        "Academic Achievements",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedAchievements
                            .map(
                              (e) => Chip(
                                backgroundColor:
                                    const Color(0xffE8F1FF),
                                label: Text(
                                  e,
                                  style: const TextStyle(
                                    color: Color(0xff1654B7),
                                  ),
                                ),
                                deleteIcon: const Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    selectedAchievements
                                        .remove(e);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        "Received during B.Tech/B.E.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: achievementOptions
                            .map(
                              (item) => ChoiceChip(
                                label: Text(item),
                                selected:
                                    selectedReceivedDuring ==
                                        item,
                                onSelected: (_) {
                                  setState(() {
                                    selectedReceivedDuring =
                                        item;

                                    if (!selectedAchievements
                                        .contains(item)) {
                                      selectedAchievements
                                          .add(item);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff73A8F8),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: widget.loading
                      ? null
                      : () async {
                          await widget.onSave({
                            "achievement":
                                selectedAchievements.isEmpty
                                    ? ""
                                    : selectedAchievements
                                        .first,
                            "receivedDuring":
                                selectedReceivedDuring,
                            "educationReference":
                                educationReferenceController
                                    .text
                                    .trim(),
                            "topRank": "",
                          });

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                  child: widget.loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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