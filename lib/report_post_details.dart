import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:t_note/post.dart';
import 'package:t_note/report.dart';
import 'package:t_note/user.dart';

class ReportPostDetails extends StatefulWidget {
  final User? user;
  final Report? report;
  const ReportPostDetails({Key? key, this.user, this.report}) : super(key: key);

  @override
  State<ReportPostDetails> createState() => _ReportPostDetailsState();
}

class _ReportPostDetailsState extends State<ReportPostDetails> {
  late List _reportList = [];
  String _titlecenter = "Loading...";
  late double screenHeight, screenWidth;
  final widgetKey = GlobalKey();
  late List _commentList = [];
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _categ = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  final TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    _title.text = widget.report?.title;
    _desc.text = widget.report?.desc;
    _categ.text = widget.report?.categ;
    _rating.text = widget.report?.rating;
    _loadReport(widget.report!.pid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: widgetKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text('View Post'),
        actions: [
          Badge(
            showBadge: true,
            badgeColor: Colors.red[200]!,
            position: BadgePosition.topEnd(
              top: 2,
              end: 2,
            ),
            badgeContent: Text(widget.report!.report),
            child: IconButton(
              onPressed: () {
                reportListDialog();
              },
              icon: const Icon(Icons.info, size: 20),
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                width: screenWidth,
                height: 1 / 3 * screenHeight,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    tag: '',
                    child: widget.report!.pimage,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Card(
                color: Colors.grey[250],
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IgnorePointer(
                        child: TextFormField(
                          controller: _title,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Title",
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: TextFormField(
                          controller: _desc,
                          minLines: 7,
                          maxLines: 20,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: "Desciption",
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: TextFormField(
                          controller: _categ,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Category",
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: TextFormField(
                          controller: _rating,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: "Rating",
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ],
          ))),
    );
  }

  void _loadReport(String post_id) {
    print(post_id);
    http.post(
        Uri.parse(
            "https://hubbuddies.com/269842/tnotes/php/load_report_details.php"),
        body: {
          "post_id": post_id,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No Post.";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _reportList = jsondata["record"];
        // print(_postList);
        setState(() {});
      }
    });
  }

  List<String> colorList = [
    'Orange',
    'Yellow',
    'Pink',
    'White',
    'Red',
    'Black',
    'Green'
  ];

  Future<Future> reportListDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Report Message'),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _reportList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      // leading: Text("${index + 1}"),
                      title: Text(_reportList[index]["message"]),
                      subtitle: Text(_reportList[index]["user_firstname"] +
                          " " +
                          _reportList[index]["user_lastname"]),
                    ),
                  );
                  //  ListTile(
                  //   title: Text(colorList[index]),
                  //   onTap: () {
                  //     Navigator.pop(context, colorList[index]);
                  //   },
                  // );
                },
              ),
            ),
          );
        });
  }

  // void reportListDialog() {
  //   print(_reportList.length);
  //   int index = 0;

  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             title: const Text("Forgot Your Password?"),
  //             content: Column(
  //               children: [
  //                 Container(
  //                   width: double.minPositive,
  //                   // height: screenHeight / 3,
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: 3,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return Card(
  //                         child: ListTile(
  //                           // leading: Text("${index + 1}"),
  //                           title: Text(_reportList[index]["message"]),
  //                           subtitle: Text(_reportList[index]
  //                                   ["user_firstname"] +
  //                               " " +
  //                               _reportList[index]["user_lastname"]),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                   child: const Text("Cancel"),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   })
  //             ]);
  //       });
  // }
}
