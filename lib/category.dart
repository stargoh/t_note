import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_note/loginscreen.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

class category extends StatefulWidget {
  final User user;

  const category({Key? key, required this.user}) : super(key: key);

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  late List _categoryList = [];
  String _titlecenter = "Loading...";
  late double screenHeight, screenWidth;
  final TextEditingController _category = TextEditingController();

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
        title: const Text('Category'),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                child: const Icon(Icons.add, size: 30, color: Colors.grey),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Add Category"),
              ),
              Card(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _category,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                      ),
                    ),
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minWidth: 200,
                      height: 50,
                      child: const Text("Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      onPressed: () {
                        _uploadCategory();
                      },
                      color: const Color.fromARGB(225, 172, 223, 220),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: screenHeight / 2,
                child: _categoryList.isEmpty
                    ? LimitedBox(
                        child: Center(
                            child: Text(_titlecenter,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))))
                    : LimitedBox(
                        child: GridView.builder(
                        itemCount: _categoryList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.4),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onLongPress: () {
                              editCategoryDialog(
                                  _categoryList[index]['category_id']);
                            },
                            onDoubleTap: () {
                              deleteCategoryDialog(
                                  _categoryList[index]['category_id']);
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
                                child: Center(
                                  child: Text(
                                      _categoryList[index]['category_name'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _uploadCategory() async {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/269842/tnotes/php/uploadcategory.php"),
        body: {"category": _category.text.toString()}).then((response) {
      print(response.body);
      if (response.body == "Success") {
        setState(() {
          _category.text = "";
          _loadCategory();
        });
      } else {}
    });
  }

  void editCategoryDialog(String categoryID) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Edit Category',
              textAlign: TextAlign.center,
            ),
            content: CupertinoTextField(
              controller: _category,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => {
                  editCategory(categoryID, _category.text.toString()),
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

  void editCategory(String categoryID, String category) {
    print(categoryID);
    print(category);

    if (category.isEmpty) {
      Fluttertoast.showToast(
        msg: "Comment Box is empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return;
    } else {
      http.post(
          Uri.parse(
              "https://hubbuddies.com/269842/tnotes/php/editcategory.php"),
          body: {
            "categoryID": categoryID,
            "category": category,
          }).then((response) {
        if (response.body == "Success") {
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          _loadCategory();
          _category.clear();
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

  void deleteCategoryDialog(String categoryID) {
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
                  deleteCategory(categoryID),
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

  void deleteCategory(String categoryID) {
    print(categoryID);

    http.post(
        Uri.parse(
            "https://hubbuddies.com/269842/tnotes/php/deletecategory.php"),
        body: {
          "categoryID": categoryID,
        }).then((response) {
      if (response.body == "Success") {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        _loadCategory();
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
        setState(() {});
      }
    });
  }
}
