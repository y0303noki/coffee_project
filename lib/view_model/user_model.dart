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

  get userId => _userId;
  set userId(String userId) {
    _userId = userId;
  }

  get status => _status;
  set status(int status) {
    _status = status;
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

  // userとimageのコレクション 1:n
  // コレクションに追加したらdocIdを返す
  Future<String> addUserImageUrl(String imageUrl, String uuId) async {
    // ドキュメント作成
    DateTime now = DateTime.now();
    Map<String, dynamic> addObject = new Map<String, dynamic>();
    String userId = LoginModel().user.uid;
    addObject['userId'] = userId;
    addObject['imageUrl'] = imageUrl;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;
    addObject['isDeleted'] = false;
    addObject['deletedAt'] = null;

    try {
      var result = FirebaseFirestore.instance
          .collection('user_images')
          .doc(uuId)
          .set(addObject);

      await _updateUserImageDocId(uuId);
      return uuId;
    } catch (e) {
      isLoading = false;
      return null;
    }
  }

  // 更新する情報をセットする
  Future<Map<String, dynamic>> _setUpdateCard(CoffeeCard updateCard) async {
    Map<String, dynamic> result = {};
    DateTime now = DateTime.now();
    result['updatedAt'] = now;

    if (updateCard.name != null) {
      result['name'] = updateCard.name;
    }

    if (updateCard.memo != null) {
      result['memo'] = updateCard.memo;
    }

    result['userImageId'] = updateCard.userImageId;

    if (updateCard.score != null) {
      result['score'] = updateCard.score;
    }

    return result;
  }

  Future<String> updateCard(CoffeeCard updateCard) async {
    // 名前のバリテーション
    if (updateCard.name == null ||
        updateCard.name.isEmpty ||
        updateCard.name.length >= 20) {
      return validation_error;
    }
    // ひとことのバリテーション
    if (updateCard.memo != null && updateCard.memo.length >= 20) {
      return validation_error;
    }
    // おすすめのバリテーション
    if (updateCard.score == null ||
        updateCard.score < 0 ||
        updateCard.score > 5) {
      return validation_error;
    }
    // ドキュメント更新
    Map<String, dynamic> updateData = await _setUpdateCard(updateCard);
    final String docId = updateCard.id;
    if (docId == null) {
      return null;
    }

    try {
      final result = await FirebaseFirestore.instance
          .collection('coffee_cards')
          .doc(docId)
          .update(updateData);
      // isLoading = false;
      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }
  }

  // docIdをセットする
  Future<String> _updateCardDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result = await FirebaseFirestore.instance
          .collection('coffee_cards')
          .doc(docId)
          .update(updateData);
      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }
  }

  // docIdをセットする
  Future<String> _updateUserImageDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result = await FirebaseFirestore.instance
          .collection('user_images')
          .doc(docId)
          .update(updateData);
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
