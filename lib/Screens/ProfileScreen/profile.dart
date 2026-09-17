import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zuperr/Models/InternshipModel/internship.dart';
import 'package:zuperr/Screens/ProfileScreen/Accomplishment/profileAccomplishment.dart';
import 'package:zuperr/Screens/ProfileScreen/JobScreenStatus.dart';
import 'package:zuperr/Screens/ProfileScreen/ProfilePerformanceScreen.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/AcademicAchivement/achivementBottomSheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/AddSchoolEducationDialog.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Employement/employment_bottom_sheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/ProjectBottomSheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/_infoItem.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/addEducation.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/emptyWidgets.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/internshipBottomModel.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/personal_details_bottom_sheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/skillsBottomSheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/widgets.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/PofileUpdate/profile_update.dart';
import 'package:zuperr/Services/UpdateUserData/updateCandidatesdata.dart';
import 'package:zuperr/Services/profileUpdateData/updateProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
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

  String _monthName(String month) {
    const months = {
      "1": "Jan",
      "01": "Jan",
      "2": "Feb",
      "02": "Feb",
      "3": "Mar",
      "03": "Mar",
      "4": "Apr",
      "04": "Apr",
      "5": "May",
      "05": "May",
      "6": "Jun",
      "06": "Jun",
      "7": "Jul",
      "07": "Jul",
      "8": "Aug",
      "08": "Aug",
      "9": "Sep",
      "09": "Sep",
      "10": "Oct",
      "11": "Nov",
      "12": "Dec",
    };

    return months[month] ?? "";
  }

  bool noExpiry = false;
  bool isCurrent = false;

  Future<void> showProjectBottomSheet({
    Map<String, dynamic>? project,
    int? index,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ProjectBottomSheet(
          project: project,
          index: index,
          projects: List.from(profile?["projects"] ?? []),
          onSaved: () {
            setState(() {});
          },
        );
      },
    );
  }

  String currentLocation = "";
  bool isGettingLocation = false;

  Future<void> getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar(
        "Location",
        "Please enable location services",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.location_off, color: Colors.white),
      );

      setState(() {
        isGettingLocation = false;
      });

      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );

      setState(() {
        isGettingLocation = false;
      });

      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final location =
          "${place.locality ?? place.subAdministrativeArea ?? ""}, ${place.administrativeArea ?? ""}";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("current_location", location);
      await prefs.setString("current_location", location);
      await prefs.setDouble("latitude", position.latitude);
      await prefs.setDouble("longitude", position.longitude);

      setState(() {
        currentLocation = location;
        isGettingLocation = false;
      });
    }
  }

  void showInternshipSheet({InternshipModel? internship, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InternshipBottomSheet(
        internship: internship,
        index: index,
        internships: List.from(profile?['internships'] ?? []),
        onSaved: () {
          loadProfile(); // Refresh profile after save
        },
      ),
    );
  }

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

      await loadProfile();
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

  final List<String> indianLanguages = [
    "Assamese",
    "Bengali",
    "Bodo",
    "Dogri",
    "English",
    "Gujarati",
    "Hindi",
    "Kannada",
    "Kashmiri",
    "Konkani",
    "Maithili",
    "Malayalam",
    "Manipuri (Meitei)",
    "Marathi",
    "Nepali",
    "Odia",
    "Punjabi",
    "Sanskrit",
    "Santali",
    "Sindhi",
    "Tamil",
    "Telugu",
    "Urdu",

    // Other commonly used Indian languages
    "Awadhi",
    "Bhili/Bhilodi",
    "Bhojpuri",
    "Chhattisgarhi",
    "Garhwali",
    "Gondi",
    "Haryanvi",
    "Himachali",
    "Ho",
    "Kangri",
    "Khasi",
    "Kokborok",
    "Kumaoni",
    "Magahi",
    "Mundari",
    "Mizo",
    "Rajasthani",
    "Tulu",
    "Wagdi",

    "Other",
  ];

  String? selectedLanguage;
  final TextEditingController otherLanguageController = TextEditingController();
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Text(
                    "Complete your profile to get better matches",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
                  ),
                ],
              ),
              Text(
                "$percentage%",
                style: const TextStyle(
                  color: Color(0xff1E6BE3),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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

  Future<void> showPersonalDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PersonalDetailsBottomSheet(
        profile: Map<String, dynamic>.from(profile ?? {}),
        onSave: (updatedProfile) async {
          // Update parent profile with edited bottom-sheet data
          setState(() {
            profile = Map<String, dynamic>.from(updatedProfile);
          });

          // Send the NEW data to PUT API
          await updateProfile();

          // Reload latest data from GET API
          await loadProfile();
        },
      ),
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
    refreshData();
  }

  Future<void> refreshData() async {
    await loadProfile();

    if (!mounted) return;

    setState(() {});
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
    final career = profile?["careerPreference"] ?? {};

    preferredLocationController.text =
        career["preferredLocation"]?.toString() ?? "";

    minSalaryController.text = career["minimumSalaryLPA"]?.toString() ?? "";

    maxSalaryController.text = career["maximumSalaryLPA"]?.toString() ?? "";

    bool isLoading = false;

    List<String> selectedRoles = List<String>.from(career["jobRoles"] ?? []);

    List<String> selectedJobTypes = List<String>.from(career["jobTypes"] ?? []);

    String availability = career["availability"]?.toString() ?? "";
    // ADD THIS
    String? selectedSalaryRange;

    final Map<String, Map<String, int>> salaryRanges = {
      "1 - 10 LPA": {"minimum": 1, "maximum": 10},
      "2 - 12 LPA": {"minimum": 2, "maximum": 12},
      "3 - 15 LPA": {"minimum": 3, "maximum": 15},
      "5 - 20 LPA": {"minimum": 5, "maximum": 20},
      "10 - 25 LPA": {"minimum": 10, "maximum": 25},
      "15 - 30 LPA": {"minimum": 15, "maximum": 30},
    };
    final existingMinimum = int.tryParse(
      career["minimumSalaryLPA"]?.toString() ?? "",
    );

    final existingMaximum = int.tryParse(
      career["maximumSalaryLPA"]?.toString() ?? "",
    );
    // ADD THIS
    for (final entry in salaryRanges.entries) {
      if (entry.value["minimum"] == existingMinimum &&
          entry.value["maximum"] == existingMaximum) {
        selectedSalaryRange = entry.key;
        break;
      }
    }

    final roleController = TextEditingController();

    InputDecoration inputDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xff4D8DFF)),
        ),
      );
    }

    Widget heading(String text, {bool required = true}) {
      return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff3C4352),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (required)
                const TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    Widget chip({
      required String text,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xffEEF5FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xff4D8DFF) : Colors.grey.shade300,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: selected
                  ? const Color(0xff4D8DFF)
                  : const Color(0xff3C4352),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                width: 560,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        "Career Preferences",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 32),

                      heading("Job Role (Max 3)"),

                      const SizedBox(height: 8),

                      TextField(
                        controller: roleController,
                        decoration: inputDecoration("Search and select"),
                        onSubmitted: (value) {
                          if (value.trim().isEmpty) return;

                          if (selectedRoles.length >= 3) return;

                          if (!selectedRoles.contains(value)) {
                            setStateDialog(() {
                              selectedRoles.add(value.trim());
                            });
                          }

                          roleController.clear();
                        },
                      ),

                      if (selectedRoles.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedRoles
                                .map(
                                  (role) => Chip(
                                    label: Text(role),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () {
                                      setStateDialog(() {
                                        selectedRoles.remove(role);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                      const SizedBox(height: 28),

                      heading("Preferred Job Type"),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: chip(
                              text: "Full Time",
                              selected: selectedJobTypes.contains("Full Time"),
                              onTap: () {
                                setStateDialog(() {
                                  if (selectedJobTypes.contains("Full Time")) {
                                    selectedJobTypes.remove("Full Time");
                                  } else {
                                    selectedJobTypes.add("Full Time");
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: chip(
                              text: "Part Time",
                              selected: selectedJobTypes.contains("Part Time"),
                              onTap: () {
                                setStateDialog(() {
                                  if (selectedJobTypes.contains("Part Time")) {
                                    selectedJobTypes.remove("Part Time");
                                  } else {
                                    selectedJobTypes.add("Part Time");
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),
                      heading("Availability to work"),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            [
                              "<15 days",
                              "1 month",
                              "2 months",
                              "3 month",
                              "Serving notice period",
                            ].map((item) {
                              return SizedBox(
                                width: item == "Serving notice period"
                                    ? 210
                                    : 140,
                                child: chip(
                                  text: item,
                                  selected: availability == item,
                                  onTap: () {
                                    setStateDialog(() {
                                      availability = item;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 30),

                      heading("Preferred Location", required: false),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          icon: const Icon(
                            Icons.my_location,
                            color: Color(0xff2F7CF6),
                          ),
                          label: Text(
                            currentLocation.isNotEmpty
                                ? currentLocation
                                : "Detect Current Location",
                            style: const TextStyle(
                              color: Color(0xff2F7CF6),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xff2F7CF6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            await getCurrentLocation();
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      heading(
                        "Select Location Manually (optional)",
                        required: false,
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: preferredLocationController,
                        decoration: inputDecoration("Enter your location"),
                      ),

                      const SizedBox(height: 28),

                      heading("Salary Expectation (in ₹)"),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: selectedSalaryRange,
                        decoration: inputDecoration("Select salary range"),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        borderRadius: BorderRadius.circular(12),
                        items: salaryRanges.keys.map((range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedSalaryRange = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff7DAEF7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (selectedRoles.isEmpty) {
                                    Get.snackbar(
                                      "Required",
                                      "Please add at least one job role",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (selectedJobTypes.isEmpty) {
                                    Get.snackbar(
                                      "Required",
                                      "Please select preferred job type",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (availability.isEmpty) {
                                    Get.snackbar(
                                      "Required",
                                      "Please select availability",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (minSalaryController.text.trim().isEmpty) {
                                    Get.snackbar(
                                      "Required",
                                      "Please enter salary expectation",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  setStateDialog(() {
                                    isLoading = true;
                                  });

                                  // Convert salary values to numbers

                                  final selectedRange =
                                      salaryRanges[selectedSalaryRange!]!;

                                  final minimumSalary =
                                      selectedRange["minimum"]!;
                                  final maximumSalary =
                                      selectedRange["maximum"]!;

                                  final careerPreference = {
                                    "jobTypes": selectedJobTypes,

                                    "availability": availability,

                                    "preferredLocation":
                                        preferredLocationController.text.trim(),

                                    "minimumSalaryLPA": minimumSalary,

                                    "maximumSalaryLPA": maximumSalary,

                                    "jobRoles": selectedRoles,

                                    "preferredShift":
                                        career["preferredShift"] ?? "Day",

                                    "locationPreferenceKM":
                                        career["locationPreferenceKM"] ?? 0,

                                    "preferredStates": List<String>.from(
                                      career["preferredStates"] ?? [],
                                    ),
                                  };

                                  debugPrint(
                                    "CAREER PREFERENCE REQUEST => $careerPreference",
                                  );

                                  final success = await ProfileUpdateService()
                                      .updateSingleField(
                                        fieldName: "careerPreference",
                                        value: careerPreference,
                                      );

                                  setStateDialog(() {
                                    isLoading = false;
                                  });

                                  if (success) {
                                    setState(() {
                                      profile!["careerPreference"] =
                                          careerPreference;
                                    });

                                    Navigator.pop(context);

                                    Get.snackbar(
                                      "Success",
                                      "Career preference updated successfully",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Failed to update career preference",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
bool hasExperienceData() {
  final history = profile?["employmentHistory"];

  return history is List && history.isNotEmpty;
}

bool hasCurrentCTCData() {
  final history = profile?["employmentHistory"];

  if (history is! List || history.isEmpty) {
    return false;
  }

  final currentJob = history.cast<Map>().where(
    (job) => job["isCurrentJob"] == true,
  );

  if (currentJob.isEmpty) {
    return false;
  }

  final ctc = currentJob.first["annualSalary"];

  return ctc != null && ctc.toString().trim().isNotEmpty;
}

bool hasNoticePeriodData() {
  final availability =
      profile?["careerPreference"]?["availability"];

  return availability != null &&
      availability.toString().trim().isNotEmpty;
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

        if (!hasExperienceData())
  _detailTile(
    keyName: "experience",
    title: "Add Experience",
    subtitle: "Showcase your professional journey",
    onTap: showEmploymentSheet,
  ),

if (!hasCurrentCTCData())
  _detailTile(
    keyName: "ctc",
    title: "Add Current CTC",
    subtitle: "Get relevant salary-matched opportunities",
    onTap: () {
      final history = List<Map<String, dynamic>>.from(
        profile?["employmentHistory"] ?? [],
      );

      final currentIndex = history.indexWhere(
        (e) => e["isCurrentJob"] == true,
      );

      // Current employment does not exist
      // Allow user to add it
      if (currentIndex == -1) {
        showEmploymentSheet();
        return;
      }

      // Current employment exists but CTC is missing
      // Open current employment for editing
      showEmploymentSheet(
        employment: history[currentIndex],
        index: currentIndex,
      );
    },
  ),

if (!hasNoticePeriodData())
  _detailTile(
    keyName: "noticePeriod",
    title: "Add Notice Period",
    subtitle: "Help recruiters understand your availability",
    onTap: _showCareerDialog,
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
            _buildSchoolEducationSection(),
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
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: InkWell(
        onTap: onTap,
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
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
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

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: showPersonalDialog,
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
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            ...List.generate(internships.length, (index) {
              final item = internships[index];

              final from = DateTime.tryParse(item["duration"]?["from"] ?? "");

              final to = DateTime.tryParse(item["duration"]?["to"] ?? "");

              String durationText = "";

              if (from != null && to != null) {
                final months =
                    ((to.year - from.year) * 12) + (to.month - from.month);

                durationText =
                    "${DateFormat("MMM yyyy").format(from)} - ${DateFormat("MMM yyyy").format(to)}  •  $months months";
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["role"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item["companyName"] ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showInternshipSheet(
                              index: index,
                              internship: InternshipModel.fromJson(
                                internships[index],
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined, size: 26),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 22,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            durationText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      item["description"] ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: OutlinedButton.icon(
                onPressed: showInternshipSheet,
                icon: const Icon(Icons.add, size: 28),
                label: const Text(
                  "Add Internship",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    final projects = profile?['projects'] ?? [];

    return profileSection(
      keyName: "projects",
      title: "Projects",
      subtitle: "Showcase your work and projects",
      bgColor: const Color(0xffEEF3FF),
      stripeColor: const Color(0xff5A67F2),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            ...List.generate(projects.length, (index) {
              final item = projects[index];

              final from = DateTime.tryParse(item["duration"]?["from"] ?? "");

              final to = DateTime.tryParse(item["duration"]?["to"] ?? "");

              String duration = "";

              if (from != null && to != null) {
                final months =
                    ((to.year - from.year) * 12) + (to.month - from.month);

                duration =
                    "${DateFormat("MMM yyyy").format(from)} - ${DateFormat("MMM yyyy").format(to)}  •  $months months";
              }

              final rawSkills = item["keySkills"];

              final List<String> skills = rawSkills is List
                  ? rawSkills
                        .map((e) => e.toString().trim())
                        .where((e) => e.isNotEmpty)
                        .toList()
                  : rawSkills
                        .toString()
                        .split(",")
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["projectName"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                item["endResult"] ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 24),
                          onPressed: () {
                            showProjectSheet(project: item, index: index);
                          },
                        ),
                      ],
                    ),

                    if (duration.isNotEmpty) ...[
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              duration,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 18),

                    Text(
                      item["description"] ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 18),
if (skills.isNotEmpty) ...[
  const SizedBox(height: 18),

  const Text(
    "Skills Used",
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Color(0xff374151),
    ),
  ),

  const SizedBox(height: 10),

  Wrap(
    spacing: 10,
    runSpacing: 10,
    children: skills.map((skill) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffEEF4FF),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xffD7E3FF),
          ),
        ),
        child: Text(
          skill,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff374151),
          ),
        ),
      );
    }).toList(),
  ),
],

                    const SizedBox(height: 22),

                    if ((item["projectURL"] ?? "").toString().isNotEmpty)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xffDFE8FF),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(item["projectURL"]);

                          if (await canLaunchUrl(uri)) {
                            launchUrl(uri);
                          }
                        },
                        icon: const Icon(Icons.computer),
                        label: const Text(
                          "View Project",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  showProjectSheet();
                },
                icon: const Icon(Icons.add, size: 26),
                label: const Text(
                  "Add Project",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showProjectSheet({Map<String, dynamic>? project, int? index}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProjectBottomSheet(
        project: project,
        index: index,
        projects: List.from(profile?["projects"] ?? []),
        onSaved: () async {
          await loadProfile();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  Widget _buildProfileSummarySection() {
    final summary = (profile?["profileSummary"] ?? "").toString().trim();

    return profileSection(
      keyName: "profileSummary",
      title: "Profile Summary",
      subtitle: "Write a brief about yourself",
      bgColor: const Color(0xffF2F0FF),
      stripeColor: const Color(0xff7C4DFF),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xffFAFAFA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                summary.isEmpty ? "No profile summary added." : summary,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.8,
                  color: summary.isEmpty
                      ? Colors.grey
                      : const Color(0xff4B5563),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _showProfileSummaryDialog,
                icon: const Icon(Icons.add, size: 24, color: Color(0xff4B5563)),
                label: Text(
                  summary.isEmpty ? "Add Summary" : "Edit Summary",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff4B5563),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
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
      subtitle: "List your achievements and awards",
      bgColor: const Color(0xffFDF2F8),
      stripeColor: const Color(0xffEC4899),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            if (accomplishments.isEmpty)
              emptyBox("Add Accomplishment")
            else
              ...List.generate(accomplishments.length, (index) {
                final item = accomplishments[index];

                final validity = item["certificationValidity"] ?? {};

                String date = "";

                if (validity["month"] != null && validity["year"] != null) {
                  date = "${_monthName(validity["month"])} ${validity["year"]}";
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(18),
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
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2D3748),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${item["awards"] ?? ""}${date.isNotEmpty ? " • $date" : ""}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showAccomplishmentSheet(
                            accomplishment: accomplishments[index],
                            index: index,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Color(0xff374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  showAccomplishmentSheet();
                },
                icon: const Icon(Icons.add, size: 24, color: Color(0xff4B5563)),
                label: const Text(
                  "Add Accomplishment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff4B5563),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAccomplishmentDialog() async {
    certificationNameController.clear();
    certificationIdController.clear();
    certificationUrlController.clear();
    awardsController.clear();
    clubsController.clear();
    positionHeldController.clear();
    educationalReferenceController.clear();
    responsibilitiesController.clear();
    mediaUploadController.clear();
    certificationMonthController.clear();
    certificationYearController.clear();
    accomplishmentFromController.clear();
    accomplishmentToController.clear();

    noExpiry = false;
    isCurrent = false;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Add Accomplishment"),
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
                        labelText: "Media Upload URL",
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
                  List<dynamic> accomplishments = List.from(
                    profile?["accomplishments"] ?? [],
                  );

                  accomplishments.add({
                    "certificationName": certificationNameController.text
                        .trim(),
                    "certificationID": certificationIdController.text.trim(),
                    "certificationURL": certificationUrlController.text.trim(),
                    "awards": awardsController.text.trim(),
                    "clubs": clubsController.text.trim(),
                    "positionHeld": positionHeldController.text.trim(),
                    "educationalReference": educationalReferenceController.text
                        .trim(),
                    "responsibilities": responsibilitiesController.text.trim(),
                    "mediaUpload": mediaUploadController.text.trim(),
                    "noExpiry": noExpiry,
                    "isCurrent": isCurrent,
                    "certificationValidity": {
                      "month": certificationMonthController.text.trim(),
                      "year": certificationYearController.text.trim(),
                    },
                    "duration": {
                      "from": DateTime.parse(
                        accomplishmentFromController.text,
                      ).toIso8601String(),
                      "to": DateTime.parse(
                        accomplishmentToController.text,
                      ).toIso8601String(),
                    },
                  });

                  final success = await ProfileUpdateService().updateProfile(
                    data: {"accomplishments": accomplishments},
                  );

                  if (success) {
                    setState(() {
                      profile!["accomplishments"] = accomplishments;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Accomplishment added successfully"),
                      ),
                    );
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompetitiveExamsSection() {
    final exams = profile?["competitiveExams"] ?? [];

    return profileSection(
      keyName: "competitiveExams",
      title: "Entrance Exams",
      subtitle: "List down any entrance exams you have given",
      bgColor: const Color(0xffFFF7ED),
      stripeColor: const Color(0xffF97316),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            if (exams.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    "No entrance exams added",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              ...List.generate(exams.length, (index) {
                final item = exams[index];

                final String examName = item["examName"]?.toString() ?? "";

                final String examDate = item["examMonth"] != null
                    ? "${_monthName(item["examMonth"].toString())} ${item["examYear"]}"
                    : (item["examYear"]?.toString() ?? "");

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              examName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2F3542),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              examDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showCompetitiveExamDialog(
                            exam: exams[index],
                            index: index,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Color(0xff374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: showCompetitiveExamDialog,
                icon: const Icon(Icons.add, size: 24, color: Color(0xff4B5563)),
                label: const Text(
                  "Add Entrance Exams",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff4B5563),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showCompetitiveExamDialog({
    Map<String, dynamic>? exam,
    int? index,
  }) async {
    examNameController.text = exam?["examName"] ?? "";
    obtainedScoreController.text = exam?["obtainedScore"]?.toString() ?? "";
    maxScoreController.text = exam?["maxScore"]?.toString() ?? "";

    String? selectedYear = exam?["examYear"]?.toString();

    bool isLoading = false;

    final List<String> years = List.generate(
      DateTime.now().year - 1990 + 1,
      (index) => (DateTime.now().year - index).toString(),
    );

    InputDecoration inputDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xff4D8DFF)),
        ),
      );
    }

    Widget title(String text) {
      return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(
                  color: Color(0xff3C4352),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text: "*",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 74,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        exam == null
                            ? "Add Entrance Exam"
                            : "Edit Entrance Exam",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Competitive Exams are capturing your achievements in exams that demonstrate skills, knowledge, or qualifications for academic or professional growth.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      title("Exam Name"),

                      const SizedBox(height: 8),

                      TextField(
                        controller: examNameController,
                        decoration: inputDecoration(
                          "Search and select exam name",
                        ),
                      ),

                      const SizedBox(height: 22),

                      title("Exam Year"),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: selectedYear,
                        decoration: inputDecoration("Select exam year"),
                        items: years
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedYear = value;
                          });
                        },
                      ),

                      const SizedBox(height: 22),

                      title("Score/Percentile"),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: obtainedScoreController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: inputDecoration("Obtained"),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: TextField(
                              controller: maxScoreController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: inputDecoration("Maximum"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff7DAEF7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (examNameController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please enter exam name"),
                                      ),
                                    );
                                    return;
                                  }

                                  if (selectedYear == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please select exam year",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (obtainedScoreController.text
                                      .trim()
                                      .isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please enter obtained score",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (maxScoreController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please enter maximum score",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setStateDialog(() {
                                    isLoading = true;
                                  });

                                  List<dynamic> exams = List.from(
                                    profile?["competitiveExams"] ?? [],
                                  );

                                  final examData = {
                                    "examName": examNameController.text.trim(),
                                    "examYear": selectedYear,
                                    "obtainedScore":
                                        double.tryParse(
                                          obtainedScoreController.text,
                                        ) ??
                                        0,
                                    "maxScore":
                                        double.tryParse(
                                          maxScoreController.text,
                                        ) ??
                                        0,
                                  };

                                  if (index == null) {
                                    exams.add(examData);
                                  } else {
                                    exams[index] = examData;
                                  }

                                  final success = await ProfileUpdateService()
                                      .updateProfile(
                                        data: {"competitiveExams": exams},
                                      );

                                  setStateDialog(() {
                                    isLoading = false;
                                  });

                                  if (success) {
                                    setState(() {
                                      profile!["competitiveExams"] = exams;
                                    });

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Competitive exam added successfully",
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Failed to add competitive exam",
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmploymentHistorySection() {
    final jobs = profile?["employmentHistory"] ?? [];

    return profileSection(
      keyName: "employmentHistory",
      title: "Employment History",
      subtitle: "Add your work experience",
      bgColor: const Color(0xffFDF2F4),
      stripeColor: const Color(0xffF43F5E),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            if (jobs.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    "No employment history added",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              ...List.generate(jobs.length, (index) {
                final item = jobs[index];

                final from = DateTime.tryParse(item["duration"]?["from"] ?? "");

                final to = item["isCurrentJob"] == true
                    ? null
                    : DateTime.tryParse(item["duration"]?["to"] ?? "");

                String duration = "";

                if (from != null) {
                  duration =
                      "${DateFormat("MMM yyyy").format(from)} - ${to == null ? "Present" : DateFormat("MMM yyyy").format(to)}";

                  final years = item["workExperience"]?["years"] ?? 0;
                  final months = item["workExperience"]?["months"] ?? 0;

                  if (years > 0 || months > 0) {
                    duration +=
                        "  •  ${years > 0 ? "$years year${years > 1 ? "s" : ""}" : ""}${years > 0 && months > 0 ? " " : ""}${months > 0 ? "$months month${months > 1 ? "s" : ""}" : ""}";
                  }
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["position"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff2F3542),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item["companyName"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              showEmploymentSheet(
                                employment: jobs[index],
                                index: index,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 24,
                                color: Color(0xff374151),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (duration.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                              color: Color(0xff6B7280),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                duration,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      if ((item["description"] ?? "")
                          .toString()
                          .isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          item["description"],
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: Color(0xff6B7280),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  showEmploymentSheet();
                },
                icon: const Icon(Icons.add, size: 24, color: Color(0xff4B5563)),
                label: const Text(
                  "Add Employment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff4B5563),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showEmploymentSheet({
    Map<String, dynamic>? employment,
    int? index,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return EmploymentBottomSheet(
          initialData: employment,
          onSave: (employmentData) async {
            final List history = List.from(profile?["employmentHistory"] ?? []);

            // ============================================================
            // ONLY ONE EMPLOYMENT CAN HAVE isCurrentJob = true
            // ============================================================
            if (employmentData["isCurrentJob"] == true) {
              final bool anotherCurrentJob = history.asMap().entries.any((
                entry,
              ) {
                final int existingIndex = entry.key;

                final Map<String, dynamic> existingJob =
                    Map<String, dynamic>.from(entry.value);

                // When editing an existing job, ignore that same job.
                if (index != null && existingIndex == index) {
                  return false;
                }

                return existingJob["isCurrentJob"] == true;
              });

              if (anotherCurrentJob) {
                if (mounted) {
                  Get.snackbar(
                    "Current Employment Already Exists",
                    "Please deselect 'Currently work here' from your previous employment and update its end date first.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 6),
                  );
                }

                // IMPORTANT:
                // Do NOT auto-deselect the previous employer.
                // Do NOT save the new employment.
                return;
              }
            }

            // ============================================================
            // ADD NEW EMPLOYMENT
            // ============================================================
            if (index == null) {
              history.add(employmentData);
            }
            // ============================================================
            // UPDATE EXISTING EMPLOYMENT
            // ============================================================
            else {
              history[index] = employmentData;
            }

            // ============================================================
            // UPDATE PROFILE API
            // ============================================================
            final success = await ProfileUpdateService().updateProfile(
              data: {"employmentHistory": history},
            );

            if (success) {
              setState(() {
                profile!["employmentHistory"] = history;
              });

              if (mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      index == null
                          ? "Employment added successfully"
                          : "Employment updated successfully",
                    ),
                  ),
                );
              }
            }
          },
        );
      },
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
      child: Column(
        children: [
          if (achievements.isEmpty)
            emptyBox("Add Academic Achievement")
          else
            ...List.generate(achievements.length, (index) {
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
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${item["educationReference"] ?? ""} • ${item["receivedDuring"] ?? ""}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showAcademicAchievementDialog(index: index),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAcademicAchievementDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add Academic Achievement"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAcademicAchievementDialog({int? index}) async {
    final isEdit = index != null;

    Map<String, dynamic> item = {};

    if (isEdit) {
      item = profile!["academicAchievements"][index];
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AcademicAchievementBottomSheet(
          loading: false,
          initialData: item,
          onSave: (data) async {
            List<dynamic> achievements = List.from(
              profile?["academicAchievements"] ?? [],
            );

            if (isEdit) {
              achievements[index] = {...achievements[index], ...data};
            } else {
              achievements.add(data);
            }

            final success = await ProfileUpdateService().updateProfile(
              data: {"academicAchievements": achievements},
            );

            if (success) {
              setState(() {
                profile!["academicAchievements"] = achievements;
              });

              if (mounted) {
                //  Navigator.of(bottomSheetContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? "Academic Achievement Updated"
                          : "Academic Achievement Added",
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Future<void> showAccomplishmentSheet({
    Map<String, dynamic>? accomplishment,
    int? index,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccomplishmentBottomSheet(
        accomplishment: accomplishment,
        index: index,
        accomplishments: List.from(profile?["accomplishments"] ?? []),
        onSaved: () async {
          await loadProfile();
          setState(() {});
        },
      ),
    );
  }

  Future<void> _showProfileSummaryDialog() async {
    summaryController.text = profile?["profileSummary"] ?? "";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                width: 560,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Handle
                      Container(
                        width: 72,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        "Profile Summary",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff242833),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Your profile summary should highlight key points from your career and education, your professional interests, and the kind of career you're looking for. Write at least 50 characters (max. 1000 characters).",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Profile Summary",
                                style: TextStyle(
                                  color: Color(0xff3C4352),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "*",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: summaryController,
                        maxLines: 6,
                        maxLength: 1000,
                        onChanged: (_) {
                          setStateDialog(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Write a detailed description",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(color: Color(0xff4A90FF)),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${summaryController.text.length}/1000 characters",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xff2F7CF6),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Color(0xff2F7CF6),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff7EAFF7),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () async {
                                  profile!["profileSummary"] = summaryController
                                      .text
                                      .trim();

                                  await updateProfile();

                                  setState(() {});

                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget profileSection({
    required String keyName,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color stripeColor,
    required Widget child,
    VoidCallback? onAdd,
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
                          if (onAdd != null)
                            ElevatedButton.icon(
                              onPressed: onAdd,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text("Add"),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add Button
          const SizedBox(height: 16),

          // Education List
          if (education.isEmpty)
            emptyBox("Add Education")
          else
            Column(
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
                          showDialog(
                            context: context,

                            builder: (_) => AddEducationDialog(
                              educationData: e,

                              index: education.indexOf(e),

                              educationList: education,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AddEducationDialog(educationList: education),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Education"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolEducationSection() {
    final schoolEducation = profile?['educationTill12th'] ?? [];

    return profileSection(
      keyName: "schoolEducation",
      title: "School Education",
      subtitle: "Add your 10th and 12th qualifications",
      bgColor: const Color(0xffEAF3FF),
      stripeColor: const Color(0xff2B78F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          if (schoolEducation.isEmpty)
            emptyBox("Add 10th / 12th Education")
          else
            Column(
              children: schoolEducation.map<Widget>((e) {
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
                              e["education"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              e["examinationBoard"] ?? "",
                              style: const TextStyle(fontSize: 15),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(
                                  Icons.school,
                                  size: 18,
                                  color: Colors.grey.shade600,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  "${e["gradeType"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: Colors.grey.shade600,
                                ),

                                const SizedBox(width: 6),

                                Text("Passed : ${e["passingYear"]}"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          final refresh = await showDialog<bool>(
                            context: context,
                            builder: (_) => AddSchoolEducationDialog(
                              educationData: e,
                              index: schoolEducation.indexOf(e),
                              educationList: schoolEducation,
                            ),
                          );

                          if (refresh == true) {
                            refreshData();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add 10th / 12th"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                final refresh = await showDialog<bool>(
                  context: context,
                  builder: (_) =>
                      AddSchoolEducationDialog(educationList: schoolEducation),
                );

                if (refresh == true) {
                  refreshData();
                }
              },
            ),
          ),
        ],
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
                initialValue: proficiencyController.text.isEmpty
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
                  DropdownMenuItem(
                    value: "Professional",
                    child: Text("Professional"),
                  ),
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
              // Create a copy of the existing languages list
              List<dynamic> languages = List.from(profile?["languages"] ?? []);

              // Update the selected language
              languages[index] = {
                "language": languageController.text.trim(),
                "proficiencyLevel": proficiencyController.text.trim(),
              };

              final success = await ProfileUpdateService().updateProfile(
                data: {"languages": languages},
              );

              if (success) {
                setState(() {
                  profile!["languages"] = languages;
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Language updated successfully"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update language")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editSkillsDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SkillsBottomSheet(
          selectedSkills: List.from(profile?["keySkills"] ?? []),
          profileSummary: profile?["profileSummary"] ?? "",
          onSaved: () async {
            await loadProfile(); // Your existing profile API
            if (mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  Widget _buildSkillsSection() {
    final List skills = profile?["keySkills"] ?? [];

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
              "Skills Expert in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 18),

            if (skills.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "No Skills Added",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: skills.map<Widget>((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEEF4FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      skill["Name"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text(
                  "Edit Skills",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: _editSkillsDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editlanguagage({int? index}) async {
    String? selectedLanguageLocal;
    String? selectedProficiency;

    final List languages = List.from(profile?["languages"] ?? []);

    // EDIT MODE
    if (index != null && index >= 0 && index < languages.length) {
      final existingLanguage = Map<String, dynamic>.from(languages[index]);

      final existingLanguageName = existingLanguage["language"]?.toString();

      final existingProficiency = existingLanguage["proficiencyLevel"]
          ?.toString();

      if (indianLanguages.contains(existingLanguageName)) {
        selectedLanguageLocal = existingLanguageName;
      } else {
        selectedLanguageLocal = "Other";
        otherLanguageController.text = existingLanguageName ?? "";
      }

      selectedProficiency = existingProficiency;
    } else {
      // ADD MODE
      selectedLanguageLocal = null;
      selectedProficiency = null;
      otherLanguageController.clear();
    }

    InputDecoration inputDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xff4D8DFF)),
        ),
      );
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                width: 540,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Handle
                      Container(
                        width: 70,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        "Languages",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Languages lets you specify the languages you are proficient in, helping employers assess your communication skills and match you with roles that require specific language expertise.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Languages Spoken",
                                style: TextStyle(
                                  color: Color(0xff3C4352),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: selectedLanguageLocal,
                        decoration: inputDecoration("Select Language"),
                        isExpanded: true,
                        items: indianLanguages.map((language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedLanguageLocal = value;

                            if (value != "Other") {
                              otherLanguageController.clear();
                            }
                          });
                        },
                      ),

                      if (selectedLanguageLocal == "Other") ...[
                        const SizedBox(height: 16),

                        TextField(
                          controller: otherLanguageController,
                          textCapitalization: TextCapitalization.words,
                          decoration: inputDecoration("Enter your language"),
                        ),
                      ],

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Proficiency Level",
                                style: TextStyle(
                                  color: Color(0xff3C4352),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: selectedProficiency,
                        decoration: inputDecoration("Select proficiency level"),
                        items: const [
                          DropdownMenuItem(
                            value: "Basic",
                            child: Text("Basic"),
                          ),
                          DropdownMenuItem(
                            value: "Conversational",
                            child: Text("Conversational"),
                          ),
                          DropdownMenuItem(
                            value: "Intermediate",
                            child: Text("Intermediate"),
                          ),
                          DropdownMenuItem(
                            value: "Fluent",
                            child: Text("Fluent"),
                          ),
                          DropdownMenuItem(
                            value: "Native",
                            child: Text("Native"),
                          ),
                        ],
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedProficiency = value;
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff7DAEF7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final language = selectedLanguageLocal == "Other"
                                ? otherLanguageController.text.trim()
                                : selectedLanguageLocal;

                            if (language == null || language.isEmpty) {
                              Get.snackbar(
                                "Required",
                                "Please select a language",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (selectedProficiency == null ||
                                selectedProficiency!.isEmpty) {
                              Get.snackbar(
                                "Required",
                                "Please select proficiency level",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            final List existingLanguages = List.from(
                              profile?["languages"] ?? [],
                            );

                            final Map<String, dynamic> languageData = {
                              "language": language,
                              "proficiencyLevel": selectedProficiency,
                            };

                            if (index != null &&
                                index >= 0 &&
                                index < existingLanguages.length) {
                              // EDIT EXISTING LANGUAGE
                              existingLanguages[index] = languageData;
                            } else {
                              // ADD NEW LANGUAGE
                              existingLanguages.add(languageData);
                            }

                            final success = await updateCandiDatesdata.update(
                              updatedFields: {"languages": existingLanguages},
                            );

                            if (!mounted) return;

                            if (success) {
                              await loadProfile();

                              Navigator.pop(context);

                              Get.snackbar(
                                "Success",
                                index != null
                                    ? "Language updated successfully"
                                    : "Language added successfully",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                "Failed to update language",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },

                          child: const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
        children: [
          ...List.generate(languages.length, (index) {
            final lang = languages[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(lang['language'] ?? ""),
                subtitle: Text(lang['proficiencyLevel'] ?? ""),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editlanguagage(index: index);
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Language"),
              onPressed: _editlanguagage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerSection() {
    final career = profile?['careerPreference'] ?? {};
    debugPrint("CAREER PROFILE => $career");
    debugPrint("MIN SALARY => ${career['minimumSalaryLPA']}");
    debugPrint("MAX SALARY => ${career['maximumSalaryLPA']}");
    final List jobTypes = career['jobTypes'] ?? [];
    final List jobRoles = career['jobRoles'] ?? [];
    final List states = career['preferredStates'] ?? [];
    String? selectedSalaryRange;

    return profileSection(
      keyName: "career",
      title: "Career Preferences",
      subtitle: "Set your job preferences and expectations",
      bgColor: const Color(0xffEAF8F0),
      stripeColor: Colors.green,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Preferred Job Type
            const Text(
              "Preferred Job Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: jobTypes
                  .map<Widget>((e) => buildChip(e.toString()))
                  .toList(),
            ),

            const SizedBox(height: 20),
            const Divider(),

            /// Job Roles
            const SizedBox(height: 18),
            const Text(
              "Job Role",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: jobRoles
                  .map<Widget>((e) => buildChip(e.toString()))
                  .toList(),
            ),

            const SizedBox(height: 20),
            const Divider(),

            /// Salary
            const SizedBox(height: 18),

            const Text(
              "Expected Salary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Text(
              "₹${career['minimumSalaryLPA'] ?? 0}-${career['maximumSalaryLPA'] ?? 0} LPA",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 20),
            const Divider(),

            /// Preferred Location
            const SizedBox(height: 18),

            const Text(
              "Preferred Locations",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildChip(career["preferredLocation"] ?? "-"),
                ...states.map((e) => buildChip(e.toString())),
              ],
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: _showCareerDialog,
                icon: const Icon(Icons.edit_outlined, color: Color(0xff4B5563)),
                label: const Text(
                  "Update Preferences",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
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
                onTap: showPersonalDialog,

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
                child: infoItem(
                  Icons.location_on_outlined,
                  profile?['address']?['district'] ?? "Not Added",
                ),
              ),
              SizedBox(width: 10),

              Container(
                height: 50,
                width: 1,
                color: Colors.white.withValues(alpha: 0.4),
              ),

              Expanded(
                child: infoItem(Icons.email_outlined, profile?['email'] ?? ""),
              ),
              SizedBox(width: 10),

              Container(
                height: 50,
                width: 1,
                color: Colors.white.withValues(alpha: 0.4),
              ),

              Expanded(
                child: infoItem(
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
                      initialValue: experienceLevel.isEmpty
                          ? null
                          : experienceLevel,
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
}
