import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/profile_bottom_sheet.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/Projects/profile_primary_button.dart';



class EmploymentBottomSheet extends StatefulWidget {
  const EmploymentBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
    this.loading = false,
  });

  final Map<String, dynamic>? initialData;
  final bool loading;

  final Future<void> Function(Map<String, dynamic>) onSave;

  @override
  State<EmploymentBottomSheet> createState() =>
      _EmploymentBottomSheetState();
}

class _EmploymentBottomSheetState
    extends State<EmploymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final companyController = TextEditingController();

  final designationController = TextEditingController();

  final salaryController = TextEditingController();

  final achievementController = TextEditingController();

  final descriptionController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  bool isCurrentJob = false;

  int selectedYears = 0;
  int selectedMonths = 0;

  @override
  void initState() {
    super.initState();

    final employment = widget.initialData;

    if (employment == null) return;

    companyController.text =
        employment["companyName"] ?? "";

    designationController.text =
        employment["position"] ?? "";

    salaryController.text =
        employment["annualSalary"]?.toString() ?? "";

    achievementController.text =
        employment["keyAchievements"] ?? "";

    descriptionController.text =
        employment["description"] ?? "";

    isCurrentJob =
        employment["isCurrentJob"] ?? false;

    final work =
        employment["workExperience"] ?? {};

    selectedYears =
        work["years"] ?? 0;

    selectedMonths =
        work["months"] ?? 0;

    final duration =
        employment["duration"] ?? {};

    if (duration["from"] != null) {
      fromDate =
          DateTime.parse(duration["from"]);
    }

    if (duration["to"] != null) {
      toDate =
          DateTime.parse(duration["to"]);
    }
  }

  @override
  void dispose() {
    companyController.dispose();
    designationController.dispose();
    salaryController.dispose();
    achievementController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return "MM/YYYY";
    }

    return DateFormat("MM/yyyy").format(value);
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      fromDate = picked;
    });
  }

  Future<void> _pickToDate() async {
    if (isCurrentJob) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      toDate = picked;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (fromDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select From Date"),
        ),
      );
      return;
    }

    if (!isCurrentJob && toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select To Date"),
        ),
      );
      return;
    }

    await widget.onSave({
      "companyName": companyController.text.trim(),

      "position": designationController.text.trim(),

      "annualSalary": salaryController.text.trim(),

      "keyAchievements":
          achievementController.text.trim(),

      "description":
          descriptionController.text.trim(),

      "isCurrentJob": isCurrentJob,

      "workExperience": {
        "years": selectedYears,
        "months": selectedMonths,
      },

      "duration": {
        "from": fromDate!.toIso8601String(),
        "to": isCurrentJob
            ? null
            : toDate!.toIso8601String(),
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBottomSheet(
title: widget.initialData == null
    ? "Add Employment"
    : "Edit Employment",
      subtitle:
          "Employment History is detailing your professional journey by listing your roles, responsibilities and achievements.",
      bottomButton: ProfilePrimaryButton(
  title: widget.initialData == null
      ? "Add Employment"
      : "Save Changes",
  loading: widget.loading,
  onPressed: _save,
),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
const Text(
  "Total Work Experience",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 12),

Row(
  children: [
    Expanded(
      child: DropdownButtonFormField<int>(
        initialValue: selectedMonths,
        decoration: const InputDecoration(
          labelText: "Months",
          border: OutlineInputBorder(),
        ),
        items: List.generate(
          12,
          (index) => DropdownMenuItem(
            value: index,
            child: Text("$index"),
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedMonths = value!;
          });
        },
      ),
    ),

    const SizedBox(width: 16),

    Expanded(
      child: DropdownButtonFormField<int>(
        initialValue: selectedYears,
        decoration: const InputDecoration(
          labelText: "Years",
          border: OutlineInputBorder(),
        ),
        items: List.generate(
          41,
          (index) => DropdownMenuItem(
            value: index,
            child: Text("$index"),
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedYears = value!;
          });
        },
      ),
    ),
  ],
),

const SizedBox(height: 24),
const Text(
  "Company",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 10),

TextFormField(
  controller: companyController,
  textInputAction: TextInputAction.next,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter company name";
    }
    return null;
  },
  decoration: InputDecoration(
    hintText: "Search and select company",
    prefixIcon: const Icon(Icons.business_outlined),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xffD9DDE3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xff2563EB),
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
  ),
),

const SizedBox(height: 24),

const Text(
  "Job Title",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 10),

TextFormField(
  controller: designationController,
  textInputAction: TextInputAction.next,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter job title";
    }
    return null;
  },
  decoration: InputDecoration(
    hintText: "Enter job title/position held",
    prefixIcon: const Icon(Icons.work_outline),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xffD9DDE3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xff2563EB),
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
  ),
),

const SizedBox(height: 24),

const Text(
  "Employment Duration",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 10),

Row(
  children: [
    Expanded(
      child: InkWell(
        onTap: _pickFromDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffD9DDE3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _formatDate(fromDate),
                  style: TextStyle(
                    color: fromDate == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(width: 16),

    const Text(
      "To",
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),

    const SizedBox(width: 16),

    Expanded(
      child: InkWell(
        onTap: isCurrentJob ? null : _pickToDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isCurrentJob
                ? Colors.grey.shade100
                : Colors.white,
            border: Border.all(
              color: const Color(0xffD9DDE3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCurrentJob
                      ? "Present"
                      : _formatDate(toDate),
                  style: TextStyle(
                    color: isCurrentJob
                        ? Colors.grey
                        : (toDate == null
                            ? Colors.grey
                            : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 12),

CheckboxListTile(
  value: isCurrentJob,
  contentPadding: EdgeInsets.zero,
  controlAffinity: ListTileControlAffinity.leading,
  title: const Text(
    "I currently work here",
    style: TextStyle(fontSize: 15),
  ),
  onChanged: (value) {
    setState(() {
      isCurrentJob = value ?? false;

      if (isCurrentJob) {
        toDate = null;
      }
    });
  },
),

const SizedBox(height: 24),
const Text(
  "Key Achievements",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 10),

TextFormField(
  controller: achievementController,
  maxLines: 3,
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    hintText: "Describe your key achievements",
    alignLabelWithHint: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xffD9DDE3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xff2563EB),
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.all(16),
  ),
),

const SizedBox(height: 24),

const Text(
  "Annual Salary",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 10),

TextFormField(
  controller: salaryController,
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter annual salary";
    }
    return null;
  },
  decoration: InputDecoration(
    prefixText: "₹ ",
    hintText: "Enter annual salary",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xffD9DDE3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xff2563EB),
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
  ),
),

const SizedBox(height: 24),

const Text(
  "Role Description",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),

const SizedBox(height: 10),

TextFormField(
  controller: descriptionController,
  maxLines: 6,
  maxLength: 1000,
  decoration: InputDecoration(
    hintText: "Describe your responsibilities and work",
    alignLabelWithHint: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xffD9DDE3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xff2563EB),
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.all(16),
    counterText: "",
  ),
),

Align(
  alignment: Alignment.centerRight,
  child: Text(
    "${descriptionController.text.length}/1000 characters",
    style: const TextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),
  ),
),

const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}