import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  static const labels = [
    "Personal",
    "Experience",
    "Education",
    "Skills",
    "Projects",
  ];
  static const titles = [
    "Personal Information",
    "Work Experience",
    "Education",
    "Skills",
    "Projects",
  ];

  static const subtitles = [
    "Tell us about yourself",
    "Add your professional experience",
    "Add your educational qualifications",
    "Highlight your key skills",
    "Showcase your projects",
  ];

  @override
  Widget build(BuildContext context) {
    const int totalSteps = 5;
    const Color primary = Color(0xff2563EB);

    return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    


      Text(
        titles[currentStep],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 1),

      Text(
        subtitles[currentStep],
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),

      const SizedBox(height: 24),

      // Step circles row
      _buildStepper(totalSteps, primary),

      const SizedBox(height: 10),

      // Labels row
      _buildLabels(primary),
    ],
  ),
);
  }
  Widget _buildStepper(int totalSteps, Color primary) {
  return Row(
    children: List.generate(totalSteps, (index) {
      final completed = index < currentStep;
      final current = index == currentStep;

      return Expanded(
        child: Row(
          children: [
            _buildStep(index, completed, current, primary),
            if (index != totalSteps - 1)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (constraints.maxWidth / 6).floor(),
                        (_) => Container(
                          width: 2,
                          height: 2,
                          decoration:  BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    }),
  );
}
Widget _buildLabels(Color primary) {
  return Row(
    children: List.generate(labels.length, (index) {
      final active = index <= currentStep;

      return Expanded(
        child: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            labels[index],
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  active ? FontWeight.w600 : FontWeight.w400,
              color: active ? primary : Colors.grey,
            ),
          ),
        ),
      );
    }),
  );
}

  Widget _buildStep(int index, bool completed, bool current, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? color : Colors.white,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: completed
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '${index + 1}'.padLeft(2, '0'),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }
}
