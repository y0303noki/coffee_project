import 'package:cloud_firestore/cloud_firestore.dart';

class UserImage {
  final String id;
  String userId;
  DateTime createdAt;
  String imageUrl;
  final DocumentReference reference;

  UserImage.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        // userId = map['userId'],
        createdAt = map['createdAt'].toDate(),
        imageUrl = map['imageUrl'];

  UserImage.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
