import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';


class BottomButton extends GetView<ResumeController> {
  const BottomButton({super.key});

  @override
@override
Widget build(BuildContext context) {
  return SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Row(
          children: [
            if (controller.currentStep.value != 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  child: const Text("Back"),
                ),
              ),

            if (controller.currentStep.value != 0)
              const SizedBox(width: 16),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.currentStep.value == 4) {
                    controller.completeResume();
                  } else {
                    controller.nextStep();
                  }
                },
                child: Text(
                  controller.currentStep.value == 4
                      ? "Complete"
                      : "Next",
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