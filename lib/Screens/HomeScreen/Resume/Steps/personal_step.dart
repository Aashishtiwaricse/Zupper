import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/Resume/custom_textfield.dart';

class PersonalStep extends GetView<ResumeController> {
  PersonalStep({super.key});
  final personalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.personalFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int columns = 1;

            if (constraints.maxWidth >= 1100) {
              columns = 3;
            } else if (constraints.maxWidth >= 700) {
              columns = 2;
            }

            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _field(
                  context,
                  columns,
                  CustomTextField(
                    controller: controller.fullNameController,
                    label: "Full Name",
                    hint: "John Doe",
                    validator: nameValidator,
                  ),
                ),
                _field(
                  context,
                  columns,
                  CustomTextField(
                    controller: controller.emailController,
                    label: "Email",
                    hint: "john@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: _email,
                  ),
                ),
                _field(
                  context,
                  columns,
                  CustomTextField(
                    controller: controller.phoneController,
                    label: "Phone",
                    hint: "+91 9876543210",
                    keyboardType: TextInputType.phone,
                    validator: phoneValidator,
                  ),
                ),

                _field(
                  context,
                  columns,
                  CustomTextField(
                    controller: controller.addressController,
                    label: "Location",
                    hint: "City,State,Country",
                    validator: locationValidator,
                  ),
                ),

                CustomTextField(
                  controller: controller.portfolioController,
                  label: "Website",
                  hint: "Enter website URL",
                  validator: websiteValidator,
                ),

                CustomTextField(
                  controller: controller.linkedInController,
                  label: "LinkedIn",
                  hint: "https://linkedin.com/in/username",
                  validator: linkedInValidator,
                ),

                SizedBox(
                  width: double.infinity,
                  child: CustomTextField(
                    controller: controller.summaryController,
                    label: "Professional Summary",
                    hint: "Write a short professional summary...",
                    maxLines: 6,
                    validator: summaryValidator,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
String? summaryValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Professional summary is required";
  }

  final summary = value.trim();

  if (summary.length < 30) {
    return "Summary must be at least 30 characters";
  }

  if (summary.length > 500) {
    return "Summary cannot exceed 500 characters";
  }

  // Prevent only symbols/spaces (must contain at least one letter or number)
  if (!RegExp(r'[A-Za-z0-9]').hasMatch(summary)) {
    return "Enter a valid professional summary";
  }

  // Prevent excessive spaces
  if (RegExp(r'\s{2,}').hasMatch(summary)) {
    return "Please avoid multiple consecutive spaces";
  }

  return null;
}
  Widget _field(BuildContext context, int columns, Widget child) {
    final width = MediaQuery.of(context).size.width;

    double w;

    if (columns == 1) {
      w = width - 48;
    } else if (columns == 2) {
      w = (width - 72) / 2;
    } else {
      w = (width - 96) / 3;
    }

    return SizedBox(width: w, child: child);
  }

String? phoneValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Phone number is required";
  }

  final phone = value.trim();

  // Only digits allowed
  if (!RegExp(r'^\d+$').hasMatch(phone)) {
    return "Phone number must contain only digits";
  }

  // Must be exactly 10 digits
  if (phone.length != 10) {
    return "Phone number must be 10 digits";
  }

  // Indian mobile numbers start with 6, 7, 8, or 9
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
    return "Enter a valid Indian mobile number";
  }

  return null;
}
String? nameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Name is required";
  }

  final name = value.trim();

  if (name.length < 2) {
    return "Name must be at least 2 characters";
  }

  if (name.length > 50) {
    return "Name cannot exceed 50 characters";
  }

  // Only letters, spaces, apostrophes and hyphens
  if (!RegExp(r"^[A-Za-z]+(?:[ '-][A-Za-z]+)*$").hasMatch(name)) {
    return "Enter a valid name";
  }

  // Reject repeated characters like "aaaaa", "ssss", "jjjjj"
  if (RegExp(r'(.)\1{3,}', caseSensitive: false).hasMatch(name)) {
    return "Enter a valid name";
  }

  return null;
}

  String? _email(String? value) {
    if (value == null || value.isEmpty) {
      return "Required";
    }

    if (!GetUtils.isEmail(value)) {
      return "Invalid email";
    }

    return null;
  }

  String? locationValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Location is required";
  }

  final location = value.trim();

  if (location.length < 2) {
    return "Enter a valid location";
  }

  if (location.length > 100) {
    return "Location cannot exceed 100 characters";
  }

  // Only letters, numbers, spaces, commas, periods and hyphens
  if (!RegExp(r"^[A-Za-z0-9\s,.-]+$").hasMatch(location)) {
    return "Enter a valid location";
  }

  return null;
}


String? websiteValidator(String? value) {
  if (value == null || value.trim().isEmpty) return null;

  final website = value.trim();

  final regex = RegExp(
    r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/.*)?$',
  );

  if (!regex.hasMatch(website)) {
    return "Enter website like: www.google.com";
  }

  return null;
}


String? linkedInValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null; // Optional field
  }

  final url = value.trim().toLowerCase();

  if (!url.contains("linkedin.com")) {
    return "Enter LinkedIn URL (e.g. linkedin.com/in/your-name)";
  }

  return null;
}
}
