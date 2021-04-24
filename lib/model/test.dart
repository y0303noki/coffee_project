import 'package:cloud_firestore/cloud_firestore.dart';

class Test {
  final String name;
  final int age;
  final DocumentReference reference;

  Test.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['age'] != null),
        name = map['name'],
        age = map['age'];

  Test.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$age>";
}
