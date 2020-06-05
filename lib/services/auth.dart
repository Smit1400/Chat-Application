import 'package:chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Auth {
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String username);
  Future<void> signInUserWithEmailAndPassword(String email, String password);
  Future<User> signInWithGoogle(String username);
  Future<void> logout();
  Stream<User> get onAuthStateChanged;
}

class AuthService extends Auth {
  final _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final reference =
          Firestore.instance.document('users/${authResult.user.uid}');
      Map<String, dynamic> data =
          User(uid: '${authResult.user.uid}', email: email, username: username)
              .toMap();
      await reference.setData(data);
      FirebaseUser user = authResult.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> signInWithGoogle(String username) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        final reference =
            Firestore.instance.document('users/${authResult.user.uid}');
        Map<String, dynamic> data = User(
                uid: '${authResult.user.uid}',
                email: '${authResult.user.email}',
                username: '${authResult.user.email.split('@')[0]}')
            .toMap();
        await reference.setData(data);
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          details: 'Missing google auth token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        details: 'Sign In Aborted By User',
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
