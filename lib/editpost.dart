import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:t_note/post.dart';
import 'package:t_note/profilescreen.dart';
import 'package:t_note/user.dart';

class EditPost extends StatefulWidget {
  final User user;
  final Post post;

  const EditPost({Key? key, required this.user, required this.post})
      : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  // late ProgressDialog pd;
  File? _image;
  String pathAsset = 'assets/images/uploadLogo.png';
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _categ = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  late double screenHeight, screenWidth;

  @override
  void initState() {
    _title.text = widget.post.title;
    _desc.text = widget.post.desc;
    _categ.text = widget.post.categ;
    _rating.text = widget.post.rating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text('View Post'),
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
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _title,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                      ),
                      TextFormField(
                        controller: _desc,
                        minLines: 7,
                        maxLines: 20,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                      ),
                      TextFormField(
                        controller: _categ,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Category",
                        ),
                      ),
                      TextFormField(
                        controller: _rating,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: "Rating",
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minWidth: 150,
                    height: 35,
                    child: Text("Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: screenWidth / 178.19,
                            fontWeight: FontWeight.bold)),
                    onPressed: _updatepost,
                    color: Color.fromARGB(225, 172, 223, 220),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minWidth: 150,
                    height: 35,
                    child: Text("Delete",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: screenWidth / 178.19,
                            fontWeight: FontWeight.bold)),
                    onPressed: _deletepost,
                    color: Colors.red,
                  ),
                ],
              )
            ],
          ))),
    );
  }

  _onPictureSelectionDialog() {
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
    final pickedFile = await picker.getImage(
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
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  void _updatepost() {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Upload"), title: const Text("Posting..."));
    progressDialog.show();
    String title = _title.text.toString();
    String desc = _desc.text.toString();
    String category = _categ.text.toString();
    String rating = _rating.text.toString();
    Fluttertoast.showToast(
      msg: "Success",
      toastLength: Toast.LENGTH_SHORT,
    );
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/updatepost.php"),
        body: {
          "email": widget.user.email,
          "pid": widget.post.pid,
          "title": title,
          "desc": desc,
          "categ": category,
          "rating": rating,
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

  void _deletepost() {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Delete"), title: const Text("Posting..."));
    progressDialog.show();
    Fluttertoast.showToast(
      msg: "Success",
      toastLength: Toast.LENGTH_SHORT,
    );
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/deletepost.php"),
        body: {
          "email": widget.user.email,
          "pid": widget.post.pid,
        }).then((response) {
      progressDialog.dismiss();
      if (response.body == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(
                      user: widget.user,
                    )));
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
