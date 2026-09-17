import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';

class CompanyHeader extends StatelessWidget {
  final CompanyById company;

  const CompanyHeader({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff1E6BE3),
        image: DecorationImage(
          image: AssetImage(
            "assets/Head.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
                    color: Colors.white.withValues(
                      alpha: .12,
                    ),
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

              const Text(
                "Company Info",
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