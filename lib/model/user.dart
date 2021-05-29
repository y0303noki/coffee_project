import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * ユーザーデータ
 */
class UserData {
  final String id;
  DateTime createdAt;
  DateTime updatedAt;
  String googleId;
  int status;
  bool isDeleted;

  final DocumentReference reference;

  UserData.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        googleId = map['googleId'],
        createdAt = map['createdAt'].toDate(),
        updatedAt = map['updatedAt'].toDate(),
        status = map['status'],
        isDeleted = map['isDeleted'];

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
