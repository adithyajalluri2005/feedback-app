import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase web is not configured. Add a web app in Firebase and update '
        'firebase_options.dart before running on web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase is configured only for Android and iOS. Add the app config '
          'for this platform with FlutterFire before running here.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDA2THdnROYJyQZ7kH4YjHU9GM6omQpKQ',
    appId: '1:185569988747:android:cfd7687a3fc62d2e21848e',
    messagingSenderId: '185569988747',
    projectId: 'local-vyapari-437e0',
    databaseURL: 'https://local-vyapari-437e0-default-rtdb.firebaseio.com',
    storageBucket: 'local-vyapari-437e0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '185569988747',
    projectId: 'local-vyapari-437e0',
    storageBucket: 'local-vyapari-437e0.firebasestorage.app',
    iosBundleId: 'com.localvyapari.feedbackApp',
  );
}
