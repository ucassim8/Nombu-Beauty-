// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Generated manually for NOMBU Beauty Flutter Web app
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: 'AIzaSyBkNzkvs_cjSzArtfGUBihoRmI2c6t81ak',
        appId: '1:292436776591:web:ea3e6e2f400ee6ce2e02fa',
        messagingSenderId: '292436776591',
        projectId: 'nombu-beauty',
        authDomain: 'nombu-beauty.firebaseapp.com',
        storageBucket: 'nombu-beauty.firebasestorage.app',
        measurementId: 'G-TPBFEV2XQY',
      );
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions is only configured for Web.',
      );
    }
  }
}
