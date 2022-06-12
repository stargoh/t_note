import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_note/post.dart';
import 'package:t_note/report.dart';
import 'package:t_note/report_post_details.dart';
import 'package:t_note/search.dart';
import 'package:t_note/viewpost.dart';

import 'user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class ReportView extends StatefulWidget {
  final User user;

  const ReportView({Key? key, required this.user}) : super(key: key);
  @override
  State<ReportView> createState() => _ReportState();
}

class _ReportState extends State<ReportView> {
  late List _postList = [];

  String _titlecenter = "Loading...";
  late double screenHeight, screenWidth;
  Report? report;

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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Search(user: widget.user)));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text('Reported Post'),
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
                            report = Report(
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
                                report: _postList[index]['report']);
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => ReportPostDetails(
                                            user: widget.user,
                                            report: report!)))
                                .then((_) => setState(() {
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
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 5, 0),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: const Icon(Icons.delete,
                                                size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
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

  void _loadPosts() {
    print(widget.user.email);
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/load_report.php"),
        body: {
          "user_email": widget.user.email,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No Post.";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _postList = jsondata["posts"];
        // print(_postList);
        setState(() {});
      }
    });
  }
}
