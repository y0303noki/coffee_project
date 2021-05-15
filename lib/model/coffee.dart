import 'package:cloud_firestore/cloud_firestore.dart';

class Coffee {
  String name;
  int score;
  DateTime coffeeAt;
  String memo;
  bool isPublic;
  String userImageId;
  final String id;
  final DocumentReference reference;

  Coffee.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['score'] != null),
        id = map['id'],
        name = map['name'],
        score = map['score'],
        coffeeAt = map['coffeeAt'].toDate(),
        memo = map['memo'],
        isPublic = map['isPublic'],
        userImageId = map['userImageId'];

  Coffee.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$score>";
}
