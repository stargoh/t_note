import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  bool _rememberMe = false;
  TextEditingController _fNameController = new TextEditingController();
  TextEditingController _lNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordControllera = new TextEditingController();
  TextEditingController _passwordControllerb = new TextEditingController();
  TextEditingController _roleController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Color.fromARGB(225, 172, 223, 220),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      // margin: EdgeInsets.fromLTRB(70, 50, 70, 10),
                      /*child:
                          Image.asset('assets/images/logoround.png', scale: 2)*/
                      ),
                  SizedBox(height: 5),
                  Card(
                    margin: EdgeInsets.all(20),
                    elevation: 10,
                    color: Color.fromARGB(235, 180, 225, 225),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          Text('Registration Form',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          TextField(
                              controller: _fNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter First Name',
                              )),
                          TextField(
                              controller: _lNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter Last Name',
                              )),
                          TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Enter Email',
                                icon: Icon(Icons.email),
                              )),
                          TextField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Enter Phone No',
                                icon: Icon(Icons.phone),
                              )),
                          TextField(
                            controller: _passwordControllera,
                            decoration: InputDecoration(
                                labelText: 'Enter Password',
                                icon: Icon(Icons.lock)),
                            obscureText: true,
                          ),
                          TextField(
                            controller: _passwordControllerb,
                            decoration: InputDecoration(
                                labelText: 'Enter Password Again',
                                icon: Icon(Icons.lock)),
                            obscureText: true,
                          ),
                          TextField(
                              controller: _roleController,
                              decoration: InputDecoration(
                                labelText: 'Reference Code',
                              )),
                          SizedBox(height: 5),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minWidth: 200,
                            child: Text('Register'),
                            color: Colors.blueGrey[400],
                            onPressed: _register,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Text("Already Register?",
                        style: TextStyle(fontSize: 16)),
                    onTap: _alreadyRegister,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  void _alreadyRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  void _register() {
    String _fName = _fNameController.text.toString();
    String _lName = _lNameController.text.toString();
    String _email = _emailController.text.toString();
    String _passworda = _passwordControllera.text.toString();
    String _passwordb = _passwordControllerb.text.toString();
    String _phoneNumber = _phoneNumberController.text.toString();
    String _role = _roleController.text.toString();

    if (_email.isEmpty ||
        _passworda.isEmpty ||
        _passwordb.isEmpty ||
        _phoneNumber.isEmpty ||
        _lName.isEmpty ||
        _fName.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all the details!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Text("Verifcation Email will send to " + _email),
            actions: [
              TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _registerUser(_fName, _lName, _email, _phoneNumber,
                        _passworda, _role);
                  }),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void _registerUser(String firstName, String lastName, String user_email,
      String phoneNumber, String password, String role) {
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/register_user.php"),
        body: {
          "firstName": firstName,
          "lastName": lastName,
          "user_email": user_email,
          "phoneNumber": phoneNumber,
          "password": password,
          "role": role,
        }).then((respone) {
      print(respone.body);
      if (respone.body == "success") {
        Fluttertoast.showToast(
          msg: "Registration Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    });
  }
}
