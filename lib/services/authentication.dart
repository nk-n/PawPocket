import 'package:firebase_auth/firebase_auth.dart';
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
    } on FirebaseAuthException{
      rethrow;
    }
  }

  Future<User?> signInWithUsername({required String username, required String password}) async {
    var email = await UserFirestoreServices().checkUserExistWithUsername(username);
    return signInWithEmail(email: email, password: password);
  }

  Future<User?> signUp({required email, required password, required username, required displayName}) async {
    try {
      var usernameToMail = await UserFirestoreServices().checkUserExistWithUsername(username);
      if (usernameToMail.isNotEmpty) {
        throw FirebaseAuthException(code: 'invalid-email', message: 'This username is already being used.');
      }
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
