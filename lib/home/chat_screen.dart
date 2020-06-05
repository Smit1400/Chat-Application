import 'package:chat_app/models/messages.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime get getTime => DateTime.now();

class ChatScreen extends StatelessWidget {
  final User user;
  final User currentUser;
  final Database database;
  ChatScreen({this.user, this.currentUser, this.database});

  TextEditingController _messageController = TextEditingController();

  Stream<List<Messages>> get userMessages {
    final path1 = '/users/${currentUser.uid}/from/${user.uid}/messages';

    final reference = Firestore.instance.collection(path1);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map((snap) => Messages(
              fromUid: snap.data['fromUid'],
              toUid: snap.data['toUid'],
              timeOfMessage: snap.data['timeOfMessage'].toDate(),
              message: snap.data['message'],
            ))
        .toList());
  }

  Stream<List<Messages>> get currentUserMessages {
    final path1 = '/users/${user.uid}/from/${currentUser.uid}/messages';

    final reference = Firestore.instance.collection(path1);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map((snap) => Messages(
              fromUid: snap.data['fromUid'],
              toUid: snap.data['toUid'],
              timeOfMessage: snap.data['timeOfMessage'].toDate(),
              message: snap.data['message'],
            ))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('${user.username}'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: currentUserMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List data1 = snapshot.data;
            return StreamBuilder<List<Messages>>(
              stream: userMessages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  List data2 = snapshot.hasData ? snapshot.data : List();
                  List data = data1 + data2;
                  data.sort((a, b) {
                    var adate =
                        a.timeOfMessage; //before -> var adate = a.expiry;
                    var bdate = b.timeOfMessage; //var bdate = b.expiry;
                    return -adate.compareTo(bdate);
                  });
                  data = List.from(data.reversed);
                  return ListView.builder(
                      itemCount: data.isNotEmpty ? data.length : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: data[index].fromUid == user.uid
                              ? Text(
                                  '${data[index].message}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(''),
                          trailing: data[index].fromUid == currentUser.uid
                              ? Text('${data[index].message}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold))
                              : Text(''),
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message.....',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(Icons.send, color: Colors.black),
                onTap: () async {
                  Messages message = Messages(
                      fromUid: currentUser.uid,
                      toUid: user.uid,
                      timeOfMessage: getTime,
                      message: _messageController.text);
                  await database.storeMessages(message);
                  _messageController.clear();
                  print("message sent");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
