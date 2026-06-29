import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';



class AllJobsScreen extends StatelessWidget {
  final List<dynamic> jobs;

  const AllJobsScreen({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    
  final styles = [
  {
    "accent": Color(0xff2563EB),
    "gradient": [
      Color(0xffFFFFFF),
      Color(0xffEEF4FF),
    ],
  },
  {
    "accent": Color(0xffF59E0B),
    "gradient": [
      Color(0xffFFFFFF),
      Color(0xffFFF6E8),
    ],
  },
  {
    "accent": Color(0xff22C55E),
    "gradient": [
      Color(0xffFFFFFF),
      Color(0xffECFDF5),
    ],
  },
];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Column(
        children: [
          // 🔵 HEADER WITH BACKGROUND IMAGE
          Container(
            
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage('assets/Head.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children:  [
                GestureDetector(
                                        onTap: () => Navigator.pop(context),

                  child: Container(
                    height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                     
child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 14,
                        ),                    
                    ),
                ),
                SizedBox(width: 16),
                Text(
                  "All Jobs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 📜 LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
               final style = styles[index % styles.length];
final job = jobs[index];

return JobCard(
  job: job,
  accentColor: style["accent"] as Color,
  gradient: style["gradient"] as List<Color>,
);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final dynamic job;
  final List<Color> gradient;
  final Color accentColor;

  const JobCard({
    super.key,
    required this.job,
    required this.gradient,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          // 🎯 MAIN CARD
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              border: Border.all(
                color: accentColor.withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _cardContent(context),
            ),
          ),

          // 🔥 LEFT ACCENT LINE (OUTSIDE EFFECT)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DATE + BOOKMARK
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
          Text(
  job['createdAt'] != null
      ? job['createdAt'].toString().split('T')[0]
      : '',
  style: const TextStyle(color: Colors.black54),
),
            Icon(Icons.bookmark_border),
          ],
        ),

        const SizedBox(height: 12),

        // LOGO + TITLE
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.android, color: Colors.white),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
  job['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                   Text(
  job['companyName'] ?? '',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // LOCATION + EXPERIENCE
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                size: 18, color: accentColor),
            const SizedBox(width: 4),
Expanded(
  child: Text(
    job['location'] ?? '',
    overflow: TextOverflow.ellipsis,
  ),
),
            const SizedBox(width: 20),
            Icon(Icons.work_outline,
                size: 18, color: accentColor),
            const SizedBox(width: 4),
Text(
  '${job['minimumExperienceInYears']}-${job['maximumExperienceInYears']} Years',
)
          ],
        ),

        const SizedBox(height: 12),

        // SKILLS
       Wrap(
  spacing: 8,
  runSpacing: 8,
  children: (job['skills'] as List?)?.isNotEmpty == true
      ? (job['skills'] as List)
          .take(4)
          .map(
            (skill) => _SkillChip(
              label: skill.toString(),
            ),
          )
          .toList()
      : [
          const _SkillChip(label: 'No Skills'),
        ],
),

        const Divider(height: 24),

        // SALARY + APPLY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
Text(
  job['maximumSalaryLPA'] != null &&
          job['maximumSalaryLPA'] > 0
      ? '₹ ${job['minimumSalaryLPA']} - ${job['maximumSalaryLPA']} LPA'
      : 'Salary Not Disclosed',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

            ElevatedButton(
              onPressed: () {
               Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => JobDetailScreen(
      job: job,
    ),
  ),
);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Apply',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ],
    );
  }
}


// SKILL CHIP
class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xffDCE7FF)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}