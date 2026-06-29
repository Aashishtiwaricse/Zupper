import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/ProfileScreen/JobApplicationDetailScreen.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/widgets.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/profileUpdateData/updateProfile.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class JobApplicationStatusScreen extends StatefulWidget {
  final int percentage;

  const JobApplicationStatusScreen({super.key, required this.percentage});

  @override
  State<JobApplicationStatusScreen> createState() =>
      _JobApplicationStatusScreenState();
}

class _JobApplicationStatusScreenState
    extends State<JobApplicationStatusScreen> {
  final noticePeriodController = TextEditingController();
  final minExpController = TextEditingController();
  final maxExpController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  Map<String, dynamic>? profile;
  bool isLoading = true;
  List applications = [];

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
  String experienceLevel = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
    fetchApplications();
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
      experienceLevel = data?["userExperienceLevel"] ?? "";

      minExpController.text =
          data?["minimumExperienceInYears"]?.toString() ?? "";

      maxExpController.text =
          data?["maximumExperienceInYears"]?.toString() ?? "";

      minSalaryController.text =
          data?["careerPreference"]?["minimumSalaryLPA"]?.toString() ?? "";

      maxSalaryController.text =
          data?["careerPreference"]?["maximumSalaryLPA"]?.toString() ?? "";
      isLoading = false;
    });
  }

  Future<void> fetchApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/employee/jobapplicationstatus"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Jobs Status");


        print(response.body);
        setState(() {

          applications = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "shortlisted":
        return Colors.orange;

      case "applied":
        return Colors.blue;

      case "rejected":
        return Colors.red;

      case "interview":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
     
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                 Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xff1E6BE3),
                image: DecorationImage(
                  image: AssetImage("assets/Head.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "Job Application Status",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
                _profileCompletionCard(),
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
                        profile?['careerPreference']?['preferredLocation'] ??
                            '-',
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final job = applications[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobApplicationDetailScreen(
                                job: applications[index], // Full API object
                              ),
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => ApplicationDetailScreen(
                          //       jobId: job["jobId"],
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: getStatusColor(
                                job["status"] ?? "",
                              ).withOpacity(.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 240,
                                decoration: BoxDecoration(
                                  color: getStatusColor(job["status"] ?? ""),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(22),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${job["daysSinceApplication"]}D ago",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 18),

                                      Row(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: const Icon(
                                              Icons.business,
                                              color: Colors.white,
                                            ),
                                          ),

                                          const SizedBox(width: 15),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  job["jobTitle"] ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 4),

                                                Text(
                                                  job["companyName"] ?? "",
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 18),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(job["location"] ?? ""),
                                          const Spacer(),
                                          const Icon(
                                            Icons.work_outline,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(job["experienceLevel"] ?? ""),
                                        ],
                                      ),

                                      const SizedBox(height: 18),

                                      const Divider(),

                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "Recruiter's Action",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: getStatusColor(
                                                  job["status"] ?? "",
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              job["status"] ?? "Applied",
                                              style: TextStyle(
                                                color: getStatusColor(
                                                  job["status"] ?? "",
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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

  Widget _profileCompletionCard() {
    final percentage = widget.percentage;
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
}
