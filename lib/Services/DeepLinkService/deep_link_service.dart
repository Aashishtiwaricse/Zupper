import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();

  static StreamSubscription<Uri>? _linkSubscription;

  /// Called when the app is completely closed and opened through a link.
  static Future<Uri?> getInitialLink() async {
    try {
      final Uri? uri = await _appLinks.getInitialLink();

      print("========================================");
      print("🔥 INITIAL DEEP LINK");
      print("URI: $uri");
      print("========================================");

      return uri;
    } catch (e) {
      print("❌ INITIAL DEEP LINK ERROR: $e");
      return null;
    }
  }

  /// Listen when the app is already running/backgrounded
  /// and another deep link is opened.
  static void listen(void Function(Uri uri) onLink) {
    _linkSubscription?.cancel();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        print("========================================");
        print("🔥 DEEP LINK RECEIVED");
        print("URI: $uri");
        print("========================================");

        onLink(uri);
      },
      onError: (error) {
        print("❌ DEEP LINK STREAM ERROR: $error");
      },
    );
  }

  static String? extractJobId(Uri uri) {
    final segments = uri.pathSegments;

    print("🔥 PATH SEGMENTS: $segments");

    final jobsIndex = segments.indexOf("jobs");

    if (jobsIndex != -1 && jobsIndex + 1 < segments.length) {
      final jobId = segments[jobsIndex + 1];

      print("🔥 EXTRACTED JOB ID: $jobId");

      return jobId;
    }

    print("❌ JOB ID NOT FOUND");

    return null;
  }

  static Future<void> dispose() async {
    await _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}