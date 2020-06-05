import 'package:chat_app/models/messages.dart';
import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Stream<List<User>> userStream() {
    final path = 'users/';
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => User(
              uid: snapshot.data['uid'],
              email: snapshot.data['email'],
              username: snapshot.data['username']),
        )
        .toList());
  }

  // Stream<List<Messages>> messageStream() {}

  Future<void> storeMessages(Messages message) async {
    String path =
        'users/${message.toUid}/from/${message.fromUid}/messages/${message.timeOfMessage.toIso8601String()}';
    final reference = Firestore.instance.document(path);
    await reference.setData(message.toMap());
  }
}
