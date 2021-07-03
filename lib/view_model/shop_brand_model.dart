import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:coffee_project/model/shop_brand.dart';
import 'package:coffee_project/model/shop_brand_dto.dart';
import 'package:coffee_project/model/user_dto.dart';
import 'package:coffee_project/view_model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// ショップorブランドをコレクションに追加する
// 開発者しか利用しない
class ShopBrandModel extends ChangeNotifier {
  // スタンダードプラン MAX5件
  static const standardLimit = 5;
  // プレミアムプラン MAX100件
  static const premiumLimit = 100;

  // コレクション名
  static const shopBrandCollection = 'shopBrands';

  // バリテーションエラー
  static const String _validation_error = 'ValidationError';
  get validation_error => _validation_error;

  String _shopBrandName = '';
  bool isLoading = false;

  get shopBrandName => _shopBrandName;
  set shopBrandName(String shopBrandName) {
    _shopBrandName = shopBrandName;
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // 共有のショップorブランド名を取得する
  Future<List<ShopBrand>> findShopBrand() async {
    final shopBrandInfo = await FirebaseFirestore.instance
        .collection(shopBrandCollection)
        .where('isDeleted', isEqualTo: false)
        .where('isCommon', isEqualTo: true)
        .get();

    List<ShopBrand> shopOrBrands =
        shopBrandInfo.docs.map((doc) => ShopBrand(doc)).toList();

    return shopOrBrands;
  }

  Future<String> addShopBrand(ShopBrandDto shopBrandDto) async {
    // ドキュメント作成
    Map<String, dynamic> shopBrandDoc = new Map<String, dynamic>();

    shopBrandDoc['name'] = shopBrandDto.name;
    shopBrandDoc['isCommon'] = shopBrandDto.isCommon;
    shopBrandDoc['createdAt'] = shopBrandDto.createdAt;
    shopBrandDoc['updatedAt'] = shopBrandDto.updatedAt;
    shopBrandDoc['isDeleted'] = false;

    try {
      final DocumentReference result = await FirebaseFirestore.instance
          .collection(shopBrandCollection)
          .add(shopBrandDoc);

      // final shopBrandInfo = await findShopBrand();
      final data = await result.get();
      final String docId = data.id;
      await _updateDocId(docId);

      return 'ok';
    } catch (e) {
      isLoading = false;
      return 'error';
    }
  }

  // docIdをセットする
  Future<String> _updateDocId(String docId) async {
    // ドキュメント更新
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      final result = await FirebaseFirestore.instance
          .collection(shopBrandCollection)
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
