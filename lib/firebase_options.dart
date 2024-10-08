// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMGEDWJBzlmNuGWloRPJlpI0ZseCyn-k8',
    appId: '1:1034642639369:android:342b7db399a36d8cdb86d8',
    messagingSenderId: '1034642639369',
    projectId: 'yume-fa6f1',
    storageBucket: 'yume-fa6f1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx-ptSGG3CXppvi6relV_U8EagYD8dSAQ',
    appId: '1:1034642639369:ios:d8e6f08c8bf7b00bdb86d8',
    messagingSenderId: '1034642639369',
    projectId: 'yume-fa6f1',
    storageBucket: 'yume-fa6f1.appspot.com',
    androidClientId: '1034642639369-0bg5me4nhpsssmk2dlm3ref666b68cv1.apps.googleusercontent.com',
    iosClientId: '1034642639369-f8snt2ar45oq1m1ls9n7o83ijohipddg.apps.googleusercontent.com',
    iosBundleId: 'com.morpheus.yume',
  );
}
