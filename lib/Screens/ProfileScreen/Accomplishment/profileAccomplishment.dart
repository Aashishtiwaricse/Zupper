import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:zuperr/Controllers/AccomplishmentFormController/accomplishmentFormController.dart';
import 'package:zuperr/Screens/ProfileScreen/Accomplishment/accomplishment_stepper.dart';
import 'package:zuperr/Screens/ProfileScreen/Accomplishment/awards_step.dart';
import 'package:zuperr/Screens/ProfileScreen/Accomplishment/certification_step.dart';
import 'package:zuperr/Screens/ProfileScreen/Accomplishment/committee_step.dart';

import '../../../Services/PofileUpdate/profile_update.dart';

class AccomplishmentBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? accomplishment;
  final int? index;
  final List<dynamic> accomplishments;
  final VoidCallback onSaved;

  const AccomplishmentBottomSheet({
    super.key,
    this.accomplishment,
    this.index,
    required this.accomplishments,
    required this.onSaved,
  });

  @override
  State<AccomplishmentBottomSheet> createState() =>
      _AccomplishmentBottomSheetState();
}

class _AccomplishmentBottomSheetState
    extends State<AccomplishmentBottomSheet> {
  int currentStep = 0;

  final PageController pageController = PageController();

  final AccomplishmentFormController controller =
      AccomplishmentFormController();

  bool saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.accomplishment != null) {
      loadData();
    }
  }

  // ---------------------------------------------------------
  // LOAD EDIT DATA
  // ---------------------------------------------------------

  void loadData() {
    final item = widget.accomplishment!;

    controller.certificationName.text =
        item["certificationName"]?.toString() ?? "";

    controller.certificationId.text =
        item["certificationID"]?.toString() ?? "";

    controller.certificationUrl.text =
        item["certificationURL"]?.toString() ?? "";

    controller.validityMonth.text =
        item["certificationValidity"]?["month"]?.toString() ?? "";

    controller.validityYear.text =
        item["certificationValidity"]?["year"]?.toString() ?? "";

    controller.noExpiry =
        item["noExpiry"] ?? false;

    controller.awardDescription.text =
        item["awards"]?.toString() ?? "";

    controller.clubName.text =
        item["clubs"]?.toString() ?? "";

    controller.positionHeld.text =
        item["positionHeld"]?.toString() ?? "";

    controller.educationReference.text =
        item["educationalReference"]?.toString() ?? "";

    controller.responsibilities.text =
        item["responsibilities"]?.toString() ?? "";

    controller.uploadedFile =
        item["mediaUpload"]?.toString();

    final from =
        item["duration"]?["from"]?.toString();

    final to =
        item["duration"]?["to"]?.toString();

    controller.fromDate.text =
        from != null && from.length >= 10
            ? from.substring(0, 10)
            : "";

    controller.toDate.text =
        to != null && to.length >= 10
            ? to.substring(0, 10)
            : "";

    controller.currentlyHolding =
        item["isCurrent"] ?? false;
  }

  // ---------------------------------------------------------
  // NEXT
  // ---------------------------------------------------------

  void next() {
    final isValid = controller
        .formKeys[currentStep]
        .currentState
        ?.validate();

    if (isValid != true) {
      return;
    }

    if (currentStep < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        currentStep++;
      });
    }
  }

  // ---------------------------------------------------------
  // BACK
  // ---------------------------------------------------------

  void back() {
    if (currentStep == 0) {
      Navigator.pop(context);
      return;
    }

    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      currentStep--;
    });
  }

  // ---------------------------------------------------------
  // SAVE / UPDATE
  // ---------------------------------------------------------

  Future<void> save() async {
    final isValid = controller
        .formKeys[currentStep]
        .currentState
        ?.validate();

    if (isValid != true) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final List<dynamic> list =
          List<dynamic>.from(widget.accomplishments);

      final data = {
        "certificationName":
            controller.certificationName.text.trim(),

        "certificationID":
            controller.certificationId.text.trim(),

        "certificationURL":
            controller.certificationUrl.text.trim(),

        "awards":
            controller.awardDescription.text.trim(),

        "clubs":
            controller.clubName.text.trim(),

        "positionHeld":
            controller.positionHeld.text.trim(),

        "educationalReference":
            controller.educationReference.text.trim(),

        "responsibilities":
            controller.responsibilities.text.trim(),

        "mediaUpload":
            controller.uploadedFile ?? "",

        "noExpiry":
            controller.noExpiry,

        "isCurrent":
            controller.currentlyHolding,

        "certificationValidity": {
          "month": controller.validityMonth.text.trim(),
          "year": controller.validityYear.text.trim(),
        },

        "duration": {
          "from": controller.fromDate.text.isEmpty
              ? null
              : DateTime.parse(
                  controller.fromDate.text,
                ).toIso8601String(),

          "to": controller.currentlyHolding
              ? null
              : controller.toDate.text.isEmpty
                  ? null
                  : DateTime.parse(
                      controller.toDate.text,
                    ).toIso8601String(),
        },
      };

      if (widget.index == null) {
        list.add(data);
      } else {
        list[widget.index!] = data;
      }

      final success =
          await ProfileUpdateService().updateProfile(
        data: {
          "accomplishments": list,
        },
      );

      if (!mounted) return;

      setState(() {
        saving = false;
      });

      if (success) {
        widget.onSaved();

        Navigator.pop(context);

        Get.snackbar(
          "Success",
          widget.index == null
              ? "Accomplishment added successfully"
              : "Accomplishment updated successfully",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to save accomplishment",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        saving = false;
      });

      Get.snackbar(
        "Error",
        "Invalid date format or something went wrong",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ---------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------

  @override
  void dispose() {
    pageController.dispose();
    controller.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .93,

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      child: Column(
        children: [
          const SizedBox(height: 12),

          Container(
            width: 70,
            height: 6,

            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            "Accomplishments",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),

            child: Text(
              "Accomplishments highlight your achievements, showcasing how you're excelling in your field and adding value to your professional profile.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 30),

          AccomplishmentStepper(
            currentStep: currentStep,
          ),

          const SizedBox(height: 30),

          Expanded(
            child: PageView(
              controller: pageController,

              physics:
                  const NeverScrollableScrollPhysics(),

              children: [
                CertificationStep(
                  controller: controller,
                ),

                AwardsStep(
                  controller: controller,
                ),

                CommitteeStep(
                  controller: controller,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Row(
              children: [
                if (currentStep != 2)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: saving ? null : back,

                      child: Text(
                        currentStep == 0
                            ? "Cancel"
                            : "Back",
                      ),
                    ),
                  ),

                if (currentStep != 2)
                  const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: saving
                        ? null
                        : currentStep == 2
                            ? save
                            : next,

                    child: saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            currentStep == 2
                                ? widget.accomplishment ==
                                        null
                                    ? "Save"
                                    : "Update"
                                : "Next",
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}