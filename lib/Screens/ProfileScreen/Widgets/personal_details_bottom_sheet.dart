import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zuperr/Screens/ProfileScreen/Widgets/StepIndicator.dart';
import 'dart:async';

import 'package:zuperr/Utils/AppConstants.dart';





class PersonalDetailsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> profile;
final Future Function(Map<String, dynamic> updatedProfile) onSave;
  const PersonalDetailsBottomSheet({
    super.key,
    required this.profile,
    required this.onSave,
  });

  @override
  State<PersonalDetailsBottomSheet> createState() =>
      _PersonalDetailsBottomSheetState();
}

class _PersonalDetailsBottomSheetState
    extends State<PersonalDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xff1667F2);
  static const Color borderColor = Color(0xffE5E7EB);

  int currentStep = 1;

  Timer? _emailDebounce;
  Timer? _phoneDebounce;

  bool isCheckingEmail = false;
  bool? isEmailAvailable;
  String emailMessage = "";

  bool isCheckingPhone = false;
  bool? isPhoneAvailable;
  String phoneMessage = "";

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController dobController;

  late final TextEditingController emailController;
  late final TextEditingController mobileController;

  late final TextEditingController noticeController;
  late final TextEditingController minExpController;
  late final TextEditingController maxExpController;

  late final TextEditingController currentAddressController;
  late final TextEditingController currentLandmarkController;
  late final TextEditingController currentPincodeController;

  late final TextEditingController permanentAddressController;
  late final TextEditingController permanentLandmarkController;
  late final TextEditingController permanentPincodeController;


  String gender = "";
  String maritalStatus = "";
  String experienceLevel = "";

  String currentDistrict = "";
  String currentState = "";
  String currentCountry = "";

  String permanentDistrict = "";
  String permanentState = "";
  String permanentCountry = "";

  bool sameAsCurrent = true;
  @override
void initState() {
  super.initState();

  firstNameController = TextEditingController(
    text: widget.profile["firstname"]?.toString() ?? "",
  );

  lastNameController = TextEditingController(
    text: widget.profile["lastname"]?.toString() ?? "",
  );

  emailController = TextEditingController(
    text: widget.profile["email"]?.toString() ?? "",
  );

  mobileController = TextEditingController(
    text: widget.profile["mobilenumber"]?.toString() ?? "",
  );

  noticeController = TextEditingController(
    text: widget.profile["noticePeriod"]?.toString() ?? "",
  );

  minExpController = TextEditingController(
    text: widget.profile["minimumExperienceInYears"]?.toString() ?? "",
  );

  maxExpController = TextEditingController(
    text: widget.profile["maximumExperienceInYears"]?.toString() ?? "",
  );

  dobController = TextEditingController(
    text: widget.profile["dateOfBirth"] != null
        ? widget.profile["dateOfBirth"].toString().substring(0, 10)
        : "",
  );

  gender = widget.profile["gender"]?.toString() ?? "";
  maritalStatus = widget.profile["maritalStatus"]?.toString() ?? "";
  experienceLevel =
      widget.profile["userExperienceLevel"]?.toString() ?? "";

  final address = widget.profile["address"] ?? {};

  currentAddressController = TextEditingController(
    text: address["line1"]?.toString() ?? "",
  );

  currentLandmarkController = TextEditingController(
    text: address["landmark"]?.toString() ?? "",
  );

  currentPincodeController = TextEditingController(
    text: address["pincode"]?.toString() ?? "",
  );

  currentDistrict = address["district"]?.toString() ?? "";
  currentState = address["state"]?.toString() ?? "";
  currentCountry = address["country"]?.toString() ?? "";

  final permanent = widget.profile["permanentAddress"] ?? {};

  permanentAddressController = TextEditingController(
    text: permanent["line1"]?.toString() ?? "",
  );

  permanentLandmarkController = TextEditingController(
    text: permanent["landmark"]?.toString() ?? "",
  );

  permanentPincodeController = TextEditingController(
    text: permanent["pincode"]?.toString() ?? "",
  );

  permanentDistrict = permanent["district"]?.toString() ?? "";
  permanentState = permanent["state"]?.toString() ?? "";
  permanentCountry = permanent["country"]?.toString() ?? "";

  sameAsCurrent =
      !(widget.profile["hasPermanentAddress"] ?? false);

  emailController.addListener(_onEmailChanged);
  mobileController.addListener(_onPhoneChanged);
}
void _onPhoneChanged() {
  final phone = mobileController.text.trim();

  _phoneDebounce?.cancel();

  if (phone.length != 10) {
    setState(() {
      isCheckingPhone = false;
      isPhoneAvailable = null;
      phoneMessage = "";
    });
    return;
  }

  _phoneDebounce = Timer(
    const Duration(milliseconds: 600),
    () => checkPhoneAvailability(phone),
  );
}
InputDecoration inputDecoration(
  String hint, {
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xff98A2B3),
      fontSize: 14,
    ),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xffE4E7EC),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xff1667F2),
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    ),
  );
}

void _onEmailChanged() {
  final email = emailController.text.trim();

  _emailDebounce?.cancel();

  if (email.isEmpty) {
    setState(() {
      isCheckingEmail = false;
      isEmailAvailable = null;
      emailMessage = "";
    });
    return;
  }



  _emailDebounce = Timer(
    const Duration(milliseconds: 600),
    () => checkEmailAvailability(email),
  );
}

Future<void> checkEmailAvailability(String email) async {
  if (!email.contains("@")) return;

  setState(() {
    isCheckingEmail = true;
    isEmailAvailable = null;
  });

  try {
    final response = await Dio().get(
      "${ApiConstants.baseUrl}/api/employee/check-availability",
      queryParameters: {
        "field": "email",
        "value": email,
      },
    );

    setState(() {
      isCheckingEmail = false;

      isEmailAvailable = response.data["available"] == true;

      emailMessage = isEmailAvailable!
          ? "Email is available"
          : "Email already exists";
    });
  } catch (e) {
    setState(() {
      isCheckingEmail = false;
      isEmailAvailable = false;
      emailMessage = "Unable to verify email";
    });
  }
}
Future<void> checkPhoneAvailability(String phone) async {
  if (phone.length != 10) return;

  setState(() {
    isCheckingPhone = true;
    isPhoneAvailable = null;
  });

  try {
    final response = await Dio().get(
      "${ApiConstants.baseUrl}/api/employee/check-availability",
      queryParameters: {
        "field": "phone",
        "value": phone,
      },
    );

    setState(() {
      isCheckingPhone = false;

      isPhoneAvailable = response.data["available"] == true;

      phoneMessage = isPhoneAvailable!
          ? "Phone number is available"
          : "Phone number already exists";
    });
  } catch (e) {
    setState(() {
      isCheckingPhone = false;
      isPhoneAvailable = false;
      phoneMessage = "Unable to verify phone number";
    });
  }
}
@override
void dispose() {
  _emailDebounce?.cancel();
  _phoneDebounce?.cancel();

  firstNameController.dispose();
  lastNameController.dispose();
  dobController.dispose();

  emailController.dispose();
  mobileController.dispose();

  noticeController.dispose();
  minExpController.dispose();
  maxExpController.dispose();

  currentAddressController.dispose();
  currentLandmarkController.dispose();
  currentPincodeController.dispose();

  permanentAddressController.dispose();
  permanentLandmarkController.dispose();
  permanentPincodeController.dispose();

  super.dispose();
}
Future<void> _saveProfile() async {
  widget.profile["firstname"] = firstNameController.text.trim();
  widget.profile["lastname"] = lastNameController.text.trim();
  widget.profile["dateOfBirth"] = dobController.text;

  widget.profile["gender"] = gender;
  widget.profile["maritalStatus"] = maritalStatus;

  widget.profile["email"] = emailController.text.trim();
  widget.profile["mobilenumber"] = mobileController.text.trim();

  widget.profile["noticePeriod"] = noticeController.text.trim();
  widget.profile["userExperienceLevel"] = experienceLevel;

  widget.profile["minimumExperienceInYears"] =
      int.tryParse(minExpController.text) ?? 0;

  widget.profile["maximumExperienceInYears"] =
      int.tryParse(maxExpController.text) ?? 0;

  widget.profile["address"] = {
    "line1": currentAddressController.text.trim(),
    "landmark": currentLandmarkController.text.trim(),
    "district": currentDistrict,
    "state": currentState,
    "country": currentCountry,
    "pincode": currentPincodeController.text.trim(),
  };

  widget.profile["permanentAddress"] = {
    "line1": permanentAddressController.text.trim(),
    "landmark": permanentLandmarkController.text.trim(),
    "district": permanentDistrict,
    "state": permanentState,
    "country": permanentCountry,
    "pincode": permanentPincodeController.text.trim(),
  };

  widget.profile["hasPermanentAddress"] = !sameAsCurrent;

 await widget.onSave(widget.profile);

if (mounted) {
  Navigator.pop(context);
}
}
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Container(
    height: size.height * .90,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
    ),
    child: SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Drag Handle
            Container(
              width: 70,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Personal details help us create your professional profile. "
                "Please complete the information below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  currentStep == 1
                      ? "Personal Information"
                      : currentStep == 2
                          ? "Contact Information"
                          : "Address Information",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepIndicator(
                currentStep: currentStep,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: SingleChildScrollView(
                  key: ValueKey(currentStep),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: currentStep == 1
                      ? _personalPage()
                      : currentStep == 2
                          ? _contactPage()
                          : _addressPage(),
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (currentStep == 1) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              currentStep--;
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          side: const BorderSide(
                            color: primaryBlue,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (currentStep < 3) {
                            setState(() {
                              currentStep++;
                            });
                            return;
                          }

                          await _saveProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryBlue,
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentStep == 3 ? "Save" : "Next",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  
}
InputDecoration emailInputDecoration({
  required String hint,
  Widget? suffix,
  bool? available,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xff98A2B3),
      fontSize: 14,
    ),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: available == null
            ? const Color(0xffE4E7EC)
            : available
                ? Colors.green
                : Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: available == null
            ? const Color(0xff1667F2)
            : available
                ? Colors.green
                : Colors.red,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    ),
  );
}

Widget _personalPage() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "First Name",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),

      TextFormField(
        controller: firstNameController,
        decoration: inputDecoration("Enter First Name"),
      ),

      const SizedBox(height: 18),

      const Text(
        "Last Name",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),

      TextFormField(
        controller: lastNameController,
        decoration: inputDecoration("Enter Last Name"),
      ),

      const SizedBox(height: 18),

      const Text(
        "Date of Birth",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),

      TextFormField(
        controller: dobController,
        readOnly: true,
        decoration: inputDecoration(
          "Select DOB",
          suffix: const Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: Colors.grey,
          ),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );

          if (picked != null) {
            dobController.text =
                picked.toIso8601String().substring(0, 10);
          }
        },
      ),

      const SizedBox(height: 18),

      const Text(
        "Gender",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),

      DropdownButtonFormField<String>(
        initialValue: gender.isEmpty ? null : gender,
        decoration: inputDecoration("Select Gender"),
        items: const [
          DropdownMenuItem(
            value: "Male",
            child: Text("Male"),
          ),
          DropdownMenuItem(
            value: "Female",
            child: Text("Female"),
          ),
          DropdownMenuItem(
            value: "Other",
            child: Text("Other"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            gender = value ?? "";
          });
        },
      ),

      const SizedBox(height: 20),

      const Text(
        "Relationship Status",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 10),

      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _relationshipTile("Single"),
            Divider(height: 1),
            _relationshipTile("Married"),
            Divider(height: 1),
            _relationshipTile("Divorced"),
          ],
        ),
      ),

      const SizedBox(height: 30),
    ],
  );
}
Widget _relationshipTile(String value) {
  return RadioListTile<String>(
    value: value,
    groupValue: maritalStatus,
    activeColor: primaryBlue,
    dense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    title: Text(
      value,
      style: const TextStyle(
        fontSize: 15,
      ),
    ),
    onChanged: (v) {
      setState(() {
        maritalStatus = v!;
      });
    },
  );
}
Widget _contactPage() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Email Address",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),

      TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: emailInputDecoration(
          hint: "Enter Email Address",
          available: isEmailAvailable,
          suffix: isCheckingEmail
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : isEmailAvailable == null
                  ? null
                  : Icon(
                      isEmailAvailable!
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: isEmailAvailable!
                          ? Colors.green
                          : Colors.red,
                    ),
        ),
      ),

      if (emailMessage.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            emailMessage,
            style: TextStyle(
              color: isEmailAvailable == true
                  ? Colors.green
                  : Colors.red,
              fontSize: 13,
            ),
          ),
        ),

      const SizedBox(height: 20),

      const Text(
        "Phone Number",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 8),

      TextFormField(
        controller: mobileController,
        keyboardType: TextInputType.phone,
        decoration: emailInputDecoration(
          hint: "Enter Phone Number",
          available: isPhoneAvailable,
          suffix: isCheckingPhone
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : isPhoneAvailable == null
                  ? null
                  : Icon(
                      isPhoneAvailable!
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: isPhoneAvailable!
                          ? Colors.green
                          : Colors.red,
                    ),
        ),
      ),

      if (phoneMessage.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            phoneMessage,
            style: TextStyle(
              color: isPhoneAvailable == true
                  ? Colors.green
                  : Colors.red,
              fontSize: 13,
            ),
          ),
        ),


     


     
    ],
  );
}
Widget _addressPage() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Current Address",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      const SizedBox(height: 18),

      Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: currentDistrict,
              decoration: inputDecoration("District"),
              onChanged: (v) => currentDistrict = v,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: TextFormField(
              initialValue: currentState,
              decoration: inputDecoration("State"),
              onChanged: (v) => currentState = v,
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),

      TextFormField(
        initialValue: currentCountry,
        decoration: inputDecoration("Country"),
        onChanged: (v) => currentCountry = v,
      ),

      const SizedBox(height: 16),

      TextFormField(
        controller: currentAddressController,
        maxLines: 2,
        decoration: inputDecoration("Address Line"),
      ),

      const SizedBox(height: 16),

      TextFormField(
        controller: currentLandmarkController,
        decoration: inputDecoration("Landmark / Area / Road"),
      ),

      const SizedBox(height: 16),

      TextFormField(
        controller: currentPincodeController,
        keyboardType: TextInputType.number,
        decoration: inputDecoration("Pincode"),
      ),

      const SizedBox(height: 20),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: CheckboxListTile(
          value: sameAsCurrent,
          activeColor: primaryBlue,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8),
          title: const Text(
            "Permanent address is same as current",
            style: TextStyle(fontSize: 14),
          ),
          onChanged: (v) {
            setState(() {
              sameAsCurrent = v!;

              if (sameAsCurrent) {
                permanentAddressController.text =
                    currentAddressController.text;

                permanentLandmarkController.text =
                    currentLandmarkController.text;

                permanentPincodeController.text =
                    currentPincodeController.text;

                permanentDistrict = currentDistrict;
                permanentState = currentState;
                permanentCountry = currentCountry;
              }
            });
          },
        ),
      ),

      if (!sameAsCurrent) ...[
        const SizedBox(height: 24),

        const Text(
          "Permanent Address",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: permanentDistrict,
                decoration: inputDecoration("District"),
                onChanged: (v) => permanentDistrict = v,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: TextFormField(
                initialValue: permanentState,
                decoration: inputDecoration("State"),
                onChanged: (v) => permanentState = v,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        TextFormField(
          initialValue: permanentCountry,
          decoration: inputDecoration("Country"),
          onChanged: (v) => permanentCountry = v,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: permanentAddressController,
          maxLines: 2,
          decoration: inputDecoration("Address Line"),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: permanentLandmarkController,
          decoration: inputDecoration("Landmark / Area / Road"),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: permanentPincodeController,
          keyboardType: TextInputType.number,
          decoration: inputDecoration("Pincode"),
        ),
      ],

      const SizedBox(height: 30),
    ],
  );
}

Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xff344054),
      ),
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  int maxLines = 1,
  Widget? suffix,
  VoidCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    readOnly: readOnly,
    maxLines: maxLines,
    onTap: onTap,
    decoration: inputDecoration(
      hint,
      suffix: suffix,
    ),
  );
}
Widget _buildDropdown({
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
  required String hint,
}) {
  return DropdownButtonFormField<String>(
    initialValue: value.isEmpty ? null : value,
    decoration: inputDecoration(hint),
    items: items
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
        .toList(),
    onChanged: onChanged,
  );
}
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

    }



// class PersonalDetailsBottomSheet extends StatefulWidget {
//   final Map<String, dynamic> profile;
//   final Future<void> Function() onSave;

//   const PersonalDetailsBottomSheet({
//     super.key,
//     required this.profile,
//     required this.onSave,
//   });

//   @override
//   State<PersonalDetailsBottomSheet> createState() =>
//       _PersonalDetailsBottomSheetState();
// }

// class _PersonalDetailsBottomSheetState
//     extends State<PersonalDetailsBottomSheet> {
//   final emailController = TextEditingController();

//   Timer? _debounce;

//   bool isCheckingEmail = false;
//   bool? isEmailAvailable;
//   String emailMessage = "";
//   int currentStep = 1;

//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController mobileController;
//   late TextEditingController noticeController;
//   late TextEditingController minExpController;
//   late TextEditingController maxExpController;
//   late TextEditingController dobController;
//   late TextEditingController currentAddressController;
//   late TextEditingController currentLandmarkController;
//   late TextEditingController currentPincodeController;
//   late TextEditingController permanentAddressController;
//   late TextEditingController permanentLandmarkController;
//   late TextEditingController permanentPincodeController;
//   String experienceLevel = "";
//   String currentDistrict = "";
//   String currentState = "";
//   String currentCountry = "";

//   String permanentDistrict = "";
//   String permanentState = "";
//   String permanentCountry = "";

//   bool sameAsCurrent = true;

//   String gender = "";
//   String maritalStatus = "";

//   InputDecoration inputDecoration(String hint, {Widget? suffix}) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,

//       suffixIcon: suffix,

//       contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Color(0xff1667F2)),
//       ),
//     );
//   }

//   InputDecoration emailInputDecoration({required String hint, Widget? suffix}) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       suffixIcon: suffix,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: isEmailAvailable == null
//               ? Colors.grey.shade300
//               : isEmailAvailable!
//               ? Colors.green
//               : Colors.red,
//           width: 1.5,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: isEmailAvailable == null
//               ? const Color(0xff1667F2)
//               : isEmailAvailable!
//               ? Colors.green
//               : Colors.red,
//           width: 2,
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//     firstNameController = TextEditingController(
//       text: widget.profile["firstname"]?.toString() ?? "",
//     );

//     lastNameController = TextEditingController(
//       text: widget.profile["lastname"]?.toString() ?? "",
//     );

//     mobileController = TextEditingController(
//       text: widget.profile["mobilenumber"]?.toString() ?? "",
//     );

//     noticeController = TextEditingController(
//       text: widget.profile["noticePeriod"]?.toString() ?? "",
//     );

//     minExpController = TextEditingController(
//       text: widget.profile["minimumExperienceInYears"]?.toString() ?? "",
//     );

//     maxExpController = TextEditingController(
//       text: widget.profile["maximumExperienceInYears"]?.toString() ?? "",
//     );

//     dobController = TextEditingController(
//       text: widget.profile["dateOfBirth"] != null
//           ? widget.profile["dateOfBirth"].toString().substring(0, 10)
//           : "",
//     );

//     // Personal
//     gender = widget.profile["gender"]?.toString() ?? "";
//     maritalStatus = widget.profile["maritalStatus"]?.toString() ?? "";
//     experienceLevel = widget.profile["userExperienceLevel"]?.toString() ?? "";

//     // Current Address
//     final address = widget.profile["address"] ?? {};

//     currentAddressController = TextEditingController(
//       text: address["line1"]?.toString() ?? "",
//     );

//     currentLandmarkController = TextEditingController(
//       text: address["landmark"]?.toString() ?? "",
//     );

//     currentPincodeController = TextEditingController(
//       text: address["pincode"]?.toString() ?? "",
//     );

//     currentDistrict = address["district"]?.toString() ?? "";
//     currentState = address["state"]?.toString() ?? "";
//     currentCountry = address["country"]?.toString() ?? "";

//     // Permanent Address
//     final permanentAddress = widget.profile["permanentAddress"] ?? {};

//     permanentAddressController = TextEditingController(
//       text: permanentAddress["line1"]?.toString() ?? "",
//     );

//     permanentLandmarkController = TextEditingController(
//       text: permanentAddress["landmark"]?.toString() ?? "",
//     );

//     permanentPincodeController = TextEditingController(
//       text: permanentAddress["pincode"]?.toString() ?? "",
//     );

//     permanentDistrict = permanentAddress["district"]?.toString() ?? "";
//     permanentState = permanentAddress["state"]?.toString() ?? "";
//     permanentCountry = permanentAddress["country"]?.toString() ?? "";

//     sameAsCurrent = !(widget.profile["hasPermanentAddress"] ?? false);
//     emailController.addListener(_onEmailChanged);
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     emailController.dispose();
//     super.dispose();
//   }

//   void _onEmailChanged() {
//     final email = emailController.text.trim();

//     _debounce?.cancel();

//     if (email.isEmpty) {
//       setState(() {
//         isCheckingEmail = false;
//         isEmailAvailable = null;
//         emailMessage = "";
//       });
//       return;
//     }

//     _debounce = Timer(const Duration(milliseconds: 600), () {
//       checkEmailAvailability(email);
//     });
//   }

//   Future<void> checkEmailAvailability(String email) async {
//     if (!email.contains("@")) return;

//     setState(() {
//       isCheckingEmail = true;
//       isEmailAvailable = null;
//     });

//     try {
//       final response = await Dio().get(
//         "${ApiConstants.baseUrl}/api/employee/check-availability",
//         queryParameters: {"field": "email", "value": email},
//       );

//       setState(() {
//         isCheckingEmail = false;

//         // Adjust according to your API response
//         isEmailAvailable = response.data["available"];

//         emailMessage = isEmailAvailable!
//             ? "Email is available"
//             : "Email already exists";
//       });
//     } catch (e) {
//       setState(() {
//         isCheckingEmail = false;
//         isEmailAvailable = false;
//         emailMessage = "Unable to verify email";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * .92,

//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),

//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 22),

//           child: Column(
//             children: [
//               const SizedBox(height: 12),

//               Container(
//                 width: 80,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),

//               const SizedBox(height: 22),

//               const Text(
//                 "Personal Details",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
//               ),

//               const SizedBox(height: 12),

//               const Text(
//                 "Personal Details are capturing essential information like name,\ncontact details, and demographics to create a complete and\npersonalized profile.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
//               ),

//               const SizedBox(height: 25),

//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   currentStep == 1
//                       ? "Personal Information"
//                       : currentStep == 2
//                       ? "Contact Information"
//                       : "Address",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     color: Color(0xff1667F2),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 25),

//               StepIndicator(currentStep: currentStep),

//               const SizedBox(height: 25),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Builder(
//                     builder: (_) {
//                       switch (currentStep) {
//                         case 1:
//                           return _personalPage();

//                         case 2:
//                           return _contactPage();

//                         case 3:
//                           return _addressPage();

//                         default:
//                           return const SizedBox();
//                       }
//                     },
//                   ),
//                 ),
//               ),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         if (currentStep == 1) {
//                           Navigator.pop(context); // Close bottom sheet
//                           return;
//                         }

//                         setState(() {
//                           currentStep--;
//                         });
//                         () async {
//                           if (currentStep < 3) {
//                             setState(() {
//                               currentStep++;
//                             });
//                             return;
//                           }

//                           widget.profile["firstname"] = firstNameController.text
//                               .trim();
//                           widget.profile["lastname"] = lastNameController.text
//                               .trim();
//                           widget.profile["dateOfBirth"] = dobController.text;
//                           widget.profile["gender"] = gender;
//                           widget.profile["maritalStatus"] = maritalStatus;

//                           widget.profile["mobilenumber"] = mobileController.text
//                               .trim();
//                           widget.profile["noticePeriod"] = noticeController.text
//                               .trim();
//                           widget.profile["userExperienceLevel"] =
//                               experienceLevel;

//                           widget.profile["minimumExperienceInYears"] =
//                               int.tryParse(minExpController.text) ?? 0;

//                           widget.profile["maximumExperienceInYears"] =
//                               int.tryParse(maxExpController.text) ?? 0;

//                           widget.profile["address"] = {
//                             "line1": currentAddressController.text,
//                             "landmark": currentLandmarkController.text,
//                             "district": currentDistrict,
//                             "state": currentState,
//                             "country": currentCountry,
//                             "pincode": currentPincodeController.text,
//                           };

//                           widget.profile["permanentAddress"] = {
//                             "line1": permanentAddressController.text,
//                             "landmark": permanentLandmarkController.text,
//                             "district": permanentDistrict,
//                             "state": permanentState,
//                             "country": permanentCountry,
//                             "pincode": permanentPincodeController.text,
//                           };

//                           widget.profile["hasPermanentAddress"] =
//                               !sameAsCurrent;

//                           await widget.onSave();

//                           if (mounted) Navigator.pop(context);
//                         };
//                       },
//                       style: OutlinedButton.styleFrom(
//                         minimumSize: const Size.fromHeight(55),
//                         side: const BorderSide(color: Color(0xff1667F2)),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text(
//                         "Back",
//                         style: TextStyle(
//                           color: Color(0xff1667F2),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 15),

//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // Step 1 -> Step 2
//                         if (currentStep == 1) {
//                           setState(() {
//                             currentStep = 2;
//                           });
//                           return;
//                         }

//                         // Step 2 -> Step 3
//                         if (currentStep == 2) {
//                           setState(() {
//                             currentStep = 3;
//                           });
//                           return;
//                         }

//                         // Step 3 -> Save

//                         widget.profile["firstname"] = firstNameController.text
//                             .trim();
//                         widget.profile["lastname"] = lastNameController.text
//                             .trim();
//                         widget.profile["dateOfBirth"] = dobController.text;

//                         widget.profile["gender"] = gender;
//                         widget.profile["maritalStatus"] = maritalStatus;

//                         widget.profile["mobilenumber"] = mobileController.text
//                             .trim();
//                         widget.profile["noticePeriod"] = noticeController.text
//                             .trim();

//                         widget.profile["userExperienceLevel"] = experienceLevel;

//                         widget.profile["minimumExperienceInYears"] =
//                             int.tryParse(minExpController.text) ?? 0;

//                         widget.profile["maximumExperienceInYears"] =
//                             int.tryParse(maxExpController.text) ?? 0;

//                         widget.profile["address"] = {
//                           "line1": currentAddressController.text.trim(),
//                           "landmark": currentLandmarkController.text.trim(),
//                           "district": currentDistrict,
//                           "state": currentState,
//                           "country": currentCountry,
//                           "pincode": currentPincodeController.text.trim(),
//                         };

//                         widget.profile["permanentAddress"] = {
//                           "line1": permanentAddressController.text.trim(),
//                           "landmark": permanentLandmarkController.text.trim(),
//                           "district": permanentDistrict,
//                           "state": permanentState,
//                           "country": permanentCountry,
//                           "pincode": permanentPincodeController.text.trim(),
//                         };

//                         widget.profile["hasPermanentAddress"] = !sameAsCurrent;

//                         await widget.onSave();

//                         if (mounted) {
//                           Navigator.pop(context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size.fromHeight(55),
//                         backgroundColor: const Color(0xff8BB7FF),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: Text(
//                         currentStep == 3 ? "Save" : "Next",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _addressPage() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Current Address",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),

//         const SizedBox(height: 15),

//         TextField(
//           controller: currentAddressController,
//           maxLines: 2,
//           decoration: inputDecoration("Address Line"),
//         ),

//         const SizedBox(height: 15),

//         TextField(
//           controller: currentLandmarkController,
//           decoration: inputDecoration("Landmark"),
//         ),

//         const SizedBox(height: 15),

//         TextField(
//           controller: currentPincodeController,
//           keyboardType: TextInputType.number,
//           decoration: inputDecoration("Pincode"),
//         ),

//         const SizedBox(height: 25),

//         CheckboxListTile(
//           value: sameAsCurrent,
//           activeColor: const Color(0xff1667F2),
//           title: const Text("Permanent address is same as current"),
//           contentPadding: EdgeInsets.zero,
//           onChanged: (v) {
//             setState(() {
//               sameAsCurrent = v!;

//               if (sameAsCurrent) {
//                 permanentAddressController.text = currentAddressController.text;

//                 permanentLandmarkController.text =
//                     currentLandmarkController.text;

//                 permanentPincodeController.text = currentPincodeController.text;
//               }
//             });
//           },
//         ),

//         if (!sameAsCurrent) ...[
//           const SizedBox(height: 20),

//           const Text(
//             "Permanent Address",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),

//           const SizedBox(height: 15),

//           TextField(
//             controller: permanentAddressController,
//             maxLines: 2,
//             decoration: inputDecoration("Address Line"),
//           ),

//           const SizedBox(height: 15),

//           TextField(
//             controller: permanentLandmarkController,
//             decoration: inputDecoration("Landmark"),
//           ),

//           const SizedBox(height: 15),

//           TextField(
//             controller: permanentPincodeController,
//             keyboardType: TextInputType.number,
//             decoration: inputDecoration("Pincode"),
//           ),
//         ],

//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _contactPage() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Email Address *",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),

//         TextField(
//           controller: emailController,
//           keyboardType: TextInputType.emailAddress,
//           decoration: emailInputDecoration(
//             hint: "Enter Email",
//             suffix: isCheckingEmail
//                 ? const Padding(
//                     padding: EdgeInsets.all(12),
//                     child: SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   )
//                 : isEmailAvailable == null
//                 ? null
//                 : Icon(
//                     isEmailAvailable! ? Icons.check_circle : Icons.cancel,
//                     color: isEmailAvailable! ? Colors.green : Colors.red,
//                   ),
//           ),
//         ),
//         if (emailMessage.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 6),
//             child: Text(
//               emailMessage,
//               style: TextStyle(
//                 color: isEmailAvailable == true ? Colors.green : Colors.red,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),

//         const SizedBox(height: 8),
//         const Text(
//           "Notice Period (Days)",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),

//         TextField(
//           controller: noticeController,
//           keyboardType: TextInputType.number,
//           decoration: inputDecoration("Notice Period (Days)"),
//         ),

//         const SizedBox(height: 8),
//         const Text(
//           "Minimum Experience",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),
//         TextField(
//           controller: minExpController,
//           keyboardType: TextInputType.number,
//           decoration: inputDecoration("Minimum Experience"),
//         ),

//         const SizedBox(height: 8),
//         const Text(
//           "Maximum Experience",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),
//         TextField(
//           controller: maxExpController,
//           keyboardType: TextInputType.number,
//           decoration: inputDecoration("Maximum Experience"),
//         ),

//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _personalPage() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "First name *",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),

//         TextField(
//           controller: firstNameController,
//           decoration: inputDecoration("Enter your full name"),
//         ),

//         const SizedBox(height: 18),

//         const Text(
//           "Date of Birth *",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),

//         TextField(
//           controller: dobController,
//           readOnly: true,
//           decoration: inputDecoration(
//             "Select your DOB",
//             suffix: const Icon(Icons.calendar_month),
//           ),
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime(2000),
//               firstDate: DateTime(1950),
//               lastDate: DateTime.now(),
//             );

//             if (picked != null) {
//               dobController.text = picked.toIso8601String().substring(0, 10);
//             }
//           },
//         ),

//         const SizedBox(height: 18),

//         const Text(
//           "Gender *",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 8),

//         DropdownButtonFormField<String>(
//           initialValue: gender.isEmpty ? null : gender,
//           decoration: inputDecoration("Select your gender"),
//           items: const [
//             DropdownMenuItem(value: "Male", child: Text("Male")),

//             DropdownMenuItem(value: "Female", child: Text("Female")),

//             DropdownMenuItem(value: "Other", child: Text("Other")),
//           ],
//           onChanged: (v) {
//             setState(() {
//               gender = v!;
//             });
//           },
//         ),

//         const SizedBox(height: 20),

//         const Text(
//           "Relationship Status *",
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//         ),

//         const SizedBox(height: 10),

//         Row(
//           children: [radio("Married"), radio("Unmarried"), radio("Divorced")],
//         ),
//       ],
//     );
//   }

//   Widget radio(String value) {
//     return Expanded(
//       child: Row(
//         children: [
//           Radio<String>(
//             value: value,
//             groupValue: maritalStatus,
//             activeColor: const Color(0xff1667F2),
//             onChanged: (v) {
//               setState(() {
//                 maritalStatus = v!;
//               });
//             },
//           ),

//           Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
//         ],
//       ),
//     );
//   }
// }
