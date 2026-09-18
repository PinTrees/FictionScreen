import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCO3-5xCOmU9MpmxsQb-7Bs8pDur4xrMyE',
    appId: '1:176523184999:web:640e6d8e89ef5a07d6bdc2',
    messagingSenderId: '176523184999',
    projectId: 'fiction-screen',
    authDomain: 'fiction-screen.firebaseapp.com',
    storageBucket: 'fiction-screen.firebasestorage.app',
    measurementId: 'G-Q5ZDNWM16S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO3-5xCOmU9MpmxsQb-7Bs8pDur4xrMyE',
    appId: '1:176523184999:web:640e6d8e89ef5a07d6bdc2',
    messagingSenderId: '176523184999',
    projectId: 'fiction-screen',
    storageBucket: 'fiction-screen.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCO3-5xCOmU9MpmxsQb-7Bs8pDur4xrMyE',
    appId: '1:176523184999:web:640e6d8e89ef5a07d6bdc2',
    messagingSenderId: '176523184999',
    projectId: 'fiction-screen',
    storageBucket: 'fiction-screen.firebasestorage.app',
  );
}
