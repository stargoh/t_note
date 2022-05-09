import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'package:t_note/newpost.dart';
import 'package:t_note/profilescreen.dart';
import 'mainscreen.dart';

import 'user.dart';

class BottomNavigationWidgetuser extends StatefulWidget {
  final User user;

  const BottomNavigationWidgetuser({Key? key, required this.user})
      : super(key: key);

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidgetuser> {
  int _currentIndex = 0;
  late List<Widget> list;

  @override
  void initState() {
    list = [
      MainScreen(
        user: widget.user,
      ),
      NewPost(
        user: widget.user,
      ),
      ProfileScreen(
        user: widget.user,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        selectedItemColor: Colors.white70,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.post_add),
            label: 'Create Post',
            backgroundColor: Colors.blue,
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,
          )
        ],
      ),
    );
  }
}
