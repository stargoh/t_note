import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'user.dart';

class category extends StatefulWidget {
  final User user;

  const category({Key? key, required this.user}) : super(key: key);

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text('Category'),
      ),
    );
  }
}
