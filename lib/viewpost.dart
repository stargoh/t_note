import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:t_note/post.dart';
import 'package:t_note/user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ViewPost extends StatefulWidget {
  final User user;
  final Post post;

  const ViewPost({Key? key, required this.user, required this.post})
      : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  // late ProgressDialog pd;
  File? _image;
  String pathAsset = 'assets/images/uploadLogo.png';
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _categ = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  final TextEditingController _comment = TextEditingController();
  final TextEditingController _reportMessage = TextEditingController();
  late double screenHeight, screenWidth;
  late bool isComment;
  String _titlecenter = "Loading...";
  late List _commentList = [];
  final widgetKey = GlobalKey();
  late int index = 0;

  @override
  void initState() {
    _title.text = widget.post.title;
    _desc.text = widget.post.desc;
    _categ.text = widget.post.categ;
    _rating.text = widget.post.rating;
    _loadComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double star = double.parse(_rating.text.toString());
    isComment = false;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: widgetKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text('View Post'),
        actions: [
          IconButton(
            onPressed: () => {
              reportPostDialog(),
            },
            icon: const Icon(Icons.info),
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
                    child: widget.post.pimage,
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
                      // IgnorePointer(
                      //   child: TextFormField(
                      //     controller: _rating,
                      //     keyboardType: const TextInputType.numberWithOptions(
                      //       decimal: true,
                      //     ),
                      //     inputFormatters: <TextInputFormatter>[
                      //       FilteringTextInputFormatter.digitsOnly
                      //     ],
                      //     decoration: const InputDecoration(
                      //       labelText: "Rating",
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      RatingBarIndicator(
                        rating: star,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 35.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          widget.post.likes != "0"
                              ? Text(widget.post.likes + " like(s) ")
                              : const Text(""),
                          const Text("Comment: "),
                        ],
                      ),
                      Container(
                        height: screenHeight / 5,
                        child: _commentList.isEmpty
                            ? LimitedBox(
                                child: Center(
                                    child: Text(_titlecenter,
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold))))
                            : LimitedBox(
                                child: ListView.builder(
                                itemCount: _commentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        // onLongPress: () {
                                        //   editCommentDialog(_commentList[index]
                                        //       ['comment_id']);
                                        // },
                                        onDoubleTap: _commentList[index]
                                                    ['email'] ==
                                                widget.user.email
                                            ? () {
                                                deleteCommentDialog(
                                                    _commentList[index]
                                                        ['comment_id']);
                                              }
                                            : null,
                                        child: ListTile(
                                          onLongPress: _commentList[index]
                                                      ['email'] ==
                                                  widget.user.email
                                              ? () {
                                                  editCommentDialog(
                                                      _commentList[index]
                                                          ['comment_id']);
                                                }
                                              : null,
                                          // onTap: () {
                                          //   deleteCommentDialog(
                                          //       _commentList[index]
                                          //           ['comment_id']);
                                          // },
                                          // key: widgetKey,
                                          // leading: Text('${index + 1}'),
                                          title: Text(
                                            _commentList[index]
                                                    ['user_firstname'] +
                                                " " +
                                                _commentList[index]
                                                    ['user_lastname'],
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          subtitle: Text(
                                              _commentList[index]['comment'],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                          trailing: Text(
                                            DateFormat('dd MMM HH:mm').format(
                                                DateTime.parse(
                                                    _commentList[index]
                                                        ['comment_date'])),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 0,
                                      )
                                    ],
                                  );
                                },
                              )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ))),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: _comment,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Comment",
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Padding(padding: EdgeInsets.all(0)),
            ),
            Expanded(
                flex: 2,
                child: MaterialButton(
                  color: const Color.fromARGB(225, 172, 223, 220),
                  onPressed:
                      // isComment == true
                      // ?
                      () {
                    setState(() {});
                    sendComment(widget.post.pid);
                  }
                  // : null
                  ,
                  child: const Text("Send"),
                ))
          ],
        ),
      ),
    );
  }

  void reportPostDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Report Post',
              textAlign: TextAlign.center,
            ),
            content: CupertinoTextField(
              controller: _reportMessage,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => {
                  reportPost(),
                  Navigator.pop(context),
                },
                child: const Text('Report'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  void reportPost() {
    String reportMessage = _reportMessage.text.toString();

    if (reportMessage.isEmpty) {
      Fluttertoast.showToast(
        msg: "Message Box is empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return;
    } else {
      // print(widget.user.email);
      // print(widget.post.pid);
      // print(reportMessage);
      http.post(
          Uri.parse("https://hubbuddies.com/269842/tnotes/php/report_post.php"),
          body: {
            "email": widget.user.email,
            "pid": widget.post.pid,
            "message": reportMessage,
          }).then((response) {
        if (response.body == "Success") {
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          _reportMessage.clear();
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

  void checkSend() {
    String comment = _comment.text.toString();

    if (comment.isEmpty) {
      setState(() {
        isComment = false;
      });
    } else {
      setState(() {
        isComment = true;
      });
    }
  }

  void sendComment(String pid) {
    String comment = _comment.text.toString();

    if (comment.isEmpty) {
      Fluttertoast.showToast(
        msg: "Comment Box is empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return;
    } else {
      http.post(
          Uri.parse("https://hubbuddies.com/269842/tnotes/php/addcomment.php"),
          body: {
            "email": widget.user.email,
            "pid": widget.post.pid,
            "comment": comment,
          }).then((response) {
        if (response.body == "Success") {
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          _loadComment();
          setState(() {
            _comment.clear();
          });
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

  void editCommentDialog(String comment_Id) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Edit Comment',
              textAlign: TextAlign.center,
            ),
            content: CupertinoTextField(
              controller: _comment,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => {
                  editComment(comment_Id, _comment.text.toString()),
                  Navigator.pop(context),
                },
                child: const Text('Edit'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  void editComment(String commentId, String comment) {
    print(commentId);
    print(comment);

    if (comment.isEmpty) {
      Fluttertoast.showToast(
        msg: "Comment Box is empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return;
    } else {
      http.post(
          Uri.parse("https://hubbuddies.com/269842/tnotes/php/editcomment.php"),
          body: {
            "email": widget.user.email,
            "comment_Id": commentId,
            "comment": comment,
          }).then((response) {
        if (response.body == "Success") {
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          _loadComment();
          _comment.clear();
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

  void deleteCommentDialog(String commentId) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Delete Comment',
              textAlign: TextAlign.center,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => {
                  deleteComment(commentId),
                  Navigator.pop(context),
                },
                child: const Text('Delete'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  void deleteComment(String commentId) {
    print(commentId);

    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/deletecomment.php"),
        body: {
          "email": widget.user.email,
          "comment_Id": commentId,
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        _loadComment();
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

  void _loadComment() {
    print(widget.user.email);
    print(widget.post.pid);
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/loadcomment.php"),
        body: {
          "email": widget.user.email,
          "pid": widget.post.pid,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No Comment.";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _commentList = jsondata["comment"];
        print(_commentList);
        setState(() {});
      }
    });
  }

  void _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SizedBox(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(color: Colors.black)),
                        minWidth: 100,
                        height: 100,
                        child: const Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(color: Colors.black)),
                        minWidth: 100,
                        height: 100,
                        child: const Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  void _submitProductDialog() {
    String title = _title.text.toString();
    String desc = _desc.text.toString();
    String categ = _categ.text.toString();
    String rating = _rating.text.toString();
    if (_image == null ||
        title == "" ||
        desc == "" ||
        categ == "" ||
        rating == "") {
      Fluttertoast.showToast(
        msg: "Image OR Textfield is empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Create post?"),
            content: const Text("Are your sure?"),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _uploadPost();
                },
              ),
              TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _uploadPost() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Upload"), title: const Text("Posting..."));
    progressDialog.show();
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String title = _title.text.toString();
    String desc = _desc.text.toString();
    String category = _categ.text.toString();
    String rating = _rating.text.toString();
    Fluttertoast.showToast(
      msg: "Success",
      toastLength: Toast.LENGTH_SHORT,
    );
    http.post(Uri.parse("https://hubbuddies.com/269842/tnotes/php/newpost.php"),
        body: {
          "email": widget.user.email,
          "title": title,
          "desc": desc,
          "categ": category,
          "rating": rating,
          "encoded_string": base64Image
        }).then((response) {
      progressDialog.dismiss();
      if (response.body == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
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

  RelativeRect _getRelativeRect(GlobalKey key) {
    return RelativeRect.fromSize(
        _getWidgetGlobalRect(key), const Size(200, 200));
  }

  Rect _getWidgetGlobalRect(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    debugPrint('Widget position: ${offset.dx} ${offset.dy}');
    return Rect.fromLTWH(offset.dx / 3.1, offset.dy * 1.05,
        renderBox.size.width, renderBox.size.height);
  }
}
