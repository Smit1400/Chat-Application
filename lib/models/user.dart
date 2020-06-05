import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String email;
  final String username;
  User({@required this.uid, this.email, this.username});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
    };
  }
}
