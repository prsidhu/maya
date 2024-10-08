import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maya/src/config/events.dart';
import 'package:maya/src/utils/analytics.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    Events().loginWithEmail(cred.user?.displayName);
    Analytics().setIdentity(
        {'displayName': cred.user?.displayName, 'uid': cred.user?.uid});
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential cred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    Events().loginWithGoogle(cred.user?.displayName);
    Analytics().setIdentity(
        {'displayName': cred.user?.displayName, 'uid': cred.user?.uid});
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
