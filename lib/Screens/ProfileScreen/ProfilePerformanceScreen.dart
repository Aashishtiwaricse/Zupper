import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuperr/Models/SimilarJobs/EmployeStats/employee_stats_model.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/widgets.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/profileUpdateData/employee_stats_service.dart';
import 'package:zuperr/Services/profileUpdateData/updateProfile.dart';

class ProfilePerformanceScreen extends StatefulWidget {
  final int percentage;

  const ProfilePerformanceScreen({super.key, required this.percentage});

  @override
  State<ProfilePerformanceScreen> createState() =>
      _ProfilePerformanceScreenState();
}

class _ProfilePerformanceScreenState extends State<ProfilePerformanceScreen> {
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
  EmployeeStatsModel? statsModel;

  bool isLoading1 = true;

  int selectedDays = 7;

  @override
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
    getStats();
  }

  Future<void> getStats() async {
    setState(() {
      isLoading = true;
    });

    statsModel = await EmployeeStatsService.getStats(selectedDays);

    setState(() {
      isLoading = false;
    });
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                        "Profile Performance",
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

            // Completion Card
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

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profile Performance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: selectedDays,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 7,
                                      child: Text("7 Days"),
                                    ),
                                    DropdownMenuItem(
                                      value: 15,
                                      child: Text("15 Days"),
                                    ),
                                    DropdownMenuItem(
                                      value: 30,
                                      child: Text("30 Days"),
                                    ),
                                  ],
                                  onChanged: (value) async {
                                    if (value == null) return;

                                    selectedDays = value;

                                    await getStats();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      buildChart(),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: Color(0xff009245),
                          ),

                          SizedBox(width: 6),

                          Text("Job Application"),

                          SizedBox(width: 20),

                          Icon(
                            Icons.circle,
                            size: 12,
                            color: Color(0xff9BE8BE),
                          ),

                          SizedBox(width: 6),

                          Text("Job Views"),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
    if (statsModel == null) {
      return const SizedBox();
    }

    final data = statsModel!.data;

    double maxY = 10;

    for (var e in data) {
      if (e.jobsViewed > maxY) maxY = e.jobsViewed.toDouble();
      if (e.jobsApplied > maxY) maxY = e.jobsApplied.toDouble();
    }

    maxY += 100;

    double chartWidth;

    if (selectedDays == 7) {
      chartWidth = MediaQuery.of(context).size.width - 40;
    } else if (selectedDays == 15) {
      chartWidth = data.length * 45;
    } else {
      chartWidth = data.length * 50;
    }

    return SizedBox(
      width: chartWidth, // 7=315, 15=675, 30=1350

      height: 320,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Padding(
          padding: const EdgeInsets.only(left: 10,top: 5),
          child: SizedBox(
            width: chartWidth,
          
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceEvenly,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
          
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
          
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: maxY <= 10 ? 2 : (maxY / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
          
                        if (index >= data.length) {
                          return const SizedBox();
                        }
          
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 6,
                          child: Text(
                            "${index + 1}D",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          
                barGroups: List.generate(data.length, (index) {
                  final item = data[index];
          
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: item.jobsApplied.toDouble(),
                        width: 8,
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff009245),
                      ),
                      BarChartRodData(
                        toY: item.jobsViewed.toDouble(),
                        width: 8,
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff9BE8BE),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
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
