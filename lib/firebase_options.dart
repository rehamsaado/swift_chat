
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCgEXW3IeP83G7Sc7gmoecT4JaJO8Tl0Zs',
    appId: '1:989733317884:web:8ae3789281b8085945bb79',
    messagingSenderId: '989733317884',
    projectId: 'swift-chat-69ab7',
    authDomain: 'swift-chat-69ab7.firebaseapp.com',
    storageBucket: 'swift-chat-69ab7.firebasestorage.app',
    measurementId: 'G-XHKHZ4BKH6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzNmjtKWENpDMuOONxBbh7F-0EeutHlzo',
    appId: '1:989733317884:android:c96cf0d25375b1d945bb79',
    messagingSenderId: '989733317884',
    projectId: 'swift-chat-69ab7',
    storageBucket: 'swift-chat-69ab7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyjCpilWkzwZ10NTfDms6NaZVqQ5r97cU',
    appId: '1:989733317884:ios:0b1d5485f4f4930d45bb79',
    messagingSenderId: '989733317884',
    projectId: 'swift-chat-69ab7',
    storageBucket: 'swift-chat-69ab7.firebasestorage.app',
    iosBundleId: 'com.example.swiftChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyjCpilWkzwZ10NTfDms6NaZVqQ5r97cU',
    appId: '1:989733317884:ios:0b1d5485f4f4930d45bb79',
    messagingSenderId: '989733317884',
    projectId: 'swift-chat-69ab7',
    storageBucket: 'swift-chat-69ab7.firebasestorage.app',
    iosBundleId: 'com.example.swiftChat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCgEXW3IeP83G7Sc7gmoecT4JaJO8Tl0Zs',
    appId: '1:989733317884:web:174442a4c89cda1745bb79',
    messagingSenderId: '989733317884',
    projectId: 'swift-chat-69ab7',
    authDomain: 'swift-chat-69ab7.firebaseapp.com',
    storageBucket: 'swift-chat-69ab7.firebasestorage.app',
    measurementId: 'G-1KRN02E0DF',
  );
}
