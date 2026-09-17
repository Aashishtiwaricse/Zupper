import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/Steps/education_step.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/Steps/experience_step.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/Steps/personal_step.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/Steps/project_step.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/Steps/skill_step.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/%20step_indicator.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/bottom_button.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/resume_header.dart';



class ResumeBuilderScreen extends GetView<ResumeController> {
  const ResumeBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth >= 1100;
            final bool isTablet =
                constraints.maxWidth >= 700 &&
                constraints.maxWidth < 1100;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop
                      ? 1100
                      : isTablet
                          ? 850
                          : double.infinity,
                ),
                child: Column(
                  children: [
                    /// Header
                    const ResumeHeader(),

                    SizedBox(height: 10,),

                    /// Stepper
                    Obx(
                      () => StepIndicator(
                        currentStep: controller.currentStep.value,
                      ),
                    ),

                    /// Body
                    Expanded(
                      child: Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _stepWidget(
                            controller.currentStep.value,
                          ),
                        ),
                      ),
                    ),

                    /// Bottom Buttons
                    const BottomButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _stepWidget(int step) {
    switch (step) {
      case 0:
        return  PersonalStep();

      case 1:
        return const ExperienceStep();

      case 2:
        return const EducationStep();

      case 3:
        return const SkillStep();

      case 4:
        return const ProjectStep();

      default:
        return const SizedBox();
    }
  }
}