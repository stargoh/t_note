import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_note/loginscreen.dart';
import 'package:t_note/profilescreen.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneNoController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  late double screenHeight, screenWidth;
  String pathAsset = 'assets/images/profile.png';
  late File _image;

  @override
  void initState() {
    _emailController.text = widget.user.email!;
    _firstNameController.text = widget.user.user_firstname!;
    _lastNameController.text = widget.user.user_lastname!;
    _phoneNoController.text = widget.user.phoneNumber!;
    super.initState();
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
          title: Text('Edit Profile', style: TextStyle(fontFamily: 'Arial')),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(children: [
                Container(
                    height: screenHeight / 6.5,
                    width: screenWidth / 4,
                    child: Container(
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          height: screenHeight / 5,
                          width: screenWidth / 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // border: Border.all(color:Theme.of(context).appBarTheme.actionsIconTheme.color),
                            // image: DecorationImage(
                            // image: _image == null ? AssetImage(pathAsset) : FileImage(_image),
                            // fit: BoxFit.scaleDown,
                            //)
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.red[200],
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  //color: Theme.of(context).appBarTheme.actionsIconTheme.color,
                                  size: 18,
                                ),
                                onPressed: () {
                                  //_onPictureSelectionDialog();
                                },
                              )),
                        )
                      ]),
                    )),
                SizedBox(height: 50),
                Container(
                  height: screenHeight / 3,
                  width: screenWidth / 1,
                  child: Column(children: [
                    IgnorePointer(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    TextField(
                      controller: _firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                        labelText: 'First Name',
                      ),
                    ),
                    TextField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                        labelText: 'Last Name',
                      ),
                    ),
                    TextField(
                      controller: _phoneNoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                        labelText: 'Phone Number',
                      ),
                    ),
                  ]),
                ),
                Container(
                  child: Row(children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: 350,
                      height: 40,
                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Arial'),
                      ),
                      onPressed: onUpdate,
                      color: Colors.red[200],
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ));
  }

  void onUpdate() {
    setState(() {
      String _firstname = _firstNameController.text.toString();
      String _lastname = _lastNameController.text.toString();
      String _phoneNo = _phoneNoController.text.toString();
      String _email = _emailController.text.toString();

      if (_firstname.isEmpty && _lastname.isEmpty) {
        Fluttertoast.showToast(
            msg: "Do not have any update",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[200],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        if ((_firstNameController.text.toString() == "")) {
          _firstname = widget.user.user_firstname!;
        } else {
          _firstname = _firstNameController.text.toString();
        }
        if ((_lastNameController.text.toString() == "")) {
          _lastname = widget.user.user_lastname!;
        } else {
          _lastname = _lastNameController.text.toString();
        }
        if ((_phoneNoController.text.toString() == "")) {
          _phoneNo = widget.user.phoneNumber!;
        } else {
          _phoneNo = _phoneNoController.text.toString();
        }

        if ((_emailController.text.toString() == "")) {
          _email = widget.user.email!;
        } else {
          _email = _emailController.text.toString();
        }

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                title: Text('Update Profile?',
                    style: Theme.of(context).textTheme.headline5),
                content: Text("Are you sure?",
                    style: Theme.of(context).textTheme.bodyText1),
                actions: [
                  TextButton(
                    child: (Text('Yes',
                        style: Theme.of(context).textTheme.bodyText2)),
                    onPressed: () {
                      _updateProfile(_firstname, _lastname, _phoneNo, _email);
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: (Text('No',
                        style: Theme.of(context).textTheme.bodyText2)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    });
  }

  // void _onPictureSelectionDialog() {

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context){
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         content: new Container(
  //           padding: EdgeInsets.all(0),
  //           width: screenWidth/4,
  //           height: screenHeight/5.5,
  //           child: Column(
  //             children:<Widget> [
  //               ListTile(
  //                 title: Text("Take a Photo from Camera",style: TextStyle(fontSize: 16),),
  //                 trailing: Icon(Icons.keyboard_arrow_right),
  //                 onTap: () =>
  //                 {Navigator.pop(context), _chooseCamera()},
  //               ),
  //               SizedBox(height:5),
  //               ListTile(
  //                 title: Text("Choose a Photo from Gallery",style: TextStyle(fontSize: 16),),
  //                 trailing: Icon(Icons.keyboard_arrow_right),
  //                 onTap: () =>
  //                 {Navigator.pop(context), _chooseGallery()},
  //               ),

  //             ],
  //           ),
  //         ),
  //       );
  //     });
  // }

  // Future<void> _chooseCamera() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(
  //     source: ImageSource.camera,
  //     maxHeight: 800,
  //     maxWidth: 1000,
  //   );

  //   if (pickedFile != null) {
  //     _image = File(pickedFile.path);
  //   } else {
  //     print('No image selected.');
  //   }
  //   _cropImage();
  // }

  // Future<void> _chooseGallery() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 800,
  //     maxWidth: 1000,
  //   );

  //   if (pickedFile != null) {
  //     _image = File(pickedFile.path);
  //   } else {
  //     print('No image selected.');
  //   }
  //   _cropImage();
  // }

  // void _cropImage() async {

  //   File croppedFile = await ImageCropper.cropImage(
  //     sourcePath: _image.path,
  //     aspectRatioPresets: [
  //       CropAspectRatioPreset.square,
  //       CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.original,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio16x9
  //     ],
  //     androidUiSettings: AndroidUiSettings(
  //         toolbarTitle: 'Crop your image',
  //         toolbarColor: Colors.red[200],
  //         toolbarWidgetColor: Colors.white,
  //         activeControlsWidgetColor: Colors.red[200],
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: false),
  //     iosUiSettings: IOSUiSettings(
  //       minimumAspectRatio: 1.0,
  //     )
  //   );

  //   if (croppedFile != null) {
  //     _image = croppedFile;
  //     setState(() {});
  //   }
  // }

  void _updateProfile(
      String firstname, String lastname, String phoneNo, String email) {
    //String base64Image = base64Encode(_image.readAsBytesSync());
    print(firstname);
    print(lastname);
    print(phoneNo);
    print(email);
    //print(phoneno);
    //print(base64Image);

    setState(() {
      http.post(
          Uri.parse(
              "https://hubbuddies.com/269842/tnotes/php/updateProfile.php"),
          body: {
            "email": email,
            "firstName": firstname,
            "lastName": lastname,
            "phoneNo": phoneNo
          }).then((response) {
        print(response.body);

        if (response.body == "Success") {
          Fluttertoast.showToast(
              msg: "Update Success.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red[200],
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Update Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red[200],
              textColor: Colors.white,
              fontSize: 16.0);
        }

        // widget.user.firstName=firstname;
        // widget.user.lastName=lastname;
        // widget.user.phoneNo=phoneno;
      });
    });
  }
}
