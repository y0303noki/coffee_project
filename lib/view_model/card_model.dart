import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/shop_brand.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:coffee_project/view_model/shop_brand_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CardModel extends ChangeNotifier {
  // スタンダードプラン 20件
  static const standardLimit = 20;
  // プレミアムプラン 100件
  static const premiumLimit = 100;

  // バリテーションエラー
  static const String _validation_error = 'ValidationError';
  get validation_error => _validation_error;

  int bottomIndex = 0;
  File imageFile;
  bool isLoading = false;
  String searchKeyword = '';

  String userImageId;
  // String get userImageId => _userImageId;

  List<Coffee> _thisMonthCoffee = [];
  List<Coffee> get thisMonthCoffee => _thisMonthCoffee;

  List<Coffee> _homeCoffee = [];
  List<Coffee> get homeCoffee => _homeCoffee;

  List<Coffee> _limitMyCoffee = [];
  List<Coffee> get limitMyCoffee => _limitMyCoffee;

  List<ShopBrand> _shopOrBrandList = [];
  List<ShopBrand> get shopOrBrandList => _shopOrBrandList;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // Stream<QuerySnapshot> findCardListHome() {
  //   // userIdは必ず指定する！
  //   String userId = 'TEST';
  //   if (LoginModel().user != null) {
  //     userId = LoginModel().user.uid;
  //   }
  //   final coffeeCardList = FirebaseFirestore.instance
  //       .collection('coffee_cards')
  //       .where('userId', isEqualTo: userId)
  //       .orderBy('updatedAt', descending: true)
  //       .limit(standardLimit)
  //       .snapshots();
  //   return coffeeCardList;
  // }

  Future<List<Coffee>> findCardListHome() async {
    // userIdは必ず指定する！
    String userId = '';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final coffeeCardList = await FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(standardLimit)
        .get();

    List<Coffee> coffees =
        coffeeCardList.docs.map((doc) => Coffee(doc)).toList();
    this._homeCoffee = coffees;
    notifyListeners();
    return coffees;
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
        .orderBy('updatedAt', descending: true)
        .snapshots();

    return userImage;
  }

  Future<List<Coffee>> findThisMonthMyCoffee() async {
    // userIdは必ず指定する！
    String userId = '';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }

    DateTime nowDate = DateTime.now();

    final snapshot = await FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .where('updatedAt',
            isGreaterThanOrEqualTo: DateTime(nowDate.year, nowDate.month, 1))
        .orderBy('updatedAt', descending: true)
        .get();

    List<Coffee> coffees = snapshot.docs.map((doc) => Coffee(doc)).toList();
    this._thisMonthCoffee = coffees;
    notifyListeners();
    return coffees;
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

  Future<List<ShopBrand>> _findShopOrBrandList(int limit) async {
    final shopBrandModel = ShopBrandModel();
    final List<ShopBrand> list = await shopBrandModel.findShopBrand();

    // this._shopOrBrandList = list;
    // notifyListeners();
    return this._shopOrBrandList;
  }

  Future<List<Coffee>> findMyCoffeeLimitTo(int limit) async {
    // userIdは必ず指定する！
    String userId = '';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .get();

    List<Coffee> coffees = snapshot.docs.map((doc) => Coffee(doc)).toList();
    this._limitMyCoffee = coffees;

    final shopBrandModel = ShopBrandModel();
    this._shopOrBrandList = await shopBrandModel.findShopBrand();
    notifyListeners();
    return coffees;
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
    // 名前のバリテーション
    if (addCoffeeCard.name == null ||
        addCoffeeCard.name.isEmpty ||
        addCoffeeCard.name.length >= 20) {
      return validation_error;
    }
    // 店名/ブランド名のバリテーション
    if (addCoffeeCard.shopOrBrandName != null &&
        addCoffeeCard.shopOrBrandName.length >= 20) {
      return validation_error;
    }
    // おすすめのバリテーション
    if (addCoffeeCard.score == null ||
        addCoffeeCard.score < 0 ||
        addCoffeeCard.score > 5) {
      return validation_error;
    }
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();
    String userId = LoginModel().user.uid;

    // アルバムから画像を選択された場合はaddCoffeeCardにuserImageIdが設定されている
    String userImageId = addCoffeeCard.userImageId ?? Uuid().v4();

    addObject['userId'] = userId;
    addObject['name'] = addCoffeeCard.name;
    addObject['score'] = addCoffeeCard.score;
    addObject['shopOrBrandName'] = addCoffeeCard.shopOrBrandName;
    addObject['isPublic'] = addCoffeeCard.isPublic;
    addObject['userImageId'] = userImageId;
    addObject['coffeeAt'] = addCoffeeCard.createdAt; // 作成日時と同じにしておく
    addObject['createdAt'] = addCoffeeCard.createdAt;
    addObject['updatedAt'] = addCoffeeCard.updatedAt;
    addObject['isDeleted'] = false;
    addObject['deletedAt'] = null;

    String imageUrl = await uploadImageUrl(addCoffeeCard, userImageId);
    // 画像アップロード
    if (imageFile != null) {
      try {
        await addUserImageUrl(imageUrl, userImageId);
      } catch (e) {
        // 画像アップロードエラー
        print(e);
      }
    }

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

    if (updateCard.shopOrBrandName != null) {
      result['shopOrBrandName'] = updateCard.shopOrBrandName;
    }

    result['userImageId'] = updateCard.userImageId;

    if (updateCard.score != null) {
      result['score'] = updateCard.score;
    }

    if (imageFile != null) {
      // user_imagesのidとstorageのid
      final String uuId = Uuid().v4();

      String imageUrl = await uploadImageUrl(updateCard, uuId);
      result['userImageId'] = uuId;
      // 画像アップロード
      if (imageFile != null) {
        try {
          await addUserImageUrl(imageUrl, uuId);
        } catch (e) {
          // 画像アップロードエラー
          print(e);
        }
      }
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
    // 店名/ブランド名
    if (updateCard.shopOrBrandName != null &&
        updateCard.shopOrBrandName.length >= 20) {
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

  Future<void> deleteUserImageFunc(String docId) {
    _deleteUserImageDocId(docId);
    _deleteStorageByUserImageId(docId);
  }

  // user_imagesのデータを物理削除
  Future<String> _deleteUserImageDocId(String docId) async {
    // ドキュメント削除
    try {
      await FirebaseFirestore.instance
          .collection('user_images')
          .doc(docId)
          .delete();
      return 'delete ok';
    } catch (e) {
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

  Future showImageCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile == null) {
      print('pickedfile is null');
      return;
    }
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  // storageへアップロード
  Future<String> uploadImageUrl(CoffeeCard addCoffeeCard, String uuId) async {
    if (imageFile == null) {
      return null;
    }
    String userId = 'errorUserId';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage
        .ref()
        .child("coffeeImages/user/$userId/$uuId")
        .putFile(imageFile);

    final downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  // fireStorageからファイルを削除する
  Future<void> _deleteStorageByUserImageId(String id) async {
    String userId = 'errorUserId';
    if (LoginModel().user != null) {
      userId = LoginModel().user.uid;
    }
    final storage = FirebaseStorage.instance;
    var storageRef = storage.ref().child('coffeeImages/user/$userId/$id');

    try {
      storageRef.delete();
    } catch (e) {
      print('fireStorage の削除に失敗しました。');
    }
  }

  void refresh() {
    notifyListeners();
  }
}
