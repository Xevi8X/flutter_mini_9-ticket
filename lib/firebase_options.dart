// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBUpYs7j8XaCpn-RQ4gRtm_ETaTvWPKNv0',
    appId: '1:761887875961:web:be0f2403aa33a4dc87c5a8',
    messagingSenderId: '761887875961',
    projectId: 'mini-firebase-4037c',
    authDomain: 'mini-firebase-4037c.firebaseapp.com',
    storageBucket: 'mini-firebase-4037c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDi23lkUWjJ5gLVTntubxWciK-SvkqBRkA',
    appId: '1:761887875961:android:c20bb7d5cbde1d7d87c5a8',
    messagingSenderId: '761887875961',
    projectId: 'mini-firebase-4037c',
    storageBucket: 'mini-firebase-4037c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6IPhlm8bwCWCtV625GiMFy3Ay9Y5k2UY',
    appId: '1:761887875961:ios:882bd4bb998377c087c5a8',
    messagingSenderId: '761887875961',
    projectId: 'mini-firebase-4037c',
    storageBucket: 'mini-firebase-4037c.appspot.com',
    iosClientId: '761887875961-ihikj0pa5atmghl2qirnfmdre2f19qfc.apps.googleusercontent.com',
    iosBundleId: 'pl.gajdaw.mini.firebase.flutterFirebaseMini',
  );
}
