import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authNotifierProvider = Provider<AuthNotifier>((ref) => AuthNotifier());

class AuthNotifier {
  final _auth = FirebaseAuth.instance;

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'user-not-found' => 'No admin account found with that email.',
        'wrong-password' => 'Incorrect password.',
        'invalid-credential' => 'Invalid email or password.',
        'user-disabled' => 'This account has been disabled.',
        _ => e.message ?? 'Sign-in failed.',
      };
    }
  }

  Future<void> signOut() => _auth.signOut();
}
