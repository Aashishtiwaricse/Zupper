import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:zuperr/Controllers/Resume/educationForm_Controller.dart';
import 'package:zuperr/Controllers/Resume/experience_form_controller.dart';
import 'package:zuperr/Controllers/Resume/projectForm_Controller.dart';
import 'package:zuperr/Models/Resume/education_model.dart';
import 'package:zuperr/Models/Resume/experience_model.dart';
import 'package:zuperr/Models/Resume/project_model.dart';
import 'package:zuperr/Models/Resume/resume_model.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/resumePreviewScreen.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';

class ResumeController extends GetxController {
  /// -------------------------------------------------------
  /// STEP MANAGEMENT
  /// -------------------------------------------------------

  final RxInt currentStep = 0.obs;

  final RxString selectedTemplate = "Modern".obs;

  static const int totalSteps = 5;

  void nextStep() {
    if (!validateCurrentStep()) {
      return;
    }

    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int index) {
    currentStep.value = index;
  }

  /// -------------------------------------------------------
  /// FORM KEY
  /// -------------------------------------------------------

  final personalFormKey = GlobalKey<FormState>();

  final experienceFormKey = GlobalKey<FormState>();

  final educationFormKey = GlobalKey<FormState>();

  final skillFormKey = GlobalKey<FormState>();

  final projectFormKey = GlobalKey<FormState>();

  /// -------------------------------------------------------
  /// FORM CONTROLLERS
  /// -------------------------------------------------------

  final RxList<ExperienceFormController> experienceControllers =
      <ExperienceFormController>[].obs;

  final RxList<EducationFormController> educationControllers =
      <EducationFormController>[].obs;

  final RxList<ProjectFormController> projectControllers =
      <ProjectFormController>[].obs;

  /// -------------------------------------------------------
  /// PERSONAL INFORMATION
  /// -------------------------------------------------------

  final fullNameController = TextEditingController();

  final jobTitleController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final stateController = TextEditingController();

  final countryController = TextEditingController();

  final postalCodeController = TextEditingController();

  final linkedInController = TextEditingController();

  final portfolioController = TextEditingController();

  final summaryController = TextEditingController();

  /// -------------------------------------------------------
  /// SKILLS
  /// -------------------------------------------------------

  final skillController = TextEditingController();

  final RxList<String> skills = <String>[].obs;

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;

    if (!skills.contains(skill.trim())) {
      skills.add(skill.trim());
    }

    skillController.clear();
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  /// -------------------------------------------------------
  /// EXPERIENCE
  /// -------------------------------------------------------

  void addExperience() {
    experienceControllers.add(ExperienceFormController());
  }

  void removeExperience(int index) {
    if (experienceControllers.length == 1) return;

    experienceControllers[index].dispose();
    experienceControllers.removeAt(index);
  }

  /// -------------------------------------------------------
  /// EDUCATION
  /// -------------------------------------------------------

  final RxList<EducationModel> educations = <EducationModel>[].obs;

  void addEducation() {
    educationControllers.add(EducationFormController());
  }

  void removeEducation(int index) {
    educationControllers[index].dispose();
    educationControllers.removeAt(index);
  }

  /// -------------------------------------------------------
  /// PROJECTS
  /// -------------------------------------------------------

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;

  void addProject() {
    projectControllers.add(ProjectFormController());
  }

  void removeProject(int index) {
    projectControllers[index].dispose();
    projectControllers.removeAt(index);
  }

  /// -------------------------------------------------------
  /// SAVE MODEL
  /// -------------------------------------------------------

  ResumeModel buildResume() {
    return ResumeModel(
      fullName: fullNameController.text,
      jobTitle: jobTitleController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      postalCode: postalCodeController.text,
      linkedIn: linkedInController.text,
      portfolio: portfolioController.text,
      summary: summaryController.text,

      skills: skills.toList(),

     experiences: experienceControllers.map((e) {
  return ExperienceModel(
    company: e.company.text,
    designation: e.designation.text,
    location: e.location.text,
    startDate: e.fromDate.text,
    endDate: e.toDate.text,
    description: e.description.text,
    currentlyWorking: e.currentlyWorking.value,
  );
}).toList(),

      educations: educationControllers
          .map(
            (e) => EducationModel(
              institute: e.institute.text,
              degree: e.degree.value,
              field: e.field.text,
              grade: e.grade.text,
              startDate: e.startDate.text,
              endDate: e.endDate.text,
              currentlyStudying: e.currentlyStudying.value,
            ),
          )
          .toList(),

      projects: projectControllers
          .map(
            (e) => ProjectModel(
              projectName: e.projectName.text,
              role: e.role.text,
              technologies: e.technologies.text,
              github: e.github.text,
              liveUrl: e.liveUrl.text,
              description: e.description.text,
            ),
          )
          .toList(),
    );
  }

  /// -------------------------------------------------------
  /// VALIDATION
  /// -------------------------------------------------------

 bool validateCurrentStep() {
  switch (currentStep.value) {
    case 0:
      return personalFormKey.currentState?.validate() ?? false;

    case 1:
      return experienceFormKey.currentState?.validate() ?? false;

    case 2:
      return educationFormKey.currentState?.validate() ?? false;

    case 3:
      return skillFormKey.currentState?.validate() ?? false;

    case 4:
      return projectFormKey.currentState?.validate() ?? false;

    default:
      return false;
  }
}

  /// -------------------------------------------------------
  /// COMPLETE
  /// -------------------------------------------------------

  void completeResume() {
  if (!validateCurrentStep()) return;

  final resume = buildResume();

  Get.to(() => ResumePreviewScreen(resume: resume));
    debugPrint(resume.toString());

    // PDF generation will come later
  }




  //autofill

  Future<void> autofillFromProfile() async {
  final data = await CandidateService.getCandidateData();

  if (data == null) return;

  // Personal
  fullNameController.text =
      "${data["firstname"] ?? ""} ${data["lastname"] ?? ""}".trim();

  emailController.text = data["email"] ?? "";

  phoneController.text = data["mobilenumber"] ?? "";

  summaryController.text = data["profileSummary"] ?? "";

  jobTitleController.text = data["currentPosition"] ?? "";

  // Address
  addressController.text =
      data["address"]?["line1"] ?? "";

  cityController.text =
      data["address"]?["district"] ?? "";

  stateController.text =
      data["address"]?["state"] ?? "";

  countryController.text =
      data["address"]?["country"] ?? "";

  postalCodeController.text =
      data["address"]?["pincode"] ?? "";

  // Skills
  skills.clear();
if (data["keySkills"] != null) {
  for (final item in data["keySkills"]) {
    if (item is Map) {
      final skillName =
          item["Name"]?.toString() ??
          item["name"]?.toString() ??
          "";

      if (skillName.isNotEmpty) {
        skills.add(skillName);
      }
    } else {
      final skillName = item.toString();

      if (skillName.isNotEmpty) {
        skills.add(skillName);
      }
    }
  }
}

  //--------------------------------------------------
  // Experience
  //--------------------------------------------------

  experienceControllers.clear();
final experiences = data["employmentHistory"] ?? [];

if (experiences.isEmpty) {
  addExperience();
} else {
  experienceControllers.clear();

  for (final exp in experiences) {
    if (exp is! Map) continue;

    final controller = ExperienceFormController();

    controller.company.text =
        exp["company"]?.toString() ?? "";

    controller.designation.text =
        exp["designation"]?.toString() ?? "";

    controller.location.text =
        exp["location"]?.toString() ?? "";

    controller.fromDate.text =
        exp["startDate"]?.toString() ?? "";

    controller.toDate.text =
        exp["endDate"]?.toString() ?? "";

    controller.description.text =
        exp["description"]?.toString() ?? "";

    controller.currentlyWorking.value =
        exp["currentlyWorking"] == true;

    experienceControllers.add(controller);
  }
}

  //--------------------------------------------------
  // Education
  //--------------------------------------------------

  educationControllers.clear();

  final education =
      data["educationAfter12th"] ?? [];

  if (education.isEmpty) {
    addEducation();
  } else {
    for (final edu in education) {
      final controller = EducationFormController();

      controller.institute.text =
          edu["institute"] ?? "";

      controller.degree.value =
          edu["degree"] ?? "";

      controller.field.text =
          edu["field"] ?? "";

      controller.grade.text =
          edu["grade"] ?? "";

      controller.startDate.text =
          edu["startDate"] ?? "";

      controller.endDate.text =
          edu["endDate"] ?? "";

      controller.currentlyStudying.value =
          edu["currentlyStudying"] ?? false;

      educationControllers.add(controller);
    }
  }

  //--------------------------------------------------
  // Projects
  //--------------------------------------------------

  projectControllers.clear();

  final projects = data["projects"] ?? [];

  if (projects.isEmpty) {
    addProject();
  } else {
    for (final p in projects) {
      final controller = ProjectFormController();

      controller.projectName.text =
          p["projectName"] ?? "";

      controller.role.text =
          p["role"] ?? "";

      controller.technologies.text =
          p["technologies"] ?? "";

      controller.github.text =
          p["github"] ?? "";

      controller.liveUrl.text =
          p["liveUrl"] ?? "";

      controller.description.text =
          p["description"] ?? "";

      projectControllers.add(controller);
    }
  }

  update();
}

  /// -------------------------------------------------------
  /// LIFECYCLE
  /// -------------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    addExperience();
    addEducation();
    addProject();
  }

  @override
  void onClose() {
    for (final item in experienceControllers) {
      item.dispose();
    }

    for (final item in educationControllers) {
      item.dispose();
    }

    for (final item in projectControllers) {
      item.dispose();
    }

    fullNameController.dispose();
    jobTitleController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    linkedInController.dispose();
    portfolioController.dispose();
    summaryController.dispose();
    skillController.dispose();

    super.onClose();
  }
}
