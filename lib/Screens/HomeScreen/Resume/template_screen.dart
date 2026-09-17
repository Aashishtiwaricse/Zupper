import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zuperr/Controllers/Resume/resume_controller.dart';
import 'package:zuperr/Models/Template/ResumeTemplate.dart';
import 'package:zuperr/Screens/HomeScreen/Resume/%20resume_builder_screen.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/app_header.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/template_card.dart';
import 'package:get/get.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  int selectedIndex = 0;

  final List<ResumeTemplate> templates = [
    ResumeTemplate(
      title: "Modern",
      description:
          "Clean, professional layout with accent colors and modern typography",
    ),
    ResumeTemplate(
      title: "Classic",
      description:
          "Traditional layout with elegant typography, perfect for formal industries",
    ),
    ResumeTemplate(
      title: "Creative",
      description:
          "Colorful side-panel design with skill bars, ideal for creative fields",
    ),
  ];

  final ResumeController resumeController = Get.put(ResumeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          const AppHeader(title: "Select Template"),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Choose Your Style",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff252B37),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Select a template that best represents your professional style",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xff6B7280),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      return TemplateCard(
                        title: templates[index].title,
                        subtitle: templates[index].description,
                        selected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          "Or",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                   onTap: () async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    await resumeController.autofillFromProfile();

    if (mounted) {
      Navigator.pop(context); // Close loader

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResumeBuilderScreen(),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to import profile: $e"),
        ),
      );
    }
  }
},
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                            color: Color(0xff252B37),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Autofill from Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff252B37),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 58,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2970FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResumeBuilderScreen(),
                          ),
                        );
                      },

                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
