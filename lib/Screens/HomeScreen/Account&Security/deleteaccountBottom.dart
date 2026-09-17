import 'package:flutter/material.dart';
import 'package:zuperr/Screens/HomeScreen/Account&Security/deletePasswordBottom.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  State<DeleteAccountBottomSheet> createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState
    extends State<DeleteAccountBottomSheet> {

  final List<String> reasons = [
    "Found a new job",
    "Not receiving relevant jobs",
    "Getting too many emails",
    "Getting too many calls from recruiters",
    "Duplicate account",
    "Other reason",
  ];

  String? selectedReason;

  final TextEditingController feedbackController =
      TextEditingController();

 @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return DraggableScrollableSheet(
    initialChildSize: .92,
    minChildSize: .92,
    maxChildSize: .92,
    expand: false,
    builder: (_, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// Drag Handle
              Container(
                width: 82,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xff555555),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  children: [

                    /// Heading
                    const Text(
                      "Delete your Zuperr account permanently?",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff222222),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "On deleting your account, all Zuperr data will be lost.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff7B7B7B),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Tell why you want to delete your account:",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff3D3D3D),
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...reasons.map(
                      (reason) => RadioTheme(
                        data: RadioThemeData(
                          fillColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(
                                  WidgetState.selected)) {
                                return const Color(0xff1D63E8);
                              }
                              return Colors.grey.shade400;
                            },
                          ),
                        ),
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -2),
                          value: reason,
                          groupValue: selectedReason,
                          activeColor: const Color(0xff1D63E8),
                          title: Text(
                            reason,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color(0xff333333),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            "Got anything else you'd like to tell us?",
                        hintStyle: const TextStyle(
                          color: Color(0xffB3B3B3),
                          fontSize: 16,
                        ),
                        contentPadding:
                            const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xff1D63E8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Delete Button
                    SizedBox(
                      height: 58,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff7EB0FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: selectedReason == null
                            ? null
                            : () {
                                Navigator.pop(context);

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:
                                      Colors.transparent,
                                  builder: (_) =>
                                      DeletePasswordBottomSheet(
                                    reason: selectedReason!,
                                    feedback:
                                        feedbackController.text,
                                  ),
                                );
                              },
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Cancel Button
                    SizedBox(
                      height: 58,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xffFFF3F2),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "No, I change my mind",
                          style: TextStyle(
                            color: Color(0xffC52A21),
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * .03),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}