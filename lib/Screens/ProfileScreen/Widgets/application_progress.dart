import 'package:flutter/material.dart';

class ApplicationProgress extends StatelessWidget {
  final String status;

  const ApplicationProgress({
    super.key,
    required this.status,
  });

  static const List<String> stages = [
    "Application Submitted",
    "Recruiter Viewed",
    "Under Review",
    "Under Review",
  ];

  int get currentStep {
    switch (status.toLowerCase()) {
      case "applied":
        return 0;

      case "viewed":
        return 1;

      case "under review":
        return 2;

      case "interview":
        return 3;

      case "offer":
        return 4;

      case "rejected":
        return -1;

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep == -1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Your application was rejected.",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          stages.length,
          (index) {
            final completed = index <= currentStep;

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      if (index != 0)
                        Expanded(
                          child: Container(
                            height: 3,
                            color: completed
                                ? const Color(0xff1565D8)
                                : Colors.grey.shade300,
                          ),
                        ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 12,
                        height:12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: completed
                              ? const Color(0xff1565D8)
                              : Colors.white,
                          border: Border.all(
                            color: completed
                                ? const Color(0xff1565D8)
                                : Colors.grey.shade300,
                            width: 3,
                          ),
                        ),
                        child: completed
                            ? const Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 4,
                              )
                            : null,
                      ),

                      if (index != stages.length - 1)
                        Expanded(
                          child: Container(
                            height: 3,
                            color: index < currentStep
                                ? const Color(0xff1565D8)
                                : Colors.grey.shade300,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    stages[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: completed
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: completed
                          ? const Color(0xff1565D8)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}