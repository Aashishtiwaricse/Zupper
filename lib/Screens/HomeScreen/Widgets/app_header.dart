import 'package:flutter/material.dart';


class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
            height: 125,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff1E6BE3),
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),

                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: Container(
                        height: 48,
                        width: 48,

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                     Text(
                    title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}