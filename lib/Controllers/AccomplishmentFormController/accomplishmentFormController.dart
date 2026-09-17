import 'package:flutter/material.dart';

class AccomplishmentFormController {
  // ---------- Step 1 : Certification ----------

  final certificationName = TextEditingController();
  final certificationId = TextEditingController();
  final certificationUrl = TextEditingController();

  final validityMonth = TextEditingController();
  final validityYear = TextEditingController();

  bool noExpiry = false;

  // ---------- Step 2 : Awards ----------

  final awardDescription = TextEditingController();

  // ---------- Step 3 : Committee / Clubs ----------

  final clubName = TextEditingController();
  final positionHeld = TextEditingController();
  final educationReference = TextEditingController();

  final fromDate = TextEditingController();
  final toDate = TextEditingController();

  bool currentlyHolding = false;

  final responsibilities = TextEditingController();

  String? uploadedFile;
  String? uploadedFilePath;

  // ---------- Form Keys ----------

  final formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  void dispose() {
    certificationName.dispose();
    certificationId.dispose();
    certificationUrl.dispose();

    validityMonth.dispose();
    validityYear.dispose();

    awardDescription.dispose();

    clubName.dispose();
    positionHeld.dispose();
    educationReference.dispose();

    fromDate.dispose();
    toDate.dispose();

    responsibilities.dispose();
  }
}