import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CardModel extends ChangeNotifier {
  // スタンダードプラン MAX5件
  static const standardLimit = 5;
  // プレミアムプラン MAX100件
  static const premiumLimit = 100;

  int bottomIndex = 0;
  File imageFile;
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Stream<QuerySnapshot> findCardListHome() {
    // userIdは必ず指定する！
    String userId = 'TEST';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final coffeeCardList = FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(standardLimit)
        .snapshots();
    return coffeeCardList;
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

  Future<DocumentSnapshot> getUserInfo(String uid) {
    String userId = 'TEST';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }

    final userImage =
        FirebaseFirestore.instance.collection('user_images').doc(uid).get();

    return userImage;
  }

  Future<String> addCard(CoffeeCard addCoffeeCard) async {
    // isLoading = true;
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();
    String userId = LoginModel().user.uid;

    addObject['userId'] = userId;
    addObject['name'] = addCoffeeCard.name;
    addObject['score'] = addCoffeeCard.score;
    addObject['memo'] = addCoffeeCard.memo;
    addObject['isPublic'] = addCoffeeCard.isPublic;
    // addObject['imageUrl'] = imageUrl;
    addObject['coffeeAt'] = addCoffeeCard.createdAt; // 作成日時と同じにしておく
    addObject['createdAt'] = addCoffeeCard.createdAt;
    addObject['updatedAt'] = addCoffeeCard.updatedAt;
    addObject['isDeleted'] = false;
    addObject['deletedAt'] = null;

    String imageUrl = await uploadImageUrl(addCoffeeCard);
    String userImageId = null;

    // 画像アップロード
    if (imageFile != null) {
      try {
        userImageId = await addUserImageUrl(imageUrl);
      } catch (e) {
        // 画像アップロードエラー
        print(e);
      }
    }

    addObject['userImageId'] = userImageId;

    try {
      final DocumentReference result = await FirebaseFirestore.instance
          .collection('coffee_cards')
          .add(addObject);
      final data = await result.get();
      final String docId = data.id;
      await _updateCardDocId(docId);
      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }
  }

  // userとimageのコレクション 1:n
  // コレクションに追加したらdocIdを返す
  Future<String> addUserImageUrl(String imageUrl) async {
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
      final DocumentReference result = await FirebaseFirestore.instance
          .collection('user_images')
          .add(addObject);
      final data = await result.get();
      final String docId = data.id;
      await _updateUserImageDocId(docId);
      return docId;
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

    if (updateCard.imageUrl != null) {
      result['imageUrl'] = updateCard.imageUrl;
    }

    if (updateCard.score != null) {
      result['score'] = updateCard.score;
    }

    if (imageFile != null) {
      String imageUrl = await uploadImageUrl(updateCard);
      result['imageUrl'] = imageUrl;
    }
    return result;
  }

  Future<String> updateCard(CoffeeCard updateCard) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = await _setUpdateCard(updateCard);
    final String docId = updateCard.id;
    if (docId == null) {
      print('aaaa');
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

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('pickedfile is null');
      return;
    }
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  // storageへアップロード
  Future<String> uploadImageUrl(CoffeeCard addCoffeeCard) async {
    if (imageFile == null) {
      return null;
    }
    final storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage
        .ref()
        .child("coffeeImages/${addCoffeeCard.name}")
        .putFile(imageFile);

    final downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void refresh() {
    notifyListeners();
  }
}
