import 'package:cloud_firestore/cloud_firestore.dart';

class Coffee {
  String name;
  int score;
  DateTime coffeeAt;
  String memo;
  final DocumentReference reference;

  // void setName(String name) {
  //   _name = name;
  // }

  // String getName() {
  //   return _name;
  // }

  // void setScore(int score) {
  //   _score = score;
  // }

  // int getScore() {
  //   return _score;
  // }

  Coffee.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['score'] != null),
        name = map['name'],
        score = map['score'],
        coffeeAt = map['coffeeAt'].toDate(),
        memo = map['memo'];

  Coffee.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$score>";
}
