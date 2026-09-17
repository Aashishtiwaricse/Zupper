import 'package:flutter/material.dart';
import 'package:zuperr/Controllers/AccomplishmentFormController/accomplishmentFormController.dart';

class AwardsStep extends StatefulWidget {
  final AccomplishmentFormController controller;

  const AwardsStep({
    super.key,
    required this.controller,
  });

  @override
  State<AwardsStep> createState() => _AwardsStepState();
}

class _AwardsStepState extends State<AwardsStep> {
  static const int maxCharacters = 1000;

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Color(0xff2563EB),
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheet = widget.controller;

    return Form(
      key: sheet.formKeys[1],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              const Text(
                "Awards & Recognition",
                style: TextStyle(
                  color: Color(0xff2563EB),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
        
              const SizedBox(height: 26),
        
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xff363B44),
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                  children: [
                    TextSpan(text: "Description"),
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Color(0xff2563EB),
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 10),
        TextFormField(
  controller: sheet.awardDescription,
  maxLines: 10,
  minLines: 8,
  textAlignVertical: TextAlignVertical.top,
  maxLength: maxCharacters,
  onChanged: (_) => setState(() {}),
 
  decoration: decoration(
    "Describe your award or achievement",
  ).copyWith(
    counterText: "",
    alignLabelWithHint: true,
  ),
),
        
              const SizedBox(height: 8),
        
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${sheet.awardDescription.text.length}/1000 characters",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
        
              const SizedBox(height: 20),
        
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xffE2E8F0),
                  ),
                ),
                child: Row(
                  children: const [
        
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xff2563EB),
                    ),
        
                    SizedBox(width: 12),
        
                    Expanded(
                      child: Text(
                        "Mention the achievement, recognition received, issuing organization and why it was awarded.",
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xff64748B),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}