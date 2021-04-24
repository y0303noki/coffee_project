import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_project/model/coffee.dart';
import 'package:coffee_project/model/coffee_card.dart';
import 'package:flutter/material.dart';

class CardModel extends ChangeNotifier {
  int bottomIndex = 0;

  // Stream<QuerySnapshot> findCardList() {
  //   var a = FirebaseFirestore.instance.collection('test').snapshots();
  //   return a;
  // }
  Stream<QuerySnapshot> findCardList() {
    // userIdは必ず指定する！
    var coffeeCardList = FirebaseFirestore.instance
        .collection('coffee_cards')
        .where('userId', isEqualTo: 100)
        // .orderBy('updatedAt', descending: true)
        .snapshots();
    return coffeeCardList;
  }

  Future<void> addCard(CoffeeCard addCoffeeCard) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = new Map<String, dynamic>();
    addObject['userId'] = 100;
    addObject['name'] = addCoffeeCard.name;
    addObject['score'] = addCoffeeCard.score;
    addObject['memo'] = addCoffeeCard.memo;
    addObject['coffeeAt'] = addCoffeeCard.createdAt; // 作成日時と同じにしておく
    addObject['createdAt'] = addCoffeeCard.createdAt;
    addObject['updatedAt'] = addCoffeeCard.updatedAt;
    addObject['isDeleted'] = false;
    addObject['deletedAt'] = null;

    var result = await FirebaseFirestore.instance
        .collection('coffee_cards')
        .add(addObject);

    var userDoc = await result.get();
    print(userDoc.data());
  }

  void refresh() {
    notifyListeners();
  }
}
