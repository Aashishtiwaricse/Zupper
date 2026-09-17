import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';
import 'package:zuperr/Utils/AppConstants.dart';

void _showTopMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final overlay = Overlay.of(context);

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isError ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline
                    : Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

Future<bool> updateCandidateData({
  required BuildContext context,
  required String profileSummary,
  required List<Skill> keySkills,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final response = await Dio().post(
      "${ApiConstants.baseUrl}/api/employee/updatecandidatedata",
      data: {
        "profileSummary": profileSummary,
        "keySkills": keySkills.map((e) => e.id).toList(),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      _showTopMessage(
        context,
        response.data["message"] ?? "Profile updated successfully.",
      );
      return true;
    }

    _showTopMessage(
      context,
      "Failed to update profile.",
      isError: true,
    );
    return false;
  } on DioException catch (e) {
    debugPrint(e.response?.data.toString());

    String error = "Something went wrong";

    if (e.response?.data is Map &&
        e.response?.data["message"] != null) {
      error = e.response?.data["message"];
    } else if (e.message != null) {
      error = e.message!;
    }

    _showTopMessage(
      context,
      error,
      isError: true,
    );

    return false;
  } catch (e) {
    debugPrint(e.toString());

    _showTopMessage(
      context,
      e.toString(),
      isError: true,
    );

    return false;
  }
}