// import 'package:flutter/material.dart';
// import 'package:t_note/loginscreen.dart';
// import 'user.dart';

// class NewPost extends StatefulWidget {
//   final User user;

//   const NewPost({Key? key, required this.user}) : super(key: key);

//   @override
//   State<NewPost> createState() => _NewPostState();
// }

// class _NewPostState extends State<NewPost> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(225, 172, 223, 220),
//         title: Text('Create Post'),
//       ),

//     );
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:t_note/loginscreen.dart';
import 'user.dart';

class NewPost extends StatefulWidget {
  final User user;

  const NewPost({Key? key, required this.user}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  // late ProgressDialog pd;
  File? _image;
  String pathAsset = 'assets/images/uploadLogo.png';

  final TextEditingController _ptitle = TextEditingController();
  final TextEditingController _prprice = TextEditingController();
  final TextEditingController _prcateg = TextEditingController();
  final TextEditingController _prdesc = TextEditingController();
  final TextEditingController _prating = TextEditingController();
  late double screenHeight, screenWidth;

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
                        controller: _ptitle,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Add a title',
                        ),
                      ),
                      TextFormField(
                        controller: _prdesc,
                        minLines: 7,
                        maxLines: 20,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Add text',
                        ),
                      ),
                      TextFormField(
                        controller: _prating,
                        keyboardType: TextInputType.text,
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
                      child: const Text("Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      onPressed: _submitProductDialog,
                      color: Colors.black),
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
    String ptitle = _ptitle.text.toString();
    String prcateg = _prcateg.text.toString();
    String prprice = _prprice.text.toString();
    String prdesc = _prdesc.text.toString();
    String prating = _prating.text.toString();
    if (_image == null ||
        ptitle == "" ||
        prcateg == "" ||
        prprice == "" ||
        prdesc == "" ||
        prating == "") {
      Fluttertoast.showToast(
        msg: "Image OR Textfield is empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      //return;
      // } else if (ptitle.contains(RegExp(r'[0-9]'))) {
      //   Fluttertoast.showToast(
      //     msg: "Your product name should not contain number",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //   );
      //   return;
      // } else if (ptitle.contains(RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      //   Fluttertoast.showToast(
      //     msg: "Your product name should not contain special character",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //   );
      //   return;
      // } else if (prcateg.contains(RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      //   Fluttertoast.showToast(
      //     msg: "Your product catogory should not contain special character",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //   );
      //   return;
      // } else if (double.parse(prating) > 5 || double.parse(prating) < 1) {
      //   Fluttertoast.showToast(
      //     msg: "Your product rating should between 1 to 5",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //   );
      //   return;
      // }
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         shape: const RoundedRectangleBorder(
      //             borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //         title: const Text("Add your product?"),
      //         content: const Text("Are your sure?"),
      //         actions: [
      //           TextButton(
      //             child: const Text("Ok"),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //               _postProduct();
      //             },
      //           ),
      //           TextButton(
      //               child: const Text("Cancel"),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               }),
      //         ],
      //       );
      //     });
    }

    Future<void> _postProduct() async {
      // pd = ProgressDialog(context);
      // pd.style(
      //   message: 'Posting...',
      //   borderRadius: 5.0,
      //   backgroundColor: Colors.white,
      //   progressWidget: const CircularProgressIndicator(),
      //   elevation: 10.0,
      //   insetAnimCurve: Curves.easeInOut,
      // );
      // pd = ProgressDialog(context,
      //     type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
      // await pd.show();
      String base64Image = base64Encode(_image!.readAsBytesSync());
      String ptitle = _ptitle.text.toString();
      String prcateg = _prcateg.text.toString();
      String prprice = _prprice.text.toString();
      String prdesc = _prdesc.text.toString();
      String prating = _prating.text.toString();
      Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
      );
      // http.post(
      //     Uri.parse(
      //         "https://hubbuddies.com/269509/lokthienwestern/php/new_product.php"),
      //     body: {
      //       "product_name": prname,
      //       "product_price": prprice,
      //       "product_categ": prcateg,
      //       "product_desc": prdesc,
      //       "product_rating": prrating,
      //       "encoded_string": base64Image
      //     }).then((response) {
      //   pd.hide().then((isHidden) {});
      //   if (response.body == "Success") {
      //     Fluttertoast.showToast(
      //       msg: "Success",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //     );
      //     Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (content) => AdminMainScreen()));
      //   } else {
      //     Fluttertoast.showToast(
      //       msg: "Failed",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //     );
      //   }
      // });
    }
  }
}
