import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

// https://medium.com/flutter-community/flutter-firebase-login-using-provider-package-54ee4e5083c7
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth;
  User _user;
  Status _status = Status.uninitialized;

  AuthService.instance() : _auth = FirebaseAuth.instance {
    // _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  User get user => _user;
  FirebaseAuth get auth => _auth;
  Status get status => _status;

  // firebase auth側の匿名認証を有効にするのを忘れずに
  Future<void> signInAnonymously() async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInAnonymously();
      _status = Status.authenticated;
      notifyListeners();
    } catch (e) {
      print(e);
      _status = Status.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.authenticated;
    }
    notifyListeners();
  }
}
