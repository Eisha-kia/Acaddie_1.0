// File generated for Firebase Options configuration.
// To auto-generate with your Firebase project:
// flutterfire configure
//
// Or fill in your credentials below:
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
    apiKey: 'AIzaSy-DEMO-API-KEY-ACADDIE-REPLACE-ME',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'acaddie-ai-hackathon',
    authDomain: 'acaddie-ai-hackathon.firebaseapp.com',
    storageBucket: 'acaddie-ai-hackathon.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSy-DEMO-API-KEY-ACADDIE-REPLACE-ME',
    appId: '1:1234567890:android:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'acaddie-ai-hackathon',
    storageBucket: 'acaddie-ai-hackathon.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSy-DEMO-API-KEY-ACADDIE-REPLACE-ME',
    appId: '1:1234567890:ios:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'acaddie-ai-hackathon',
    storageBucket: 'acaddie-ai-hackathon.appspot.com',
    iosBundleId: 'com.aust.acaddie',
  );
}
