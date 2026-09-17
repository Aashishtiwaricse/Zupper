import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zuperr/Controllers/AccomplishmentFormController/accomplishmentFormController.dart';

class CommitteeStep extends StatefulWidget {
  final AccomplishmentFormController controller;

  const CommitteeStep({super.key, required this.controller});

  @override
  State<CommitteeStep> createState() => _CommitteeStepState();
}

class _CommitteeStepState extends State<CommitteeStep> {
  static const int maxCharacters = 1000;

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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xff2563EB), width: 1.5),
      ),
    );
  }

  Widget label(String text, {bool required = true}) {
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

  // ---------------------------------------------------------
  // PICK DATE
  // ---------------------------------------------------------

  Future<void> pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked == null) return;

    controller.text =
        "${picked.month.toString().padLeft(2, "0")}/${picked.year}";

    setState(() {});
  }

  // ---------------------------------------------------------
  // PICK FILE
  // ---------------------------------------------------------

  Future<void> _pickFile() async {
    final sheet = widget.controller;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["jpg", "jpeg", "png", "pdf", "doc", "docx"],
    );

    if (result == null) return;

    final file = result.files.single;

    setState(() {
      sheet.uploadedFile = file.name;
      sheet.uploadedFilePath = file.path;
    });
  }

  // ---------------------------------------------------------
  // REMOVE FILE
  // ---------------------------------------------------------

  void _removeFile() {
    final sheet = widget.controller;

    setState(() {
      sheet.uploadedFile = null;
      sheet.uploadedFilePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sheet = widget.controller;

    return Form(
      key: sheet.formKeys[2],

      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Committee / Clubs",

              style: TextStyle(
                color: Color(0xff2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 28),

            label("Committee / Club"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.clubName,

              decoration: decoration("Enter club name"),
            ),

            const SizedBox(height: 22),

            label("Position Held"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.positionHeld,

              decoration: decoration("Enter position"),
            ),

            const SizedBox(height: 22),

            label("Educational Reference"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.educationReference,

              decoration: decoration("School / College"),
            ),

            const SizedBox(height: 24),

            label("Duration"),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => pickDate(context, sheet.fromDate),

                    child: IgnorePointer(
                      child: TextFormField(
                        controller: sheet.fromDate,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Select start date";
                          }
                          return null;
                        },

                        decoration: decoration("MM/YYYY").copyWith(
                          suffixIcon: const Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                const Text("To", style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(width: 12),

                Expanded(
                  child: InkWell(
                    onTap: sheet.currentlyHolding
                        ? null
                        : () => pickDate(context, sheet.toDate),

                    child: IgnorePointer(
                      child: TextFormField(
                        controller: sheet.toDate,
                      
                        decoration: decoration("MM/YYYY").copyWith(
                          suffixIcon: const Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,

              controlAffinity: ListTileControlAffinity.leading,

              value: sheet.currentlyHolding,

              title: const Text("Currently holding this position"),

              onChanged: (value) {
                setState(() {
                  sheet.currentlyHolding = value ?? false;

                  if (sheet.currentlyHolding) {
                    sheet.toDate.text = "Present";
                  } else {
                    sheet.toDate.clear();
                  }
                });
              },
            ),

            const SizedBox(height: 24),

            label("Responsibilities"),

            const SizedBox(height: 10),

            TextFormField(
              controller: sheet.responsibilities,

              maxLines: 7,

              maxLength: maxCharacters,

              onChanged: (_) {
                setState(() {});
              },
            
              decoration: decoration(
                "Describe your responsibilities",
              ).copyWith(counterText: ""),
            ),

            Align(
              alignment: Alignment.centerRight,

              child: Text(
                "${sheet.responsibilities.text.length}/1000 characters",

                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const SizedBox(height: 24),

            label("Upload Media", required: false),

            const SizedBox(height: 10),

            InkWell(
              onTap: _pickFile,

              child: Container(
                width: double.infinity,

                height: sheet.uploadedFile == null ? 170 : 190,

                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: sheet.uploadedFile == null
                    ? _uploadEmptyState()
                    : _uploadedFileState(sheet),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // EMPTY UPLOAD STATE
  // ---------------------------------------------------------

  Widget _uploadEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        const Icon(
          Icons.cloud_upload_outlined,

          size: 42,

          color: Color(0xff2563EB),
        ),

        const SizedBox(height: 12),

        const Text(
          "Upload Media",

          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),

        const SizedBox(height: 6),

        Text(
          "Drag & drop or browse files",

          style: TextStyle(color: Colors.grey.shade600),
        ),

        const SizedBox(height: 12),

        OutlinedButton(onPressed: _pickFile, child: const Text("Browse Files")),
      ],
    );
  }

  // ---------------------------------------------------------
  // FILE SELECTED STATE
  // ---------------------------------------------------------

  Widget _uploadedFileState(AccomplishmentFormController sheet) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.insert_drive_file_outlined,

            size: 42,

            color: Color(0xff2563EB),
          ),

          const SizedBox(height: 12),

          Text(
            sheet.uploadedFile ?? "",

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              OutlinedButton(
                onPressed: _pickFile,

                child: const Text("Change File"),
              ),

              const SizedBox(width: 10),

              IconButton(
                onPressed: _removeFile,

                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
