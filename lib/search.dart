import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:t_note/post.dart';
import 'package:t_note/user.dart';
import 'package:t_note/viewpost.dart';

class Search extends StatefulWidget {
  final User user;

  const Search({Key? key, required this.user}) : super(key: key);
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Post? post;
  final TextEditingController _searchcontroller = TextEditingController();
  String _titlecenter = "Loading...";
  late List _postList = [];
  late double screenHeight, screenWidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 172, 223, 220),
        title: Card(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
              controller: _searchcontroller,
              decoration: InputDecoration.collapsed(
                hintText: "Search Something",
              )),
        )),
        actions: [
          GestureDetector(
            onTap: () {
              _searchPost();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          )
        ],
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
                                    builder: (content) => ViewPost(
                                        user: widget.user,
                                        post: post!))).then((_) => setState(() {
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
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: GestureDetector(
                                        onTap: _postList[index]['likeaction'] ==
                                                "unlike"
                                            ? () {
                                                likePost(
                                                    _postList[index]['pid']);
                                              }
                                            : () {
                                                dislikePost(
                                                    _postList[index]['pid']);
                                              },
                                        child: _postList[index]['likeaction'] ==
                                                "unlike"
                                            ? const Icon(
                                                Icons.thumb_up,
                                                size: 15,
                                              )
                                            : const Icon(
                                                Icons.thumb_down,
                                                size: 15,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://hubbuddies.com/269842/tnotes/images/post_pictures/${_postList[index]['pid']}.png",
                                      height: 172.5,
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
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                  //   child: Text(_postList[index]['likes'],
                                  //       style: const TextStyle(
                                  //         fontSize: 16,
                                  //       )),
                                  // ),
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

  void _searchPost() {
    String _search = _searchcontroller.text.toString();
    print(_search);
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/searchpost.php"),
        body: {
          "search": _search,
        }).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No Post.";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _postList = jsondata["posts"];
        print(_postList);
        setState(() {});
      }
    });
  }

  void _loadPosts() {
    print(widget.user.email);
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
        print(_postList);
        setState(() {});
      }
    });
  }

  void likePost(String post_id) {
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/like_post.php"),
        body: {
          "email": widget.user.email,
          "post_id": post_id,
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        _loadPosts();
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    });
  }

  void dislikePost(String post_id) {
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/dislike_post.php"),
        body: {
          "email": widget.user.email,
          "post_id": post_id,
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        _loadPosts();
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    });
  }
}
