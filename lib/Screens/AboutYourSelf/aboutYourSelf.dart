import 'package:flutter/material.dart';

class AboutYourselfScreen extends StatefulWidget {
  const AboutYourselfScreen({super.key});

  @override
  State<AboutYourselfScreen> createState() => _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends State<AboutYourselfScreen> {
  int? selectedIndex;

  final List<String> options = [
    "Fresher",
    "Working Professional, but Unemployed",
    "Working Professional",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height:40),
              

              /// 🔵 LOGO
             Image.asset(
                "assets/Zuperr.png", // 👈 add your image
                height: 30,
              ),

              const SizedBox(height: 60),

              /// 🖼 IMAGE
              Image.asset(
                "assets/OBJECTS.png", // 👈 add your image
                height: 220,
              ),

              const SizedBox(height: 30),

              /// 🔤 TITLE
              const Text(
                "Tell us about yourself",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color:Color(0xFF181D27),
                ),
              ),

              const SizedBox(height: 8),

              /// 🔤 SUBTITLE
              const Text(
                "Choose the option that best describes you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6A6E76),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔘 OPTIONS
              ...List.generate(options.length, (index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            options[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Color(0xFF414651)
                                  : Color(0xFF414651),
                            ),
                          ),
                        ),

                        /// ✅ CHECK ICON
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                          )
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              /// 🔘 CONTINUE BUTTON
              GestureDetector(
                onTap: selectedIndex != null
                    ? () {
                        Navigator.pushReplacementNamed(context, '/UploadResumeScreen');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Selected: ${options[selectedIndex!]}"),
                          ),
                        );
                      }
                      
                    : null,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: selectedIndex != null
                        ? Color(0xFF1877F2)
                        : Colors.blue.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
  }
}