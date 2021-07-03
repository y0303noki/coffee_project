import 'package:cloud_firestore/cloud_firestore.dart';

class ShopBrand {
  ShopBrand(DocumentSnapshot doc) {
    id = doc['id'];
    name = doc['name'];
    isCommon = doc.data()['Common'] ?? true;
    isDeleted = doc.data()['isDeleted'];
    createdAt = doc['createdAt'].toDate();
    updatedAt = doc['updatedAt'].toDate();
  }

  String id;
  String name;
  bool isCommon;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
}
