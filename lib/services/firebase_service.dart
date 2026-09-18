import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseService {
  static bool isInitialized = false;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isInitialized = true;
      debugPrint('[FirebaseService] Firebase initialized successfully with project: ${DefaultFirebaseOptions.currentPlatform.projectId}');
    } catch (e) {
      debugPrint('[FirebaseService] Firebase initialization failed or running in preview: $e');
    }
  }
}
