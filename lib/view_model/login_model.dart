import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {
  User _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginModel() {
    final User _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }

  User get user => _user;
  bool get loggedIn => _user != null;
  // 認証ログイン処理
  Future<bool> loginTypeTo(String loginType) async {
    try {
      UserCredential _userCredential;
      if (loginType == 'ANONUMOUSLY') {
        _userCredential = await signInAnon();
      } else if (loginType == 'GOOGLE') {
        _userCredential = await _signInWithGoogle();
      }
      _user = _userCredential.user;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // ログアウト処理
  Future<void> logout() async {
    _user = null;
    await _auth.signOut();
    await _signOutWithGoogle();
    notifyListeners();
  }

  // 匿名ログイン
  Future<UserCredential> signInAnon() async {
    UserCredential user = await _auth.signInAnonymously();
    return user;
  }

  // GOOGLEログイン
  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _signOutWithGoogle() async {
    await GoogleSignIn().signOut();
  }
}
