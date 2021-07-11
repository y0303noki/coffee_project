import 'package:cloud_firestore/cloud_firestore.dart';

class Coffee {
  Coffee(DocumentSnapshot doc) {
    // documentID = doc.documentID;
    id = doc['id'];
    name = doc['name'];
    score = doc['score'];
    favorite = doc.data()['favorite'] ?? 0;
    coffeeAt = doc['coffeeAt'].toDate();
    createdAt = doc['createdAt'].toDate();
    updatedAt = doc['updatedAt'].toDate();
    shopOrBrandName = doc.data()['shopOrBrandName'] ?? '';
    isPublic = doc['isPublic'];
    userImageId = doc['userImageId'];
  }

  String id;
  String name;
  int score;
  int favorite;
  DateTime coffeeAt;
  DateTime createdAt;
  DateTime updatedAt;
  String shopOrBrandName;
  bool isPublic;
  String userImageId;

  // final DocumentReference reference;

  // Coffee.fromMap(Map<String, dynamic> map, {this.reference})
  //     : assert(map['name'] != null),
  //       assert(map['score'] != null),
  //       id = map['id'],
  //       name = map['name'],
  //       score = map['score'],
  //       coffeeAt = map['coffeeAt'].toDate(),
  //       memo = map['memo'],
  //       isPublic = map['isPublic'],
  //       userImageId = map['userImageId'];

  // Coffee.fromSnapshot(DocumentSnapshot snapshot)
  //     : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // @override
  // String toString() => "Record<$name:$score>";
}
