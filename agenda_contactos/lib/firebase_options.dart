import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyANii82YvKyfIsIgA0uSQIFgP1dgVosups',
    appId: '1:873691682297:web:6e3a32df40adc7d8ae1928',
    messagingSenderId: '873691682297',
    projectId: 'agendacontactos-daf80',
    authDomain: 'agendacontactos-daf80.firebaseapp.com',
    databaseURL: 'https://agendacontactos-daf80-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'agendacontactos-daf80.firebasestorage.app',
    measurementId: 'G-L3NT2QWY7L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANii82YvKyfIsIgA0uSQIFgP1dgVosups',
    appId: '1:873691682297:android:6d134603945819c0ae1928',
    messagingSenderId: '873691682297',
    projectId: 'agendacontactos-daf80',
    databaseURL: 'https://agendacontactos-daf80-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'agendacontactos-daf80.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANii82YvKyfIsIgA0uSQIFgP1dgVosups',
    appId: '1:873691682297:ios:f9eabc25f317c875ae1928',
    messagingSenderId: '873691682297',
    projectId: 'agendacontactos-daf80',
    databaseURL: 'https://agendacontactos-daf80-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'agendacontactos-daf80.firebasestorage.app',
    iosBundleId: 'com.example.agendaContactos',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyANii82YvKyfIsIgA0uSQIFgP1dgVosups',
    appId: '1:873691682297:web:e4bde1a1e1de6f89ae1928',
    messagingSenderId: '873691682297',
    projectId: 'agendacontactos-daf80',
    authDomain: 'agendacontactos-daf80.firebaseapp.com',
    databaseURL: 'https://agendacontactos-daf80-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'agendacontactos-daf80.firebasestorage.app',
    measurementId: 'G-Q72HCK4PNF',
  );
}