import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'package:t_note/newpost.dart';
import 'package:t_note/profilescreen.dart';
import 'package:t_note/reportview.dart';
import 'mainscreen.dart';
import 'package:t_note/category.dart';
import 'user.dart';

class BottomNavigationWidgetadmin extends StatefulWidget {
  final User user;

  const BottomNavigationWidgetadmin({Key? key, required this.user})
      : super(key: key);

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidgetadmin> {
  int _currentIndex = 0;
  late List<Widget> list;

  @override
  void initState() {
    list = [
      MainScreen(
        user: widget.user,
      ),
      ReportView(
        user: widget.user,
      ),
      category(
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
            backgroundColor: Color.fromARGB(225, 172, 223, 220),
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_active_outlined),
            label: 'Alert',
            backgroundColor: Color.fromARGB(225, 172, 223, 220),
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.format_list_bulleted),
            label: 'Category',
            backgroundColor: Color.fromARGB(225, 172, 223, 220),
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color.fromARGB(225, 172, 223, 220),
          )
        ],
      ),
    );
  }
}
