import 'package:flutter/material.dart';
import 'package:t_note/bottomnavibaradmin.dart';
import 'package:t_note/mainscreen.dart';
import 'package:t_note/registrationscreen.dart';
import 'package:t_note/mainscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'bottomnavigationbar.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late SharedPreferences prefs;

  get role => null;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          backgroundColor: const Color.fromARGB(225, 172, 223, 220),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(70, 50, 70, 10),
                      child:
                          Image.asset('assets/images/logoround.png', scale: 2)),
                  const SizedBox(height: 5),
                  Card(
                    margin: const EdgeInsets.all(20),
                    elevation: 10,
                    color: const Color.fromARGB(235, 180, 225, 225),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          const Text('Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              )),
                          TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.email),
                              )),
                          TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Password', icon: Icon(Icons.lock)),
                            obscureText: true,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Checkbox(
                                  value: _rememberMe,
                                  onChanged: (bool? value) {
                                    _onChange(value!);
                                  }),
                              const Text("Remember Me")
                            ],
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minWidth: 200,
                            child: const Text('Login'),
                            color: Colors.blueGrey[400],
                            onPressed: _login,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Text("Register New Account",
                        style: const TextStyle(fontSize: 16)),
                    onTap: _registerNewUser,
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    child: const Text("Forgot Password?",
                        style: const TextStyle(fontSize: 16)),
                    onTap: _forgotPassword,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _login() {
    String user_email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/loginUser.php"),
        body: {
          // "firstName": ,

          "user_email": user_email,
          //"phoneNumber": phoneNumber,
          "password": _password
        }).then((respone) {
      print(respone.body);
      if (respone.body == "Failed") {
        Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
          // Fluttertoast.showToast(
          //     msg: "Login Success !",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.white,
          //     textColor: Colors.black,
          //     fontSize: 16.0);
          // List userdata = respone.body.split("#");
          // User user = User(
          //   email: user_email,
          //   password: _password,
          //   user_firstname: userdata[1],
          //   user_lastname: userdata[2],
        );
        /* Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen()));*/
      } else {
        List userdata = respone.body.split("#");
        User user = User(
            email: user_email,
            password: _password,
            user_firstname: userdata[1],
            user_lastname: userdata[2],
            phoneNumber: userdata[4],
            role: userdata[5]);

        if (userdata[5] == ("ADMIN")) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) =>
                      BottomNavigationWidgetadmin(user: user)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) =>
                      BottomNavigationWidgetuser(user: user)));
        }
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Forgot Your Password?"),
              content: new Container(
                  height: 90,
                  child: Column(children: [
                    const Text("Enter your email"),
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _useremailController,
                        decoration: const InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email))),
                  ])),
              actions: [
                TextButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    _resetPassword(_useremailController.text);
                  },
                ),
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _onChange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your Email/Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }
    setState(() {
      _rememberMe = value;
      savePref(value, _email, _password);
    });
  }

  Future<void> savePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
        msg: "Information Saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    } else {
      await prefs.setString("email", '');
      await prefs.setString("password", '');
      await prefs.setBool("rememberme", false);
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("rememberme") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  void _resetPassword(String user_email) {
    http.post(
        Uri.parse("https://hubbuddies.com/269842/tnotes/php/resetuser.php"),
        body: {
          // "firstName": ,
          //"lastName": lastName,
          "user_email": user_email,
          //"phoneNumber": phoneNumber,
          //"password": password
        }).then((respone) {
      print(respone.body);
      if (respone.body == "success") {
        Fluttertoast.showToast(
          msg: "Reset Done! Please check your email !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else if (respone.body == "reset failed") {
        Fluttertoast.showToast(
          msg: "Reset Failed !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else if (respone.body == "no user") {
        Fluttertoast.showToast(
          msg: "This user not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
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
