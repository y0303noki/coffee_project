import 'package:cloud_firestore/cloud_firestore.dart';

class Coffee {
  Coffee(DocumentSnapshot doc) {
    // documentID = doc.documentID;
    id = doc['id'];
    name = doc['name'];
    score = doc['score'];
    coffeeAt = doc['coffeeAt'].toDate();
    createdAt = doc['createdAt'].toDate();
    updatedAt = doc['updatedAt'].toDate();
    memo = doc['memo'];
    isPublic = doc['isPublic'];
    userImageId = doc['userImageId'];
    isMyBottle = doc.data()['isMyBottle'] != null ? doc['isMyBottle'] : false;
  }

  String id;
  String name;
  int score;
  DateTime coffeeAt;
  DateTime createdAt;
  DateTime updatedAt;
  String memo;
  bool isPublic;
  String userImageId;
  bool isMyBottle;

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
