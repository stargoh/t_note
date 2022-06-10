import 'dart:convert';
import 'package:t_note/editpost.dart';
import 'package:t_note/post.dart';
import 'package:t_note/profilescreen.dart';
import 'package:t_note/viewpost.dart';

import 'user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class MyPost extends StatefulWidget {
  final User user;

  const MyPost({Key? key, required this.user}) : super(key: key);
  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late List _postList = [];
  late Post post;
  String _titlecenter = "Loading...";
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 172, 223, 220),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                          user: widget.user,
                        )));
          },
        ),
        title: Text('My Post', style: TextStyle(fontFamily: 'Arial')),
      ),
      body: Center(
        child: Column(children: [
          _postList.isEmpty
              ? Flexible(
                  child: Center(
                      child: Text(_titlecenter,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold))))
              : Flexible(
                  child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: GridView.builder(
                      itemCount: _postList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: (screenWidth / screenHeight) / 0.7),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            post = Post(
                              pid: _postList[index]['pid'],
                              pimage: CachedNetworkImage(
                                imageUrl:
                                    "https://hubbuddies.com/269842/tnotes/images/post_pictures/${_postList[index]['pid']}.png",
                                height: 172.5,
                                width: 172.86,
                              ),
                              email: _postList[index]['email'],
                              title: _postList[index]['title'],
                              desc: _postList[index]['description'],
                              categ: _postList[index]['categ'],
                              rating: _postList[index]['rating'],
                              likes: _postList[index]['likes'],
                              likeaction: _postList[index]['likeaction'],
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => EditPost(
                                        user: widget.user,
                                        post: post))).then((_) => setState(() {
                                  _loadPosts();
                                }));
                          },
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://hubbuddies.com/269842/tnotes/images/post_pictures/${_postList[index]['pid']}.png",
                                      height: 160.5,
                                      width: 172.86,
                                    )
                                  ]),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 15, 5, 0),
                                    child: Text(_postList[index]['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                        )),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 15, 5, 0),
                                    child: Text(_postList[index]['likes'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
        ]),
      ),
    );
  }

  void _loadPosts() {
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/loadposts.php"),
        body: {
          "user_email": widget.user.email,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No Post.";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _postList = jsondata["posts"];
        setState(() {});
      }
    });
  }
}
