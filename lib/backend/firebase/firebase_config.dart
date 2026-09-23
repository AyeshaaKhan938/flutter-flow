import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAaA-mK4eyGOOLPwdmwr1j1TKpodQaPv3E",
            authDomain: "kingdom-heirs-discipleshipapp.firebaseapp.com",
            projectId: "kingdom-heirs-discipleshipapp",
            storageBucket: "kingdom-heirs-discipleshipapp.firebasestorage.app",
            messagingSenderId: "455899201651",
            appId: "1:455899201651:web:04e30e9b1e70b8002daa06"));
  } else {
    await Firebase.initializeApp();
  }
}
