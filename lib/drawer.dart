import 'package:flutter/material.dart';
import 'package:t_note/mainscreen.dart';
import 'package:t_note/registrationscreen.dart';
import 'package:t_note/mainscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_note/user.dart';
import 'package:http/http.dart' as http;

class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({required Key key, required this.user}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountEmail: Text(widget.user.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.white
                    : Colors.red,
            backgroundImage: AssetImage(
              "assets/images/logoround.png",
            ),
          ),
          accountName: Text(widget.user.email),
        ),
        ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(
                            user: widget.user,
                          )));
            }),
        ListTile(
            title: Text("TouringGram"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(
                            user: widget.user,
                          )));
            }),
        ListTile(
            title: Text("My Profile"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
            }),
        ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    ));
  }
}
