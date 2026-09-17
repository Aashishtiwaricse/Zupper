import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/PrivacyVisibility/custom_visibility_dropdown.dart';
import 'package:zuperr/Services/profileUpdateData/updateProfile.dart';


class PrivacyVisibilityScreen extends StatefulWidget {
  const PrivacyVisibilityScreen({super.key});

  @override
  State<PrivacyVisibilityScreen> createState() =>
      _PrivacyVisibilityScreenState();
}

class _PrivacyVisibilityScreenState
    extends State<PrivacyVisibilityScreen> {

  final List<String> visibilityOptions = [
    "Public",
    "Recruiters Only",
    "Private",
  ];

  String selectedVisibility = "Public";

  bool loading = false;

Future<void> saveVisibility() async {
  setState(() {
    loading = true;
  });

  String visibility;

  switch (selectedVisibility) {
    case "Public":
      visibility = "public";
      break;

    case "Recruiters Only":
      visibility = "recruiters_only";
      break;

    case "Private":
      visibility = "private";
      break;

    default:
      visibility = "public";
  }

  final success = await UpdateProfileService.updateProfile({
    "candidateProfileVisibility": visibility,
  });

  setState(() {
    loading = false;
  });

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: success ? Colors.green : Colors.red,
      content: Text(
        success
            ? "Profile visibility updated successfully."
            : "Failed to update profile visibility.",
      ),
    ),
  );

  if (success) {
    Navigator.pop(context, true);
  }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          /// HEADER

          Container(
            height: 165,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage(
                  "assets/Head.png",
                ),
                fit: BoxFit.cover,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Row(
                  children: [

                    GestureDetector(

                      onTap: (){
                        Navigator.pop(context);
                      },

                      child: Container(

                        height: 48,
                        width: 48,

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          borderRadius:
                          BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Text(
                      "Privacy & Visibility Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Expanded(

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Profile Visibility",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 15),

                  CustomVisibilityDropdown(

                    value: selectedVisibility,

                    items: visibilityOptions,

                    onChanged: (value){

                      setState(() {

                        selectedVisibility=value!;

                      });

                    },
                  ),

                  const SizedBox(height: 35),

                  const Text(

                    "Please Note:",

                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(

                    "Profile visibility controls who can view your information online. It enhances privacy by letting users choose between public, recruiters only or private visibility.",

                    style: TextStyle(

                      color: Colors.grey.shade600,

                      fontSize: 16,

                      height: 1.6,

                    ),
                  ),

                  const Spacer(),

                  SizedBox(

                    width: double.infinity,

                    height: 56,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:

                        const Color(0xffE8F1FF),

                        elevation: 0,

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(14),

                        ),
                      ),

                      onPressed: (){

                      },

                      child: const Text(

                        "Preview",

                        style: TextStyle(

                          color: Color(0xff1E6BE3),

                          fontSize: 18,

                          fontWeight: FontWeight.w700,

                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(

                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                        const Color(0xff1E6BE3),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(14),

                        ),
                      ),

                      onPressed:

                      loading

                          ? null

                          : saveVisibility,

                      child:

                      loading

                          ? const SizedBox(

                        height: 24,

                        width: 24,

                        child:
                        CircularProgressIndicator(

                          strokeWidth: 2,

                          color: Colors.white,

                        ),
                      )

                          : const Text(

                        "Save",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight: FontWeight.w700,

                          color: Colors.white,

                        ),
                        
                      ),
                    ),
                  ),
                                    const SizedBox(height: 18),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}