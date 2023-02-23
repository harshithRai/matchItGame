import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  String _userId;
  String get userId => _userId;
  List<String> _providerId = [];
  bool _isAnonymous = true;
  bool _isLoggedIn = false;
  String _userName = '';
  String get userName => _userName;

  List<String> get providerId => _providerId;
  bool get isAnonymous => _isAnonymous;
  bool get isLoggedIn => _isLoggedIn;

  // Future<String> signInWithGoogle() async {
  //   var currentUser = _firebaseAuth.currentUser;

  //   // final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  //   // final GoogleSignInAuthentication googleSignInAuthentication =
  //   //     await googleSignInAccount.authentication;

  //   // final AuthCredential credential = GoogleAuthProvider.credential(
  //   //   accessToken: googleSignInAuthentication.accessToken,
  //   //   idToken: googleSignInAuthentication.idToken,
  //   // );

  //   // final UserCredential authResult =
  //   //     await _firebaseAuth.signInWithCredential(credential);

  //   // if (currentUser != null && authResult.additionalUserInfo.isNewUser) {
  //   //   await currentUser.linkWithCredential(credential);
  //   // }

  //   // _userName = authResult.user.displayName;

  //   return null;
  // }

  Future<void> signOutGoogle() async {
    await _firebaseAuth.signOut();
    // await googleSignIn.signOut();
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential authResult = await _firebaseAuth.signInAnonymously();
      _isAnonymous = authResult.user.isAnonymous;
      _userId = authResult.user.uid;
      _isLoggedIn = true;
      // _providerId.add("anonymous");
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserLoginStatus() async {
    try {
      var currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        _userId = currentUser.uid;
        _isAnonymous = currentUser.isAnonymous;
        if (!currentUser.isAnonymous) {
          _userName = currentUser.displayName;
        }
        _isLoggedIn = true;
      }
    } catch (e) {
      print(e);
    }
  }
}
