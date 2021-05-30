import 'package:dss_application/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> getCurrentUser() {
    return _auth.authStateChanges();
  }

  Future<User> signWithEmailAndPassword(String email, String password) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;

    return user;
  }

  Future<void> signInWithGoogleAccount() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(googleAuthCredential);
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
  }

  Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    await _auth.signOut();
  }
}
