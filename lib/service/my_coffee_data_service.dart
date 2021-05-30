import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MyCoffeeData extends ChangeNotifier {
  // バリテーションエラー
  static const String _validation_error = 'ValidationError';
  get validation_error => _validation_error;

  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<Stream<QuerySnapshot>> findMyAllCoffee() async {
    // userIdは必ず指定する！
    String userId = '';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final QuerySnapshot myCoffeeDataList = await FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .get();

    final docList = myCoffeeDataList.docs.toList();
    if (docList.isEmpty) {
      print('invalid userId!');
      return null;
    }

    // 名前だけ抽出する
    // 更新時刻が新しいものが先頭に来る
    List<String> coffeeNameList = [];
    Map<String, int> groupCounts = Map<String, int>();
    // for (QueryDocumentSnapshot docData in docList) {
    for (int i = 0; i < docList.length; i++) {
      final String name = docList[i].data()['name'];
      // すでにあればカウントプラス
      if (coffeeNameList.isNotEmpty &&
          coffeeNameList.firstWhere(
                (_name) => _name == name,
                orElse: () => null,
              ) !=
              null) {
        groupCounts[name] += 1;
      } else {
        // なければリストに追加
        coffeeNameList.add(name);
        groupCounts[name] = 1;
      }
    }

    return null;
  }

  Stream<QuerySnapshot> findCoffeeAllByUserId() {
    // userIdは必ず指定する！
    String userId = '';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final coffeeAllList = FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
    return coffeeAllList;
  }

  Stream<QuerySnapshot> findUserImageByUserId() {
    // userIdは必ず指定する！
    String userId = 'TEST';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final userImage = FirebaseFirestore.instance
        .collection('user_images')
        .where('userId', isEqualTo: userId)
        .snapshots();

    return userImage;
  }

  Stream<QuerySnapshot> findUserImage(String userImageId) {
    // userIdは必ず指定する！
    String userId = 'TEST';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final userImage = FirebaseFirestore.instance
        .collection('user_images')
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: userImageId)
        .snapshots();

    return userImage;
  }

  void refresh() {
    notifyListeners();
  }
}
