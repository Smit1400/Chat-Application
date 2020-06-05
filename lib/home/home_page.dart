import 'package:chat_app/home/chat_screen.dart';
import 'package:chat_app/home/settings.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  User user;
  HomePage({this.user});
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(user: user),
                  fullscreenDialog: false,
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: Text('Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder<List<User>>(
        stream: database.userStream(),
        builder: (context, snapshot) {
          List<User> userData = snapshot.data;
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                if (userData[index].uid == user.uid) {
                  user = userData[index];
                }
                return userData[index].uid != user.uid
                    ? ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                user: userData[index],
                                currentUser: user,
                                database: database,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        title: Text('${userData[index].username}'),
                        subtitle: Text('${userData[index].email}'),
                        trailing: Icon(Icons.chevron_right),
                      )
                    : Container();
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
