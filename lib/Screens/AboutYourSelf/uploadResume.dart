import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:zuperr/Screens/HomeMain/homeMain.dart';
import 'package:zuperr/Screens/SignInScreen/signIn.dart';

class UploadResumeScreen extends StatefulWidget {
  const UploadResumeScreen({super.key});

  @override
  State<UploadResumeScreen> createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends State<UploadResumeScreen> {
  File? _selectedFile;
  String? _fileName;
  bool _isUploading = false;

  /// 📂 PICK FILE
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);

      /// ✅ SIZE VALIDATION (2MB)
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File must be less than 2MB")),
        );
        return;
      }

      setState(() {
        _selectedFile = file;
        _fileName = result.files.single.name;
      });
    }
  }

  /// 🚀 UPLOAD FILE (Mock API)
  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() => _isUploading = true);

    /// 🔥 Replace with your API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Resume Uploaded Successfully")),
    );

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MainScreen(),
  ),
);  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

                /// 🔵 LOGO
             Image.asset(
                "assets/Zuperr.png", // 👈 add your image
                height: 30,
              ),

            const SizedBox(height: 60),

            Image.asset(
              "assets/Group.png",
              height: 180,
            ),

            const SizedBox(height: 25),

            const Text(
              "Upload Resume",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Showcase your skills and experience to unlock new opportunities.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            /// 📂 CLICK TO UPLOAD
            GestureDetector(
              onTap: _pickFile,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined,
                          color: Colors.blue, size: 30),

                      const SizedBox(height: 10),

                      const Text(
                        "Click to upload",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "PDF, DOC, or DOCX (Upto 2MB)",
                        style: TextStyle(color: Colors.grey),
                      ),

                      /// ✅ SHOW FILE NAME
                      if (_fileName != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _fileName!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// 🔘 UPLOAD BUTTON
            GestureDetector(
              onTap: (_selectedFile != null && !_isUploading)
                  ? _uploadFile
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: (_selectedFile != null && !_isUploading)
                        ? Colors.blue
                        : Colors.blue.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: _isUploading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          "Upload Resume",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            GestureDetector(
  onTap: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  },
  child: const Text(
    "Skip and continue without resume",
    style: TextStyle(
      decoration: TextDecoration.underline,
      color: Colors.grey,
    ),
  ),
),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}