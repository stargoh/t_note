import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'user.dart';

class NewPost extends StatefulWidget {
  final User user;

  const NewPost({Key? key, required this.user}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: Text('Create Post'),
      ),
    );
  }
}
