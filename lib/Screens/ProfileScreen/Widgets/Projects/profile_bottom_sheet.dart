import 'package:flutter/material.dart';

class ProfileBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget bottomButton;

  const ProfileBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.bottomButton,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: bottom),
      child: DraggableScrollableSheet(
        initialChildSize: .93,
        minChildSize: .80,
        maxChildSize: .96,
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [

                const SizedBox(height: 12),

                Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xff5B6474),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: child,
                  ),
                ),

                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: bottomButton,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}