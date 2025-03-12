import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/services/user_firestore.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Future<User?> signInWithUsername(String username, String password) async {
  //   try {
  //     final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future<User?> signUp({required email, required password, required username, required displayName}) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserFirestoreServices().createUserData(username, displayName, email, userCredential.user!.uid);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
