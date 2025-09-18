import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> emailSignUp(String email, String password) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}

final authRepository = Provider((ref) => AuthRepository());

final authState = StreamProvider((ref) {
  final AuthRepository repository = ref.read(authRepository);
  return repository.authStateChanges();
});
