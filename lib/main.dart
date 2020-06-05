import 'package:chat_app/landing.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(
      create: (context) => AuthService(),
      child: MaterialApp(
        home: LandingPage(),
      ),
    );
  }
}
