import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'user.dart';
//import 'package:t_note/drawer.dart';

//void main() => runApp(MyApp());

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 172, 223, 220),
        title: Text('News Feed'),
      ),
      body: Center(
        child: Container(
          child: Text('Welcome!' +
              widget.user.email! +
              widget.user.user_firstname! +
              widget.user.user_lastname!),
        ),
      ),
    );
  }
}
