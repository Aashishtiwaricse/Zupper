import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zuperr/Screens/ProfileScreen/JobScreenStatus.dart';
import 'package:zuperr/Screens/ProfileScreen/ProfilePerformanceScreen.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/emptyWidgets.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/widgets.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/profileUpdateData/updateProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profile;
  bool isLoading = true;
  File? selectedResume;
  String experienceLevel = "";
  final noticePeriodController = TextEditingController();
  final minExpController = TextEditingController();
  final maxExpController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final mobileController = TextEditingController();
  final preferredLocationController = TextEditingController();
  final availabilityController = TextEditingController();
  final languageController = TextEditingController();
  final proficiencyController = TextEditingController();
  final internshipRoleController = TextEditingController();
  final internshipCompanyController = TextEditingController();
  final internshipProjectController = TextEditingController();
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final projectSkillsController = TextEditingController();
  final projectResultController = TextEditingController();
  final projectUrlController = TextEditingController();
  final projectFromController = TextEditingController();
  final projectToController = TextEditingController();
  final examNameController = TextEditingController();
  final examYearController = TextEditingController();
  final obtainedScoreController = TextEditingController();
  final maxScoreController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final certificationNameController = TextEditingController();
  final certificationIdController = TextEditingController();
  final certificationUrlController = TextEditingController();
  final companyNameController = TextEditingController();
  final positionController = TextEditingController();
  final annualSalaryController = TextEditingController();
  final keyAchievementsController = TextEditingController();
  final employmentDescriptionController = TextEditingController();

  final employmentFromController = TextEditingController();
  final employmentToController = TextEditingController();

  final workYearsController = TextEditingController();
  final workMonthsController = TextEditingController();

  bool isCurrentJob = false;
  final awardsController = TextEditingController();
  final clubsController = TextEditingController();
  final positionHeldController = TextEditingController();
  final educationalReferenceController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final mediaUploadController = TextEditingController();

  final certificationMonthController = TextEditingController();
  final certificationYearController = TextEditingController();
  final accomplishmentFromController = TextEditingController();
  final accomplishmentToController = TextEditingController();
  final achievementController = TextEditingController();
  final receivedDuringController = TextEditingController();
  final educationReferenceController = TextEditingController();
  final topRankController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final noticeController = TextEditingController();
  final minExperienceController = TextEditingController();
  final maxExperienceController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final landmarkController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final permanentLine1Controller = TextEditingController();
  final permanentLandmarkController = TextEditingController();
  final permanentDistrictController = TextEditingController();
  final permanentStateController = TextEditingController();
  final permanentCountryController = TextEditingController();
  final permanentPincodeController = TextEditingController();

  bool noExpiry = false;
  bool isCurrent = false;

  Future<void> updateProfile() async {
    final Map<String, dynamic> body = {
      "firstname": profile?["firstname"],
      "lastname": profile?["lastname"],
      "mobilenumber": profile?["mobilenumber"],
      "noticePeriod": noticePeriodController.text,

      "userExperienceLevel": profile?["userExperienceLevel"],

      "minimumExperienceInYears": int.tryParse(minExpController.text) ?? 0,

      "maximumExperienceInYears": int.tryParse(maxExpController.text) ?? 0,

      "profilePicture": profile?["profilePicture"],

      "resume": profile?["resume"],

      "dateOfBirth": profile?["dateOfBirth"],

      "gender": profile?["gender"],

      "maritalStatus": profile?["maritalStatus"],

      "address": profile?["address"],

      "permanentAddress": profile?["permanentAddress"],

      "hasPermanentAddress": profile?["hasPermanentAddress"],

      "educationAfter12th": profile?["educationAfter12th"],

      "educationTill12th": profile?["educationTill12th"],

      "careerPreference": {
        ...?profile?["careerPreference"],

        "preferredLocation": preferredLocationController.text,

        "availability": availabilityController.text,

        "minimumSalaryLPA": int.tryParse(minSalaryController.text) ?? 0,

        "maximumSalaryLPA": int.tryParse(maxSalaryController.text) ?? 0,
      },

      "keySkills": profile?["keySkills"],

      "languages": profile?["languages"],

      "internships": profile?["internships"],

      "projects": profile?["projects"],

      "profileSummary": summaryController.text,

      "currentPosition": profile?["currentPosition"],

      "currentCompany": profile?["currentCompany"],

      "accomplishments": profile?["accomplishments"],

      "competitiveExams": profile?["competitiveExams"],

      "employmentHistory": profile?["employmentHistory"],

      "academicAchievements": profile?["academicAchievements"],

      "selectedJobCategories": profile?["selectedJobCategories"],

      "candidateProfileVisibility": profile?["candidateProfileVisibility"],
    };

    final success = await UpdateProfileService.updateProfile(body);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );

      loadProfile();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to Update Profile")));
    }
  }

  int getProfileCompletionPercentage() {
    int completed = 0;
    const int total = 15;

    bool hasValue(dynamic value) {
      if (value == null) return false;
      if (value is String) return value.trim().isNotEmpty;
      if (value is List) return value.isNotEmpty;
      if (value is Map) return value.isNotEmpty;
      return true;
    }

    if (hasValue(profile?['profilePicture'])) completed++;
    if (hasValue(profile?['resume'])) completed++;
    if (hasValue(profile?['email'])) completed++;
    if (hasValue(profile?['mobilenumber'])) completed++;
    if (hasValue(profile?['profileSummary'])) completed++;

    if (hasValue(profile?['employmentHistory'])) completed++;
    if (hasValue(profile?['educationAfter12th'])) completed++;
    if (hasValue(profile?['projects'])) completed++;
    if (hasValue(profile?['skills'])) completed++;
    if (hasValue(profile?['competitiveExams'])) completed++;
    if (hasValue(profile?['academicAchievements'])) completed++;
    if (hasValue(profile?['accomplishments'])) completed++;
    if (hasValue(profile?['careerPreference'])) completed++;
    if (hasValue(profile?['address'])) completed++;

    return ((completed / total) * 100).round();
  }

  Widget _profileCompletionCard() {
    final percentage = getProfileCompletionPercentage();
    const total = 15;
    final completed = ((percentage * total) / 100).round();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffEEF4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Completion",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text(
                    "Complete your profile to get better matches",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                ],
              ),
              Text(
                "$percentage%",
                style: const TextStyle(
                  color: Color(0xff1E6BE3),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
            ),
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$completed of $total sections completed",
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPersonalDialog() async {
    String gender = profile?["gender"] ?? "";
    String maritalStatus = profile?["maritalStatus"] ?? "";

    final dobController = TextEditingController(
      text: profile?["dateOfBirth"] != null
          ? profile!["dateOfBirth"].toString().substring(0, 10)
          : "",
    );

    final noticeController = TextEditingController(
      text: profile?["noticePeriod"]?.toString() ?? "",
    );

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Edit Personal Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: gender.isEmpty ? null : gender,
                      decoration: const InputDecoration(labelText: "Gender"),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                      onChanged: (value) {
                        setStateDialog(() {
                          gender = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: maritalStatus.isEmpty ? null : maritalStatus,
                      decoration: const InputDecoration(
                        labelText: "Marital Status",
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Single",
                          child: Text("Single"),
                        ),
                        DropdownMenuItem(
                          value: "Married",
                          child: Text("Married"),
                        ),
                      ],
                      onChanged: (value) {
                        setStateDialog(() {
                          maritalStatus = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: dobController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.tryParse(
                                dobController.text.isEmpty
                                    ? "2000-01-01"
                                    : dobController.text,
                              ) ??
                              DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          dobController.text = picked
                              .toIso8601String()
                              .substring(0, 10);
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: noticeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Notice Period (Days)",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    profile!["gender"] = gender;
                    profile!["maritalStatus"] = maritalStatus;
                    profile!["dateOfBirth"] = dobController.text;
                    profile!["noticePeriod"] = noticeController.text;

                    await updateProfile();

                    setState(() {});

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEducationDialog(int index) async {
    final education = profile?["educationAfter12th"][index];

    final courseController = TextEditingController(
      text: education["courseName"] ?? "",
    );

    final specializationController = TextEditingController(
      text: education["specialization"] ?? "",
    );

    final instituteController = TextEditingController(
      text: education["instituteName"] ?? "",
    );

    final yearController = TextEditingController(
      text: education["passingYear"]?.toString() ?? "",
    );

    final percentageController = TextEditingController(
      text: education["percentage"]?.toString() ?? "",
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Education"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: courseController,
                decoration: const InputDecoration(labelText: "Course"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: specializationController,
                decoration: const InputDecoration(labelText: "Specialization"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instituteController,
                decoration: const InputDecoration(labelText: "Institute"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Passing Year"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: percentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Percentage / CGPA",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              profile!["educationAfter12th"][index]["courseName"] =
                  courseController.text;

              profile!["educationAfter12th"][index]["specialization"] =
                  specializationController.text;

              profile!["educationAfter12th"][index]["instituteName"] =
                  instituteController.text;

              profile!["educationAfter12th"][index]["passingYear"] =
                  yearController.text;

              profile!["educationAfter12th"][index]["percentage"] =
                  percentageController.text;

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _showNoticePeriodDialog() async {
    noticePeriodController.text = profile?["noticePeriod"]?.toString() ?? "";

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Update Notice Period"),
          content: TextField(
            controller: noticePeriodController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Notice Period (Days)",
              hintText: "e.g. 30",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update local profile
                profile?["noticePeriod"] = noticePeriodController.text.trim();

                await updateProfile();

                setState(() {});

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          selectedResume = File(result.files.single.path!);
          profile?['resume'] = result.files.single.name;
        });

        // TODO: Call your upload API here
        print("Selected Resume: ${result.files.single.path}");
      }
    } catch (e) {
      print("Resume Pick Error: $e");
    }
  }

  Future<void> _showCTCDialog() async {
    String preferredLocation =
        profile?['careerPreference']?['preferredLocation'] ?? "";

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Update Salary Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: minSalaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Minimum Salary (LPA)",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: maxSalaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Maximum Salary (LPA)",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      initialValue: preferredLocation,
                      decoration: const InputDecoration(
                        labelText: "Preferred Location",
                      ),
                      onChanged: (value) {
                        preferredLocation = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    // Update local profile
                    profile?["careerPreference"]["minimumSalaryLPA"] =
                        int.tryParse(minSalaryController.text) ?? 0;

                    profile?["careerPreference"]["maximumSalaryLPA"] =
                        int.tryParse(maxSalaryController.text) ?? 0;

                    profile?["careerPreference"]["preferredLocation"] =
                        preferredLocation;

                    await updateProfile();

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteResume() async {
    setState(() {
      selectedResume = null;
      profile?['resume'] = null;
    });

    // TODO: Call delete resume API here
    print("Resume Deleted");
  }

  Map<String, bool> expanded = {
    "resume": false,
    "education": false,
    "personal": false,
    "skills": false,
    "career": false,
    "languages": false,
    "internships": false,

    "noticePeriod": false,
    "experience": false,
    "ctc": false,
  };

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await CandidateService.getCandidateData();

    setState(() {
      noticePeriodController.text = profile?['noticePeriod']?.toString() ?? '';

      minExpController.text =
          profile?['minimumExperienceInYears']?.toString() ?? '';

      maxExpController.text =
          profile?['maximumExperienceInYears']?.toString() ?? '';

      minSalaryController.text =
          profile?['careerPreference']?['minimumSalaryLPA']?.toString() ?? '';

      maxSalaryController.text =
          profile?['careerPreference']?['maximumSalaryLPA']?.toString() ?? '';
      profile = data;
      summaryController.text = data?['profileSummary'] ?? '';
      experienceLevel = data?["userExperienceLevel"] ?? "";

      minExpController.text =
          data?["minimumExperienceInYears"]?.toString() ?? "";

      maxExpController.text =
          data?["maximumExperienceInYears"]?.toString() ?? "";

      skillsController.text =
          (data?['keySkills'] as List?)
              ?.map((e) => e is Map ? e['Name'] : e.toString())
              .join(', ') ??
          '';
      preferredLocationController.text =
          data?["careerPreference"]?["preferredLocation"] ?? "";

      availabilityController.text =
          data?["careerPreference"]?["availability"] ?? "";

      minSalaryController.text =
          data?["careerPreference"]?["minimumSalaryLPA"]?.toString() ?? "";

      maxSalaryController.text =
          data?["careerPreference"]?["maximumSalaryLPA"]?.toString() ?? "";
      isLoading = false;
    });
  }

  Future<void> _showCareerDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Career Preference"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: preferredLocationController,
                decoration: const InputDecoration(
                  labelText: "Preferred Location",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: availabilityController,
                decoration: const InputDecoration(labelText: "Availability"),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: minSalaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Minimum Salary (LPA)",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: maxSalaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Maximum Salary (LPA)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              profile!["careerPreference"]["preferredLocation"] =
                  preferredLocationController.text;

              profile!["careerPreference"]["availability"] =
                  availabilityController.text;

              profile!["careerPreference"]["minimumSalaryLPA"] =
                  int.tryParse(minSalaryController.text) ?? 0;

              profile!["careerPreference"]["maximumSalaryLPA"] =
                  int.tryParse(maxSalaryController.text) ?? 0;

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _showExperienceDialog() async {
    String tempExperience = experienceLevel;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Update Experience"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: tempExperience.isEmpty ? null : tempExperience,
                    decoration: const InputDecoration(
                      labelText: "Experience Level",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "fresher",
                        child: Text("Fresher"),
                      ),
                      DropdownMenuItem(
                        value: "experienced",
                        child: Text("Experienced"),
                      ),
                    ],
                    onChanged: (value) {
                      setStateDialog(() {
                        tempExperience = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: minExpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Minimum Experience",
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: maxExpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Maximum Experience",
                    ),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      experienceLevel = tempExperience;
                    });
                    await updateProfile();

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _headerSection(),
            _buildNavigationTile(
              title: "Profile Performance",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePerformanceScreen(
                      percentage: getProfileCompletionPercentage(),
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
            ),

            _buildNavigationTile(
              title: "Job Application Status",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobApplicationStatusScreen(
                      percentage: getProfileCompletionPercentage(),
                    ),
                  ),
                );
              },
            ),
            _profileCompletionCard(),

            const SizedBox(height: 10),

            _detailTile(
              keyName: "experience",
              title: "Add Experience",
              subtitle: "Showcase your professional journey",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow(
                    "Experience Level",
                    experienceLevel.isEmpty ? "Not Added" : experienceLevel,
                  ),

                  infoRow(
                    "Min Experience",
                    minExpController.text.isEmpty
                        ? "-"
                        : "${minExpController.text} Years",
                  ),

                  infoRow(
                    "Max Experience",
                    maxExpController.text.isEmpty
                        ? "-"
                        : "${maxExpController.text} Years",
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showExperienceDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                    ),
                  ),
                ],
              ),
            ),

            _detailTile(
              keyName: "ctc",
              title: "Add Current CTC",
              subtitle: "Get relevant salary-matched opportunities",
              child: Column(
                children: [
                  infoRow(
                    "Minimum Salary",
                    "₹${profile?['careerPreference']?['minimumSalaryLPA'] ?? '-'} LPA",
                  ),

                  infoRow(
                    "Maximum Salary",
                    "₹${profile?['careerPreference']?['maximumSalaryLPA'] ?? '-'} LPA",
                  ),

                  infoRow(
                    "Preferred Location",
                    profile?['careerPreference']?['preferredLocation'] ?? '-',
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: _showCTCDialog,
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                ],
              ),
            ),

            _detailTile(
              keyName: "noticePeriod",
              title: "Add Notice Period",
              subtitle: "Help recruiters understand your availability",
              child: Column(
                children: [
                  infoRow(
                    "Notice Period",
                    profile?['noticePeriod'] ?? "Not Added",
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: _showNoticePeriodDialog,

                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Complete Your Profile",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildResumeSection(),
            _buildEducationSection(),
            _buildPersonalSection(),
            _buildSkillsSection(),
            _buildCareerSection(),
            _buildLanguageSection(),
            _buildInternshipSection(),
            _buildProjectsSection(),
            _buildProfileSummarySection(),
            _buildAccomplishmentSection(),
            _buildCompetitiveExamsSection(),
            _buildEmploymentHistorySection(),
            _buildAcademicAchievementsSection(),
          ],
        ),
      ),
    );
  }

  Widget _detailTile({
    required String keyName,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expanded[keyName] = !(expanded[keyName] ?? false);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 23),
                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: expanded[keyName] == true
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 38, right: 10, bottom: 16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeSection() {
    final resume = profile?['resume'];

    return profileSection(
      keyName: "resume",
      title: "Resume Upload",
      subtitle: "Upload your professional resume",
      bgColor: const Color(0xffF4F4F4),
      stripeColor: Colors.grey,
      child: resume == null
          ? InkWell(
              onTap: _pickResume,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.upload_file_outlined,
                      size: 32,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Upload Resume",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "PDF, DOC or DOCX (max 2 MB)",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffE8FFF0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined, color: Colors.green),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      resume.toString().split('/').last,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  IconButton(
                    onPressed: _pickResume,
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  ),

                  IconButton(
                    onPressed: _deleteResume,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 26,
                    color: Colors.black87,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalSection() {
    return profileSection(
      keyName: "personal",
      title: "Personal Details",
      subtitle: "Complete your basic information",
      bgColor: const Color(0xffFFF1F1),
      stripeColor: Colors.red,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _personalRow("Gender", profile?['gender'] ?? "Not Added"),
            _personalRow(
              "Marital Status",
              profile?['maritalStatus'] ?? "Not Added",
            ),
            _personalRow(
              "DOB",
              profile?['dateOfBirth'] != null
                  ? profile!['dateOfBirth'].toString().substring(0, 10)
                  : "Not Added",
            ),
            _personalRow(
              "Notice Period",
              profile?['noticePeriod'] ?? "Not Added",
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showPersonalDialog,
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInternshipSection() {
    final internships = profile?['internships'] ?? [];

    return profileSection(
      keyName: "internships",
      title: "Internships",
      subtitle: "Add your internships experience",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: internships.isEmpty
          ? emptyBox("Add Internship")
          : Column(
              children: List.generate(internships.length, (index) {
                final item = internships[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['role'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(item['companyName'] ?? ''),
                            const SizedBox(height: 5),
                            Text(
                              item['projectName'] ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showInternshipDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildProjectsSection() {
    final projects = profile?['projects'] ?? [];

    return profileSection(
      keyName: "projects",
      title: "Projects",
      subtitle: "Add your projects",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: projects.isEmpty
          ? emptyBox("Add Project")
          : Column(
              children: List.generate(projects.length, (index) {
                final item = projects[index];

                final from = item['duration']?['from'] ?? '';
                final to = item['duration']?['to'] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['projectName'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              item['description'] ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Skills: ${item['keySkills'] ?? ''}",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Result: ${item['endResult'] ?? ''}",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Duration: ${from.split('T').first} - ${to.split('T').first}",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            if ((item['projectURL'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Text(
                                item['projectURL'],
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showProjectDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Future<void> _showProjectDialog(int index) async {
    final project = profile!["projects"][index];

    projectNameController.text = project["projectName"] ?? "";
    projectDescriptionController.text = project["description"] ?? "";
    projectSkillsController.text = project["keySkills"] ?? "";
    projectResultController.text = project["endResult"] ?? "";
    projectUrlController.text = project["projectURL"] ?? "";

    projectFromController.text =
        project["duration"]?["from"]?.toString().substring(0, 10) ?? "";

    projectToController.text =
        project["duration"]?["to"]?.toString().substring(0, 10) ?? "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Project"),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: projectNameController,
                  decoration: const InputDecoration(labelText: "Project Name"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: projectDescriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: projectSkillsController,
                  decoration: const InputDecoration(labelText: "Key Skills"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: projectResultController,
                  decoration: const InputDecoration(labelText: "End Result"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: projectUrlController,
                  decoration: const InputDecoration(labelText: "Project URL"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: projectFromController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "From Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: projectFromController.text.isEmpty
                          ? DateTime.now()
                          : DateTime.parse(projectFromController.text),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      projectFromController.text = picked
                          .toIso8601String()
                          .substring(0, 10);
                    }
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: projectToController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "To Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: projectToController.text.isEmpty
                          ? DateTime.now()
                          : DateTime.parse(projectToController.text),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      projectToController.text = picked
                          .toIso8601String()
                          .substring(0, 10);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              profile!["projects"][index] = {
                ...project,
                "projectName": projectNameController.text,
                "description": projectDescriptionController.text,
                "keySkills": projectSkillsController.text,
                "endResult": projectResultController.text,
                "projectURL": projectUrlController.text,
                "duration": {
                  "from": DateTime.parse(
                    projectFromController.text,
                  ).toIso8601String(),
                  "to": DateTime.parse(
                    projectToController.text,
                  ).toIso8601String(),
                },
              };

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummarySection() {
    return profileSection(
      keyName: "profileSummary",
      title: "Profile Summary",
      subtitle: "Tell recruiters about yourself",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: (profile?["profileSummary"] ?? "").toString().trim().isEmpty
          ? emptyBox("Add Profile Summary")
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      profile?["profileSummary"] ?? "",
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showProfileSummaryDialog,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAccomplishmentSection() {
    final accomplishments = profile?["accomplishments"] ?? [];

    return profileSection(
      keyName: "accomplishments",
      title: "Accomplishments",
      subtitle: "Add your certifications and achievements",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: accomplishments.isEmpty
          ? emptyBox("Add Accomplishment")
          : Column(
              children: List.generate(accomplishments.length, (index) {
                final item = accomplishments[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["certificationName"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text("Award : ${item["awards"] ?? ""}"),

                            Text("Club : ${item["clubs"] ?? ""}"),

                            Text("Position : ${item["positionHeld"] ?? ""}"),

                            Text(
                              "Certification ID : ${item["certificationID"] ?? ""}",
                            ),

                            Text(
                              "Responsibilities : ${item["responsibilities"] ?? ""}",
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showAccomplishmentDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildCompetitiveExamsSection() {
    final exams = profile?["competitiveExams"] ?? [];

    return profileSection(
      keyName: "competitiveExams",
      title: "Competitive Exams",
      subtitle: "Add your competitive exam details",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: exams.isEmpty
          ? emptyBox("Add Competitive Exam")
          : Column(
              children: List.generate(exams.length, (index) {
                final item = exams[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["examName"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text("Exam Year: ${item["examYear"] ?? ""}"),

                            Text(
                              "Score: ${item["obtainedScore"] ?? ""} / ${item["maxScore"] ?? ""}",
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showCompetitiveExamDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildEmploymentHistorySection() {
    final jobs = profile?["employmentHistory"] ?? [];

    return profileSection(
      keyName: "employmentHistory",
      title: "Employment History",
      subtitle: "Add your work experience",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: jobs.isEmpty
          ? emptyBox("Add Employment")
          : Column(
              children: List.generate(jobs.length, (index) {
                final item = jobs[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["position"] ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(item["companyName"] ?? ""),

                            const SizedBox(height: 4),

                            Text("Salary : ₹${item["annualSalary"] ?? ""}"),

                            const SizedBox(height: 4),

                            Text(
                              "Experience : ${item["workExperience"]?["years"] ?? 0} Years ${item["workExperience"]?["months"] ?? 0} Months",
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item["description"] ?? "",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEmploymentDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildAcademicAchievementsSection() {
    final achievements = profile?["academicAchievements"] ?? [];

    return profileSection(
      keyName: "academicAchievements",
      title: "Academic Achievements",
      subtitle: "Highlight your academic excellence",
      bgColor: const Color(0xffEEF7FF),
      stripeColor: Colors.lightBlue,
      child: achievements.isEmpty
          ? emptyBox("Add Academic Achievement")
          : Column(
              children: List.generate(achievements.length, (index) {
                final item = achievements[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["achievement"] ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              item["topRank"] ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              "${item["educationReference"] ?? ""} • ${item["receivedDuring"] ?? ""}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showAcademicAchievementDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Future<void> _showAcademicAchievementDialog(int index) async {
    final item = profile!["academicAchievements"][index];

    achievementController.text = item["achievement"] ?? "";
    receivedDuringController.text = item["receivedDuring"] ?? "";
    educationReferenceController.text = item["educationReference"] ?? "";
    topRankController.text = item["topRank"] ?? "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Academic Achievement"),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: achievementController,
                  decoration: const InputDecoration(labelText: "Achievement"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: topRankController,
                  decoration: const InputDecoration(labelText: "Top Rank"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: educationReferenceController,
                  decoration: const InputDecoration(
                    labelText: "Education Reference",
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: receivedDuringController,
                  decoration: const InputDecoration(
                    labelText: "Received During",
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              profile!["academicAchievements"][index] = {
                ...item,
                "achievement": achievementController.text,
                "receivedDuring": receivedDuringController.text,
                "educationReference": educationReferenceController.text,
                "topRank": topRankController.text,
              };

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _showEmploymentDialog(int index) async {
    final item = profile!["employmentHistory"][index];

    companyNameController.text = item["companyName"] ?? "";
    positionController.text = item["position"] ?? "";
    annualSalaryController.text = item["annualSalary"] ?? "";
    keyAchievementsController.text = item["keyAchievements"] ?? "";
    employmentDescriptionController.text = item["description"] ?? "";

    workYearsController.text =
        item["workExperience"]?["years"]?.toString() ?? "";

    workMonthsController.text =
        item["workExperience"]?["months"]?.toString() ?? "";

    employmentFromController.text =
        item["duration"]?["from"]?.substring(0, 10) ?? "";

    employmentToController.text =
        item["duration"]?["to"]?.substring(0, 10) ?? "";

    isCurrentJob = item["isCurrentJob"] ?? false;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Edit Employment"),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: companyNameController,
                      decoration: const InputDecoration(
                        labelText: "Company Name",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: positionController,
                      decoration: const InputDecoration(labelText: "Position"),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: annualSalaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Annual Salary",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: workYearsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Experience (Years)",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: workMonthsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Experience (Months)",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: keyAchievementsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Key Achievements",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: employmentDescriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Job Description",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: employmentFromController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "From Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: employmentFromController.text.isEmpty
                              ? DateTime.now()
                              : DateTime.parse(employmentFromController.text),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          employmentFromController.text = picked
                              .toIso8601String()
                              .substring(0, 10);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: employmentToController,
                      readOnly: isCurrentJob,
                      decoration: const InputDecoration(
                        labelText: "To Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: isCurrentJob
                          ? null
                          : () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: employmentToController.text.isEmpty
                                    ? DateTime.now()
                                    : DateTime.parse(
                                        employmentToController.text,
                                      ),
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2100),
                              );

                              if (picked != null) {
                                employmentToController.text = picked
                                    .toIso8601String()
                                    .substring(0, 10);
                              }
                            },
                    ),

                    CheckboxListTile(
                      title: const Text("Current Job"),
                      value: isCurrentJob,
                      onChanged: (value) {
                        setDialogState(() {
                          isCurrentJob = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              ElevatedButton(
                onPressed: () async {
                  profile!["employmentHistory"][index] = {
                    ...item,
                    "companyName": companyNameController.text,
                    "position": positionController.text,
                    "annualSalary": annualSalaryController.text,
                    "keyAchievements": keyAchievementsController.text,
                    "description": employmentDescriptionController.text,
                    "isCurrentJob": isCurrentJob,
                    "workExperience": {
                      "years": int.tryParse(workYearsController.text) ?? 0,
                      "months": int.tryParse(workMonthsController.text) ?? 0,
                    },
                    "duration": {
                      "from": DateTime.parse(
                        employmentFromController.text,
                      ).toIso8601String(),
                      "to": isCurrentJob
                          ? null
                          : DateTime.parse(
                              employmentToController.text,
                            ).toIso8601String(),
                    },
                  };

                  await updateProfile();

                  setState(() {});

                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showCompetitiveExamDialog(int index) async {
    final exam = profile!["competitiveExams"][index];

    examNameController.text = exam["examName"] ?? "";
    examYearController.text = exam["examYear"] ?? "";
    obtainedScoreController.text = exam["obtainedScore"] ?? "";
    maxScoreController.text = exam["maxScore"] ?? "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Competitive Exam"),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: examNameController,
                  decoration: const InputDecoration(labelText: "Exam Name"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: examYearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Exam Year"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: obtainedScoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Obtained Score",
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: maxScoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Maximum Score"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              profile!["competitiveExams"][index] = {
                ...exam,
                "examName": examNameController.text,
                "examYear": examYearController.text,
                "obtainedScore": obtainedScoreController.text,
                "maxScore": maxScoreController.text,
              };

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _showAccomplishmentDialog(int index) async {
    final item = profile!["accomplishments"][index];

    certificationNameController.text = item["certificationName"] ?? "";
    certificationIdController.text = item["certificationID"] ?? "";
    certificationUrlController.text = item["certificationURL"] ?? "";

    awardsController.text = item["awards"] ?? "";
    clubsController.text = item["clubs"] ?? "";
    positionHeldController.text = item["positionHeld"] ?? "";
    educationalReferenceController.text = item["educationalReference"] ?? "";
    responsibilitiesController.text = item["responsibilities"] ?? "";
    mediaUploadController.text = item["mediaUpload"] ?? "";

    certificationMonthController.text =
        item["certificationValidity"]?["month"] ?? "";

    certificationYearController.text =
        item["certificationValidity"]?["year"] ?? "";

    accomplishmentFromController.text =
        item["duration"]?["from"]?.substring(0, 10) ?? "";

    accomplishmentToController.text =
        item["duration"]?["to"]?.substring(0, 10) ?? "";

    noExpiry = item["noExpiry"] ?? false;
    isCurrent = item["isCurrent"] ?? false;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Accomplishment"),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: certificationNameController,
                        decoration: const InputDecoration(
                          labelText: "Certification Name",
                        ),
                      ),

                      TextField(
                        controller: certificationIdController,
                        decoration: const InputDecoration(
                          labelText: "Certification ID",
                        ),
                      ),

                      TextField(
                        controller: certificationUrlController,
                        decoration: const InputDecoration(
                          labelText: "Certification URL",
                        ),
                      ),

                      TextField(
                        controller: awardsController,
                        decoration: const InputDecoration(labelText: "Awards"),
                      ),

                      TextField(
                        controller: clubsController,
                        decoration: const InputDecoration(labelText: "Clubs"),
                      ),

                      TextField(
                        controller: positionHeldController,
                        decoration: const InputDecoration(
                          labelText: "Position Held",
                        ),
                      ),

                      TextField(
                        controller: educationalReferenceController,
                        decoration: const InputDecoration(
                          labelText: "Educational Reference",
                        ),
                      ),

                      TextField(
                        controller: responsibilitiesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Responsibilities",
                        ),
                      ),

                      TextField(
                        controller: mediaUploadController,
                        decoration: const InputDecoration(
                          labelText: "Media URL",
                        ),
                      ),

                      TextField(
                        controller: certificationMonthController,
                        decoration: const InputDecoration(
                          labelText: "Expiry Month",
                        ),
                      ),

                      TextField(
                        controller: certificationYearController,
                        decoration: const InputDecoration(
                          labelText: "Expiry Year",
                        ),
                      ),

                      CheckboxListTile(
                        value: noExpiry,
                        title: const Text("No Expiry"),
                        onChanged: (v) {
                          setDialogState(() {
                            noExpiry = v!;
                          });
                        },
                      ),

                      CheckboxListTile(
                        value: isCurrent,
                        title: const Text("Current"),
                        onChanged: (v) {
                          setDialogState(() {
                            isCurrent = v!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    profile!["accomplishments"][index] = {
                      ...item,
                      "certificationName": certificationNameController.text,
                      "certificationID": certificationIdController.text,
                      "certificationURL": certificationUrlController.text,
                      "awards": awardsController.text,
                      "clubs": clubsController.text,
                      "positionHeld": positionHeldController.text,
                      "educationalReference":
                          educationalReferenceController.text,
                      "responsibilities": responsibilitiesController.text,
                      "mediaUpload": mediaUploadController.text,
                      "noExpiry": noExpiry,
                      "isCurrent": isCurrent,
                      "certificationValidity": {
                        "month": certificationMonthController.text,
                        "year": certificationYearController.text,
                      },
                      "duration": {
                        "from": DateTime.parse(
                          accomplishmentFromController.text,
                        ).toIso8601String(),
                        "to": DateTime.parse(
                          accomplishmentToController.text,
                        ).toIso8601String(),
                      },
                    };

                    await updateProfile();

                    setState(() {});

                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showProfileSummaryDialog() async {
    summaryController.text = profile?["profileSummary"] ?? "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile Summary"),
        content: SizedBox(
          width: 500,
          child: TextField(
            controller: summaryController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: "Write something about yourself...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              profile!["profileSummary"] = summaryController.text.trim();

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _showInternshipDialog(int index) async {
    final internship = profile?["internships"][index];

    internshipRoleController.text = internship["role"] ?? "";
    internshipCompanyController.text = internship["companyName"] ?? "";
    internshipProjectController.text = internship["projectName"] ?? "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Internship"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: internshipRoleController,
                decoration: const InputDecoration(labelText: "Role"),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: internshipCompanyController,
                decoration: const InputDecoration(labelText: "Company Name"),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: internshipProjectController,
                decoration: const InputDecoration(labelText: "Project Name"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              profile!["internships"][index]["role"] =
                  internshipRoleController.text;

              profile!["internships"][index]["companyName"] =
                  internshipCompanyController.text;

              profile!["internships"][index]["projectName"] =
                  internshipProjectController.text;

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget profileSection({
    required String keyName,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color stripeColor,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: stripeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expanded[keyName] = !(expanded[keyName] ?? false);
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            expanded[keyName] == true
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),

                    if (expanded[keyName] == true) ...[
                      const SizedBox(height: 20),
                      child,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    final education = profile?['educationAfter12th'] ?? [];

    return profileSection(
      keyName: "education",
      title: "Education",
      subtitle: "Add your educational qualifications",
      bgColor: const Color(0xffEAF3FF),
      stripeColor: const Color(0xff2B78F0),
      child: education.isEmpty
          ? emptyBox("Add Education")
          : Column(
              children: education.map<Widget>((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e['courseName'] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(e['specialization'] ?? ""),
                            const SizedBox(height: 8),
                            Text(e['instituteName'] ?? ""),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          _showEducationDialog(education.indexOf(e));
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Future<void> _showLanguageDialog(int index) async {
    final language = profile?["languages"][index];

    languageController.text = language["language"] ?? "";
    proficiencyController.text = language["proficiencyLevel"] ?? "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Language"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: languageController,
                decoration: const InputDecoration(labelText: "Language"),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: proficiencyController.text.isEmpty
                    ? null
                    : proficiencyController.text,
                decoration: const InputDecoration(labelText: "Proficiency"),
                items: const [
                  DropdownMenuItem(value: "Beginner", child: Text("Beginner")),
                  DropdownMenuItem(
                    value: "Intermediate",
                    child: Text("Intermediate"),
                  ),
                  DropdownMenuItem(value: "Advanced", child: Text("Advanced")),
                  DropdownMenuItem(value: "Native", child: Text("Native")),
                ],
                onChanged: (value) {
                  proficiencyController.text = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              profile!["languages"][index]["language"] =
                  languageController.text;

              profile!["languages"][index]["proficiencyLevel"] =
                  proficiencyController.text;

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = profile?['keySkills'] ?? [];

    return profileSection(
      keyName: "skills",
      title: "Key Skills",
      subtitle: "Highlight your technical and soft skills",
      bgColor: const Color(0xffF4EEDB),
      stripeColor: Colors.orange,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Skills expert in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: skills.map<Widget>((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xffD9D9D9)),
                  ),
                  child: Text(
                    skill['Name'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _editSkillsDialog,
                icon: const Icon(Icons.edit),
                label: const Text(
                  "Edit Skills",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editSkillsDialog() async {
    skillsController.text =
        (profile?['keySkills'] as List?)
            ?.map((e) => e['Name'].toString())
            .join(', ') ??
        '';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Skills"),
        content: TextField(
          controller: skillsController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Flutter, Dart, Firebase, REST API",
            labelText: "Skills (Comma Separated)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final skills = skillsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

              // Convert back to the format expected by your UI/API
              profile!["keySkills"] = skills.map((e) => {"Name": e}).toList();

              await updateProfile();

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    final languages = profile?['languages'] ?? [];

    return profileSection(
      keyName: "languages",
      title: "Languages",
      subtitle: "List languages you can communicate in",
      bgColor: const Color(0xffF3F2FA),
      stripeColor: Colors.indigo,
      child: Column(
        children: List.generate(languages.length, (index) {
          final lang = languages[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(lang['language'] ?? ""),
              subtitle: Text(lang['proficiencyLevel'] ?? ""),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showLanguageDialog(index),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCareerSection() {
    final career = profile?['careerPreference'] ?? {};

    return profileSection(
      keyName: "career",
      title: "Career Preferences",
      subtitle: "Set your job preferences and expectations",
      bgColor: const Color(0xffEAF8F0),
      stripeColor: Colors.green,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Preferred Location: ${career['preferredLocation'] ?? '-'}"),

            const SizedBox(height: 8),

            Text("Availability: ${career['availability'] ?? '-'}"),

            const SizedBox(height: 8),

            Text(
              "Salary: ₹${career['minimumSalaryLPA'] ?? 0} - ₹${career['maximumSalaryLPA'] ?? 0} LPA",
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showCareerDialog,
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: Color(0xff1E6BE3),
        image: DecorationImage(
          image: AssetImage("assets/Head.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 40),

          Row(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: profile?['profilePicture'] != null
                    ? NetworkImage(profile!['profilePicture'])
                    : const AssetImage("assets/profile.png") as ImageProvider,
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${profile?['firstname'] ?? ''} ${profile?['lastname'] ?? ''}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      profile?['currentPosition'] ?? "Candidate",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

              InkWell(
                onTap: _showHeaderDialog,

                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: _infoItem(
                  Icons.location_on_outlined,
                  profile?['address']?['district'] ?? "Not Added",
                ),
              ),
              SizedBox(width: 10),

              Container(
                height: 50,
                width: 1,
                color: Colors.white.withOpacity(0.4),
              ),

              Expanded(
                child: _infoItem(Icons.email_outlined, profile?['email'] ?? ""),
              ),
              SizedBox(width: 10),

              Container(
                height: 50,
                width: 1,
                color: Colors.white.withOpacity(0.4),
              ),

              Expanded(
                child: _infoItem(
                  Icons.phone_android,
                  profile?['mobilenumber'] ?? "",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showHeaderDialog() async {
    firstNameController.text = profile?["firstname"] ?? "";
    lastNameController.text = profile?["lastname"] ?? "";
    emailController.text = profile?["email"] ?? "";
    mobileNumberController.text = profile?["mobilenumber"] ?? "";

    noticeController.text = profile?["noticePeriod"] ?? "";

    minExperienceController.text =
        profile?["minimumExperienceInYears"]?.toString() ?? "";

    maxExperienceController.text =
        profile?["maximumExperienceInYears"]?.toString() ?? "";

    experienceLevel = profile?["userExperienceLevel"] ?? "";

    addressLine1Controller.text = profile?["address"]?["line1"] ?? "";

    landmarkController.text = profile?["address"]?["landmark"] ?? "";

    districtController.text = profile?["address"]?["district"] ?? "";

    stateController.text = profile?["address"]?["state"] ?? "";

    countryController.text = profile?["address"]?["country"] ?? "";

    pincodeController.text = profile?["address"]?["pincode"] ?? "";

    permanentLine1Controller.text =
        profile?["permanentAddress"]?["line1"] ?? "";

    permanentLandmarkController.text =
        profile?["permanentAddress"]?["landmark"] ?? "";

    permanentDistrictController.text =
        profile?["permanentAddress"]?["district"] ?? "";

    permanentStateController.text =
        profile?["permanentAddress"]?["state"] ?? "";

    permanentCountryController.text =
        profile?["permanentAddress"]?["country"] ?? "";

    permanentPincodeController.text =
        profile?["permanentAddress"]?["pincode"] ?? "";

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Edit Profile"),
            content: SizedBox(
              width: 550,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                      ),
                    ),

                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: "Last Name"),
                    ),

                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),

                    TextField(
                      controller: mobileNumberController,
                      decoration: const InputDecoration(labelText: "Mobile"),
                    ),

                    DropdownButtonFormField<String>(
                      value: experienceLevel.isEmpty ? null : experienceLevel,
                      decoration: const InputDecoration(
                        labelText: "Experience Level",
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "fresher",
                          child: Text("Fresher"),
                        ),
                        DropdownMenuItem(
                          value: "experienced",
                          child: Text("Experienced"),
                        ),
                      ],
                      onChanged: (v) {
                        setDialogState(() {
                          experienceLevel = v!;
                        });
                      },
                    ),

                    TextField(
                      controller: noticeController,
                      decoration: const InputDecoration(
                        labelText: "Notice Period",
                      ),
                    ),

                    TextField(
                      controller: minExperienceController,
                      decoration: const InputDecoration(
                        labelText: "Minimum Experience",
                      ),
                    ),

                    TextField(
                      controller: maxExperienceController,
                      decoration: const InputDecoration(
                        labelText: "Maximum Experience",
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Current Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    TextField(
                      controller: addressLine1Controller,
                      decoration: const InputDecoration(labelText: "Address"),
                    ),

                    TextField(
                      controller: landmarkController,
                      decoration: const InputDecoration(labelText: "Landmark"),
                    ),

                    TextField(
                      controller: districtController,
                      decoration: const InputDecoration(labelText: "District"),
                    ),

                    TextField(
                      controller: stateController,
                      decoration: const InputDecoration(labelText: "State"),
                    ),

                    TextField(
                      controller: countryController,
                      decoration: const InputDecoration(labelText: "Country"),
                    ),

                    TextField(
                      controller: pincodeController,
                      decoration: const InputDecoration(labelText: "Pincode"),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              ElevatedButton(
                onPressed: () async {
                  profile!["firstname"] = firstNameController.text;
                  profile!["lastname"] = lastNameController.text;
                  profile!["email"] = emailController.text;
                  profile!["mobilenumber"] = mobileNumberController.text;

                  profile!["noticePeriod"] = noticeController.text;

                  profile!["userExperienceLevel"] = experienceLevel;

                  profile!["minimumExperienceInYears"] =
                      int.tryParse(minExperienceController.text) ?? 0;

                  profile!["maximumExperienceInYears"] =
                      int.tryParse(maxExperienceController.text) ?? 0;

                  profile!["address"] = {
                    "line1": addressLine1Controller.text,
                    "landmark": landmarkController.text,
                    "district": districtController.text,
                    "state": stateController.text,
                    "country": countryController.text,
                    "pincode": pincodeController.text,
                  };

                  profile!["permanentAddress"] = {
                    "line1": permanentLine1Controller.text,
                    "landmark": permanentLandmarkController.text,
                    "district": permanentDistrictController.text,
                    "state": permanentStateController.text,
                    "country": permanentCountryController.text,
                    "pincode": permanentPincodeController.text,
                  };

                  await updateProfile();

                  setState(() {});

                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }
}
