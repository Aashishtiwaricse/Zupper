import 'package:flutter/material.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final List<Map<String, dynamic>> companies = [
    {
      "name": "Amazon",
      "logo": "assets/amazon.png",
      "openings": 45,
      "rating": 5,
      "shortlisted": 31,
    },
    {
      "name": "Google",
      "logo": "assets/google.png",
      "openings": 28,
      "rating": 5,
      "shortlisted": 22,
    },
    {
      "name": "Microsoft",
      "logo": "assets/microsoft.png",
      "openings": 18,
      "rating": 5,
      "shortlisted": 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Company Spotlight",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff4D7CFE),
                          Color(0xffD933FF),
                        ],
                      ),
                    ),
                    child: const Text(
                      "Rate Your Company",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final company = companies[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xffDCE7FF),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  AssetImage(company['logo']),
                            ),

                            const Spacer(),

                            Row(
                              children: List.generate(
                                company['rating'],
                                (index) => const Padding(
                                  padding: EdgeInsets.only(right: 2),
                                  child: Icon(
                                    Icons.star,
                                    color: Color(0xffF59E0B),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Text(
                          company['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${company['openings']} Openings",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff6B7280),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          "~${company['shortlisted']} seekers got shortlisted\nthrough Zuperr",
                          style: const TextStyle(
                            color: Color(0xff76A8FF),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: companies.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 20,
          right: 20,
          bottom: 30,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff1E6BE3),
          image: DecorationImage(
            image: AssetImage("assets/Head.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                children: [
                  TextSpan(text: "Your "),
                  TextSpan(
                    text: "journey",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text:
                        " to great\nworkplaces starts here",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Browse trusted companies, read insights, and\nchoose where you'll thrive.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search companies...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}