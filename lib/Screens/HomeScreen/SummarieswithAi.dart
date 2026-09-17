import 'package:flutter/material.dart';

class SummarizeWithAi extends StatelessWidget {
  const SummarizeWithAi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xffF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _card(
                    child: Column(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: Color(0xff16A34A), size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          "Strong Match",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff16A34A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "(You meet most key requirements)",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),

                  _section(
                    title: "Top Skills Matched:",
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _Tag("Python", true),
                        _Tag("SQL", true),
                        _Tag("Tableau", true),
                        _Tag("Snowflake", true),
                        _Tag("Nielsen Data", true),
                      ],
                    ),
                  ),

                  _section(
                    title: "Job Requirements Met:",
                    child: Column(
                      children: const [
                        _CheckItem("Experience with data transformation", true),
                        _CheckItem("Experience with CPG data (Nielsen, IRI)", true),
                        _CheckItem("Strong dashboard skills (Tableau)", true),
                        _CheckItem("Stakeholder communication", true),
                        _CheckItem("Experience with DBT", false),
                        _CheckItem("Experience with Looker Studio", false),
                      ],
                    ),
                  ),

                  _section(
                    title: "Candidate Rank:",
                    child: Text(
                      "You're in the Top 29% of applicants for this role.",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),

                  _section(
                    title: "Missing Skills:",
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _Tag("DBT", false),
                        _Tag("Looker Studio", false),
                        _Tag("Cross-functional Leadership", false),
                      ],
                    ),
                  ),

                  _section(
                    title: "Suggested Actions:",
                    child: Column(
                      children: const [
                        _ActionItem("Update Resume"),
                        _ActionItem("Learn DBT (Free Course)"),
                        _ActionItem("Apply Now"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xffE2E8F0)),
    ),
    child: child,
  );
}
Widget _section({required String title, required Widget child}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xffE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

}

class _Tag extends StatelessWidget {
  final String text;
  final bool isGood;

  const _Tag(this.text, this.isGood);

  @override
  Widget build(BuildContext context) {
    final color = isGood ? const Color(0xff16A34A) : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGood ? Icons.check_circle : Icons.close,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  final bool ok;

  const _CheckItem(this.text, this.ok);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check : Icons.close,
            color: ok ? const Color(0xff16A34A) : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
class _ActionItem extends StatelessWidget {
  final String text;
  const _ActionItem(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}