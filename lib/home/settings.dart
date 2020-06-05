import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  final User user;
  Settings({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Settings'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('asset/images.jpeg'),
                radius: 50,
              ),
              SizedBox(height: 10),
              TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 1000),
                repeatForever: true,
                text: ['${user.username}'],
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                '${user.email}',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
