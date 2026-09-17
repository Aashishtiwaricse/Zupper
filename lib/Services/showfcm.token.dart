import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> showFcmToken() async {
  final token = await FirebaseMessaging.instance.getToken();

  if (token == null) return;

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "FCM Registration Token",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // User can select and copy manually
          SelectableText(token),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text("Copy Token"),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: token),
              );

              Get.back();

              Get.snackbar(
                "Copied",
                "FCM token copied to clipboard",
              );
            },
          ),
        ],
      ),
    ),
  );
}