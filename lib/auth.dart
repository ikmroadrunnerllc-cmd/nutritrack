import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<String?> signIn(String email, String pass) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: pass);
    return null;
  } on FirebaseAuthException catch (ex) {
    return ex.message ?? ex.code;
  }
}

Future<String?> signUp(String email, String pass) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: pass);
    return null;
  } on FirebaseAuthException catch (err) {
    debugPrint('signup failed: ${err.code}');
    return err.message ?? err.code;
  }
}

Future<void> signOut() => FirebaseAuth.instance.signOut();
