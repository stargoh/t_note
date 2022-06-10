import 'package:flutter/material.dart';
import 'package:t_note/loginscreen.dart';
import 'package:t_note/user.dart';
import 'package:http/http.dart' as http;

class category extends StatefulWidget {
  final User user;

  const category({Key? key, required this.user}) : super(key: key);

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  late List _categList = [];
  String _titlecenter = "Loading...";
  late double screenHeight, screenWidth;
  final TextEditingController _category = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              // _categList.isEmpty
              //     ? Flexible(
              //         child: Center(
              //             child: Text(_titlecenter,
              //                 style: const TextStyle(
              //                     fontSize: 25, fontWeight: FontWeight.bold))))
              //     : Flexible(
              //         child: Center(
              //         child: Padding(
              //           padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              //           child: GridView.builder(
              //             itemCount: _categList.length,
              //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //                 crossAxisCount: 2,
              //                 mainAxisSpacing: 5,
              //                 crossAxisSpacing: 5,
              //                 childAspectRatio:
              //                     (screenWidth / screenHeight) / 0.7),
              //             itemBuilder: (BuildContext context, int index) {
              //               return Card(
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(5),
              //                     border: Border.all(
              //                       width: 1.5,
              //                       color: Colors.grey,
              //                     ),
              //                   ),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     children: [
              //                       Padding(
              //                         padding:
              //                             const EdgeInsets.fromLTRB(5, 15, 5, 0),
              //                         child: Text(_categList[index]['title'],
              //                             style: const TextStyle(
              //                               fontSize: 18,
              //                             )),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       )),
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
        });
      } else {}
    });
  }
}
