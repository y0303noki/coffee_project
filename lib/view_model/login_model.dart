import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/user.dart';
import 'package:coffee_project/model/user_dto.dart';
import 'package:coffee_project/view_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {
  User _user;
  UserData _userData;
  UserModel userModel = new UserModel();

  User get user => _user;
  bool get loggedIn => _user != null;
  UserData get userData => _userData;
  set userData(UserData userData) {
    _userData = userData;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginModel() {
    final User _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }

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

      String userId = _user.uid;
      userModel.userId = userId;
      DocumentSnapshot userDb = await userModel.findUser();

      // fireStoreに登録されているかチェック
      if (userDb != null) {
        // 登録されていれば何もしない
      } else {
        // 登録されていなければ登録
        UserDto userDto = new UserDto();
        DateTime now = DateTime.now();
        userDto.id = _user.uid;
        userDto.status = 0; // ステータス
        userDto.createdAt = now;
        userDto.updatedAt = now;
        userDb = await userModel.addUser(userDto);
      }

      // ユーザーの情報をセットする
      final UserData userData = _setUserMap(userDb);
      _userData = userData;

      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  UserData _setUserMap(DocumentSnapshot data) {
    if (data == null) {
      return null;
    }
    final userData = UserData.fromSnapshot(data);
    return userData;
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
    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signOutWithGoogle() async {
    await GoogleSignIn().signOut();
  }
}
