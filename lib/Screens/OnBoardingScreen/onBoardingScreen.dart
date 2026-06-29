import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Land the\njob, that’s\nright for\nyou (1)",
      "desc":
          "Discover Over 130,000+ Job Opportunities with Top Companies and Emerging Startups",
    },
    {
      "title": "Build your\ncareer faster\nthan ever (2)",
      "desc": "Apply instantly and track your applications in one place",
    },
    {
      "title": "Get hired by\ntop companies\nworldwide (3)",
      "desc": "Connect with recruiters and unlock global opportunities",
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Navigate to home/login
    }
  }

  void prevPage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔷 TOP CONTAINER (CHANGING)
            Expanded(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage('assets/OnBoarding.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),

                          /// 🔤 Dynamic Title
                          Text(
                            onboardingData[currentIndex]["title"]!,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// 🔤 Dynamic Description
                          Text(
                            onboardingData[currentIndex]["desc"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ➡️ Arrow Button (Optional)
                    ///
                    ///
                   
                    if (currentIndex > 0)
                      Positioned(
                        bottom: 130,
                        left: 20,
                        child: GestureDetector(
                          onTap: prevPage,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(66, 139, 110, 110),
                              ),
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                       if (currentIndex == 1)
                      Positioned(
                        bottom: 130,
                        left: 90,
                        child: GestureDetector(
                          onTap: nextPage,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(66, 139, 110, 110),
                              ),
                            ),
                            child: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),
                      
                       if (currentIndex == 0)
                    Positioned(
                      bottom: 130,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => nextPage(),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(66, 139, 110, 110),
                            ),
                          ),
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔷 BOTTOM CONTAINER (CONSTANT)
            Expanded(
              flex: 2, // 🔥 takes 30% screen

              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    /// 🔘 DOTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => _dot(index == currentIndex),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔘 NEXT BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentIndex == onboardingData.length - 1) {
                            // अंतिम स्क्रीन → Navigate
                            Navigator.pushReplacementNamed(context, '/LoginScreen');
                          } else {
                            nextPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          currentIndex == onboardingData.length - 1
                              ? "Find Jobs Now"
                              : "Next",
                          style: const TextStyle(
                            fontSize: 16,
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
    );
  }

  /// 🔘 DOT WIDGET
  Widget _dot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 6,
      height: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  }
}
