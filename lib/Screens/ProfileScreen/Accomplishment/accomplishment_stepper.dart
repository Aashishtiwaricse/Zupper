import 'package:flutter/material.dart';

class AccomplishmentStepper extends StatelessWidget {
  final int currentStep;

  const AccomplishmentStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _step(
            number: 1,
            title: "Certification",
            active: currentStep >= 0,
            completed: currentStep > 0,
          ),
          _line(currentStep > 0),
          _step(
            number: 2,
            title: "Awards",
            active: currentStep >= 1,
            completed: currentStep > 1,
          ),
          _line(currentStep > 1),
          _step(
            number: 3,
            title: "Committee",
            active: currentStep >= 2,
            completed: false,
          ),
        ],
      ),
    );
  }

  Widget _line(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active
            ? const Color(0xff2563EB)
            : Colors.grey.shade300,
      ),
    );
  }

  Widget _step({
    required int number,
    required String title,
    required bool active,
    required bool completed,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xff2563EB)
                : Colors.white,
            border: Border.all(
              color: active
                  ? const Color(0xff2563EB)
                  : Colors.grey.shade400,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    number.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: active
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  active ? FontWeight.w600 : FontWeight.w500,
              color: active
                  ? const Color(0xff2563EB)
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}