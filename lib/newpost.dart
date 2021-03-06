import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:t_note/loginscreen.dart';
import 'package:t_note/user.dart';

class NewPost extends StatefulWidget {
  final User user;

  const NewPost({Key? key, required this.user}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  // late ProgressDialog pd;
  late List _categoryList = [];
  late List _processedcategoryList = ["Select Category"];
  File? _image;
  String pathAsset = 'assets/images/uploadLogo.png';
  String selectCategory = "Select Category";
  String seletedvalue = "";

  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _categ = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text('Create Post'),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => {_onPictureSelectionDialog()},
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          // ignore: unrelated_type_equality_checks
                          image: _image == null
                              ? AssetImage(pathAsset) as ImageProvider
                              : FileImage(_image!),
                          fit: BoxFit.scaleDown,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)))),
              ),
              const SizedBox(height: 10),
              const Text("Click image to take/upload your product picture.",
                  style: TextStyle(fontSize: 12.0, color: Colors.black)),
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
                        decoration: const InputDecoration(
                          labelText: 'Add a title',
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text("Select Category:",
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black)),
                      DropdownButton(
                          value: selectCategory,
                          style: TextStyle(fontSize: 15, color: Colors.red),
                          items: [
                            for (String data in _processedcategoryList)
                              DropdownMenuItem(
                                child: Text(
                                  data,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                value: data,
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectCategory = value.toString();
                            });
                            chooseOrderStatus(value);
                          }),
                      TextFormField(
                        controller: _desc,
                        minLines: 1,
                        maxLines: 20,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: "Desciption",
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
                        decoration: const InputDecoration(
                          labelText: 'Rating',
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minWidth: 200,
                    height: 50,
                    child: const Text("Publish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    onPressed: _submitProductDialog,
                    color: const Color.fromARGB(225, 172, 223, 220),
                  ),
                ],
              ),
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

  void _submitProductDialog() {
    String title = _title.text.toString();
    String desc = _desc.text.toString();
    String categ = _categ.text.toString();
    String rating = _rating.text.toString();
    if (_image == null ||
        title == "" ||
        desc == "" ||
        //categ == "" ||
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

    http.post(Uri.parse("https://hubbuddies.com/269842/tnotes/php/newpost.php"),
        body: {
          "email": widget.user.email,
          "title": title,
          "desc": desc,
          "categ": selectCategory,
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

  void _loadCategory() {
    String name;
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/loadcategory.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _categoryList = jsondata["category"];
        for (int i = 0; i < _categoryList.length; i++) {
          _processedcategoryList.add(_categoryList[i]["category_name"]);
        }
        print(_processedcategoryList);
        setState(() {});
      }
    });
  }

  void chooseOrderStatus(value) {
    selectCategory = value;
    print(selectCategory);
    setState(() {});
  }
}
