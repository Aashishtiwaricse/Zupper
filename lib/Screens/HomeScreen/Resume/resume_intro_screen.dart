import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/template_screen.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/feature_tile.dart';
import 'package:zuperr/Utils/colors.dart';

class ResumeIntroScreen extends StatelessWidget {
  const ResumeIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          height: 58,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TemplateScreen()),
              );
            },
            icon: const Icon(Icons.badge_outlined, color: Colors.white),
            label: Text(
              "Create Resume",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          /// HEADER
          Container(
            height: size.height * .18,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Resume",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// ICON
                  Container(
                    height: 69,
                    width: 66,
                    decoration: const BoxDecoration(
                      color: Color(0xffEEF5FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/resume.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        color: AppColors
                            .primary, // remove if image has its own color
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// TITLE
                  Text(
                    "Create Your\nProfessional Resume",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: const Color(0xff222222),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: 330,
                    child: Text(
                      "Build a stunning resume in minutes with our easy-to-use builder. Choose from professionally designed templates and land your dream job.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 45),

                  const FeatureTile(
                    title: "Choose Templates",
                    subtitle: "Select from Modern, Classic or Creative designs",
                  ),

                  const SizedBox(height: 18),

                  const FeatureTile(
                    title: "Fill Your Details",
                    subtitle: "Add your experience, education and skills",
                  ),

                  const SizedBox(height: 18),

                  const FeatureTile(
                    title: "Download & Share",
                    subtitle: "Export your resume as PDF and share instantly",
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
