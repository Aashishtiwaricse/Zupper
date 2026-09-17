import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {

  final int currentStep;

  const StepIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {

    Widget circle(int step){

      bool completed = step < currentStep;
      bool active = step == currentStep;

      return Container(
        width: 42,
        height: 42,

        decoration: BoxDecoration(

          shape: BoxShape.circle,

          color: completed
              ? const Color(0xff1667F2)
              : Colors.white,

          border: Border.all(
            color: const Color(0xff1667F2),
            width: 2,
          ),

        ),

        child: Center(

          child: completed

              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )

              : Text(
                  step.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: active
                        ? const Color(0xff1667F2)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    }

    return Row(

      children: [

        circle(1),

        const Expanded(
          child: Divider(
            thickness: 2,
          ),
        ),

        circle(2),

        const Expanded(
          child: Divider(
            thickness: 2,
          ),
        ),

        circle(3),

      ],
    );
  }
}