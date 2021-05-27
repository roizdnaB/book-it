import 'package:firebase_auth/firebase_auth.dart';

class FirestoreProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (_) {
      throw SignInWithEmailAndPasswordException();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw SignOutException();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (_) {
      throw SignUpException();
    }
  }

  String getUserUid() => _auth.currentUser.uid;
}

class SignInWithEmailAndPasswordException implements Exception {}

class SignOutException implements Exception {}

class SignUpException implements Exception {}
