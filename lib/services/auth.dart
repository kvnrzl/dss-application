import 'package:dss_application/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> getCurrentUserStream() {
    return _auth.authStateChanges();
  }

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signInWithGoogleAccount() async {
    try {
      // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      GoogleSignIn googleSignIn = GoogleSignIn();

      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(googleAuthCredential);
      User user = userCredential.user;

      if (userCredential != null) {
        Map<String, dynamic> userInfoMap = {
          // "userid": user.uid,
          "username": user.email.replaceAll("@gmail.com", ""),
          "userDisplayName": user.displayName,
          "userEmail": user.email,
          "userProfilePic": user.photoURL,
          "userPhoneNumber": user.phoneNumber
        };

        DatabaseService().addUserIntoDatabase(user.uid, userInfoMap);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
