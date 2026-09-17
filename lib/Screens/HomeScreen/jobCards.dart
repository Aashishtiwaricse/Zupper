import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/jobDetailsScreen.dart';

class JobCard extends StatelessWidget {
  final dynamic job;

  const JobCard({
    super.key,
    required this.job,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffDCE7FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2563EB).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Blue top accent bar
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xff2563EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),

          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              children: [
                // Logo + Bookmark row
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'a',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                  height: 1.1,
                                ),
                              ),
                              // Amazon smile arrow
                              CustomPaint(
                                size: const Size(42, 8),
                                painter: _SmilePainter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      // Bookmark icon top-right
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: const Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Job title
                const Text(
                  'Senior UI/UX Designer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff0F172A),
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Company & salary
                const Text(
                  'Amazon  •  ₹ 6-8.5 LPA',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // Location & experience row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: 'Mumbai',
                      iconColor: const Color(0xff2563EB),
                    ),
                    const SizedBox(width: 20),
                    _InfoChip(
                      icon: Icons.work_outline_rounded,
                      label: '3-5 Years',
                      iconColor: const Color(0xff2563EB),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Dashed divider
          _DashedDivider(color: const Color(0xffDCE7FF)),

          // Skills section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                _SkillChip(label: 'Figma'),
                _SkillChip(label: 'Adobe XD'),
                _SkillChip(label: 'Protopie'),
                _SkillChip(label: 'Photoshop'),
                _SkillChip(label: 'Illustrator'),
              ],
            ),
          ),

          // Dashed divider
          _DashedDivider(color: const Color(0xffDCE7FF)),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => JobDetailScreen( job: job,
)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: iconColor),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff475569),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Skill pill chip ───────────────────────────────────────────────────────────
class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xffDCE7FF), width: 1.2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xff475569),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


// ── Amazon smile arrow painter ────────────────────────────────────────────────
class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffFF9900)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(2, 2);
    path.quadraticBezierTo(size.width / 2, size.height + 4, size.width - 2, 2);

    canvas.drawPath(path, paint);

    // Arrow tip
    final arrowPaint = Paint()
      ..color = const Color(0xffFF9900)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width - 2, 2),
      Offset(size.width - 6, 5),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(_SmilePainter old) => false;
}





class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    double x = 0;
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}
