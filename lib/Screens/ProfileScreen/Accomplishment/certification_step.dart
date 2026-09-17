import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Controllers/AccomplishmentFormController/accomplishmentFormController.dart';

class CertificationStep extends StatelessWidget {
  final AccomplishmentFormController controller;

  const CertificationStep({super.key, required this.controller});

  Future<void> _pickMonthYear(
    BuildContext context,
    TextEditingController monthController,
    TextEditingController yearController,
  ) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked == null) return;

    monthController.text = DateFormat("MM").format(picked);
    yearController.text = picked.year.toString();
  }

  Widget title(String text, {bool required = true}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Color(0xff363B44),
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),

        children: [
          TextSpan(text: text),

          if (required)
            const TextSpan(
              text: " *",
              style: TextStyle(color: Color(0xff2563EB)),
            ),
        ],
      ),
    );
  }

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,

      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(color: Color(0xff2563EB), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheet = controller;

    return Form(
      key: sheet.formKeys[0],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Certifications",
              style: TextStyle(
                color: Color(0xff2563EB),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 28),

            title("Certification Name"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.certificationName,
            
              decoration: decoration("Enter certification name"),
            ),

            const SizedBox(height: 22),

            title("Certification ID"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.certificationId,
              
              decoration: decoration("Enter certification ID"),
            ),

            const SizedBox(height: 22),

            title("Certification URL"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.certificationUrl,
              keyboardType: TextInputType.url,
            
              decoration: decoration("Enter certification URL"),
            ),

            const SizedBox(height: 22),

            title("Certification Validity"),

            const SizedBox(height: 10),

            InkWell(
              onTap: sheet.noExpiry
                  ? null
                  : () => _pickMonthYear(
                      context,
                      sheet.validityMonth,
                      sheet.validityYear,
                    ),
              child: IgnorePointer(
                child: TextFormField(
                  controller: TextEditingController(
                    text: sheet.validityMonth.text.isEmpty
                        ? ""
                        : "${sheet.validityMonth.text}/${sheet.validityYear.text}",
                  ),
                
                  decoration: decoration("MM/YYYY").copyWith(
                    suffixIcon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            StatefulBuilder(
              builder: (_, set) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: sheet.noExpiry,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("This certificate does not expire"),
                  onChanged: (v) {
                    set(() {
                      sheet.noExpiry = v ?? false;

                      if (sheet.noExpiry) {
                        sheet.validityMonth.clear();
                        sheet.validityYear.clear();
                      }
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
