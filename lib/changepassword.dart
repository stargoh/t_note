import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_note/post.dart';
import 'package:t_note/search.dart';
import 'package:t_note/viewpost.dart';
import 'user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class ChangePass extends StatefulWidget {
  final User user;
  const ChangePass({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final TextEditingController _currentpasswordController =
      TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool hiddenPassword1 = true, hiddenPassword2 = true, hiddenPassword3 = true;
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 172, 223, 220),
        title: const Text("Change Password",
            style: TextStyle(fontFamily: 'Arial')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  decoration: BoxDecoration(
                      //color: Theme.of(context).hoverColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: screenHeight / 1.6,
                  width: screenWidth / 1.1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(children: [
                            Text(
                              "Create A New Password",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            // SizedBox(height: 20),
                            // Text(
                            //   "Set a new password",
                            //   textAlign: TextAlign.center,
                            //   style: Theme.of(context).textTheme.bodyText2,
                            // ),
                          ]),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: Color.fromARGB(225, 172, 223, 220),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(children: [
                              TextField(
                                controller: _currentpasswordController,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary)),
                                    icon: Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(225, 172, 223, 220),
                                    ),
                                    labelText: 'Current Password',
                                    labelStyle: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Calibri',
                                        color: Colors.black),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            hiddenPassword1 = !hiddenPassword1;
                                          });
                                        },
                                        child: Icon(
                                            hiddenPassword1
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black))),
                                obscureText: hiddenPassword1,
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _newpasswordController,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary)),
                                    icon: Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(225, 172, 223, 220),
                                    ),
                                    labelText: 'New Password',
                                    labelStyle: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Calibri',
                                        color: Colors.black),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            hiddenPassword2 = !hiddenPassword2;
                                          });
                                        },
                                        child: Icon(
                                            hiddenPassword2
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black))),
                                obscureText: hiddenPassword2,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary)),
                                    icon: Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(225, 172, 223, 220),
                                    ),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Calibri',
                                        color: Colors.black),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            hiddenPassword3 = !hiddenPassword3;
                                          });
                                        },
                                        child: Icon(
                                            hiddenPassword3
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black))),
                                obscureText: hiddenPassword3,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 20),
                            ]),
                          ),
                        ),
                      ])),
              const SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minWidth: screenWidth / 1.1,
                height: screenHeight / 18,
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                      fontSize: 18, color: Colors.white, fontFamily: 'Arial'),
                ),
                onPressed: _onReset,
                color: Color.fromARGB(225, 172, 223, 220),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _onReset() {
    String _currentPassword = _currentpasswordController.text.toString();
    String _newPassword = _newpasswordController.text.toString();
    String _confirmPassword = _confirmPasswordController.text.toString();

    if (_currentPassword.isEmpty &&
        _newPassword.isEmpty &&
        _confirmPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill in all textfield",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    } else if (_currentPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "Current Password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    } else if (_newPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "New Password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    } else if (_confirmPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "Confirm Password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    } else if (_newPassword != _confirmPassword ||
        _confirmPassword != _newPassword) {
      Fluttertoast.showToast(
          msg: "Password Mismatch",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[200],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_newPassword == widget.user.password ||
        _confirmPassword == widget.user.password) {
      Fluttertoast.showToast(
          msg: "Please make a new DIFFERENT password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    } else {
      _changePass(_currentPassword, _newPassword);
    }
  }

  void _changePass(String _currentPassword, String _newPassword) {
    print(widget.user.email);
    print(_newPassword);
    print(_currentPassword);

    http.post(
        Uri.parse(
            "https://hubbuddies.com/269842/tnotes/php/change_password.php"),
        body: {
          "user_email": widget.user.email,
          "password": _newPassword,
          "currentPassword": _currentPassword,
        }).then((response) {
      if (response.body == 'Success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.of(context).pop();
      } else if (response.body == 'WrongCurrPass') {
        Fluttertoast.showToast(
            msg: "Wrong Current Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else if (response.body == 'NotFound') {
        Fluttertoast.showToast(
            msg: "User Not Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
      print(response.body);
    });
  }
}
