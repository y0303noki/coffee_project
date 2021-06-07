import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/user_dto.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserModel extends ChangeNotifier {
  // スタンダードプラン MAX5件
  static const standardLimit = 5;
  // プレミアムプラン MAX100件
  static const premiumLimit = 100;

  // ユーザーのコレクション名
  static const usersCollection = 'users';

  // バリテーションエラー
  static const String _validation_error = 'ValidationError';
  get validation_error => _validation_error;

  String _userId = '';
  bool isLoading = false;
  int _status = -1;
  DateTime _notiTime;

  get userId => _userId;
  set userId(String userId) {
    _userId = userId;
  }

  get status => _status;
  set status(int status) {
    _status = status;
  }

  get notiTime => _notiTime;
  set notiTime(DateTime notiTime) {
    _notiTime = notiTime;
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<DocumentSnapshot> findUser() async {
    final userInfo =
        FirebaseFirestore.instance.collection(usersCollection).doc(_userId);

    final data = await userInfo.get();

    return data;
  }

  Stream<QuerySnapshot> findUserQuerySnapshot() {
    // userIdは必ず指定する！
    String userId = 'TEST';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final userImage = FirebaseFirestore.instance
        .collection(usersCollection)
        .where('id', isEqualTo: userId)
        .snapshots();

    return userImage;
  }

  Future<DocumentSnapshot> addUser(UserDto userDto) async {
    // ドキュメント作成
    Map<String, dynamic> userDoc = new Map<String, dynamic>();

    userDoc['id'] = userDto.id;
    userDoc['status'] = userDto.status;
    userDoc['googleId'] = userDto.googleId;
    userDoc['createdAt'] = userDto.createdAt; // 作成日時と同じにしておく
    userDoc['updatedAt'] = userDto.updatedAt;
    userDoc['isDeleted'] = false;

    try {
      FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(userDto.id)
          .set(userDoc);

      final userInfo = await findUser();
      return userInfo;
    } catch (e) {
      isLoading = false;
      return null;
    }
  }

  // 更新する情報をセットする
  Future<Map<String, dynamic>> _setUpdateUser(UserDto userDto) async {
    Map<String, dynamic> result = {};
    DateTime now = DateTime.now();
    result['updatedAt'] = now;

    if (userDto.status >= 0) {
      result['status'] = userDto.status;
    }

    if (userDto.googleId != null) {
      result['googleId'] = userDto.googleId;
    }

    return result;
  }

  // 更新する情報をセットする
  Future<Map<String, dynamic>> _updateNotificationAt(UserDto userDto) async {
    Map<String, dynamic> result = {};
    result['notificationAt'] = userDto.notificationAt;
    return result;
  }

  Future<String> updateUser(UserDto userDto) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = await _setUpdateUser(userDto);
    final String docId = userDto.id;
    if (docId == null) {
      return null;
    }

    try {
      final result = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(docId)
          .update(updateData);
      // isLoading = false;
      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }
  }

  Future<String> updateNotificationAt(UserDto userDto) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = await _updateNotificationAt(userDto);
    final String docId = userDto.id;
    if (docId == null) {
      return null;
    }

    try {
      final result = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(docId)
          .update(updateData);
      // isLoading = false;
      // _notiTime = userDto.notificationAt;
      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }
  }

  void refresh() {
    notifyListeners();
  }
}
