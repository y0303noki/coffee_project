import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CardModel extends ChangeNotifier {
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

  Stream<QuerySnapshot> findCardList() {
    // userIdは必ず指定する！
    String userId = 'TEST';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final coffeeCardList = FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
    return coffeeCardList;
  }

  Future<String> addCard(CoffeeCard addCoffeeCard) async {
    // isLoading = true;
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();
    String userId = LoginModel().user.uid;
    String imageUrl = await uploadImageUrl(addCoffeeCard);
    addObject['userId'] = userId;
    addObject['name'] = addCoffeeCard.name;
    addObject['score'] = addCoffeeCard.score;
    addObject['memo'] = addCoffeeCard.memo;
    addObject['isPublic'] = addCoffeeCard.isPublic;
    addObject['imageUrl'] = imageUrl;
    addObject['coffeeAt'] = addCoffeeCard.createdAt; // 作成日時と同じにしておく
    addObject['createdAt'] = addCoffeeCard.createdAt;
    addObject['updatedAt'] = addCoffeeCard.updatedAt;
    addObject['isDeleted'] = false;
    addObject['deletedAt'] = null;

    try {
      final result = await FirebaseFirestore.instance
          .collection('coffee_cards')
          .add(addObject);
      // isLoading = false;
      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }

    // var userDoc = await result.get();
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
