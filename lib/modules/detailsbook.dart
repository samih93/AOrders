// @dart=2.9
import 'dart:collection';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_new/controller/orderscontroller.dart';
import 'package:test_new/main.dart';
import 'package:test_new/service/storage.dart';
import "package:test_new/models/Book.dart";
import 'package:image_picker/image_picker.dart';

class DetailsBook extends StatelessWidget {
  // Declare a field that holds the Person data
  final Book book;

  // In the constructor, require a Person
  DetailsBook({Key key, @required this.book}) : super(key: key);
  BuildContext _context;
  final ImagePicker _picker = ImagePicker();
  final Storageclass storage = Storageclass();
  String urlImage = "";

  @override
  Widget build(BuildContext context) {
    _context = context;
    String _email = book.email,
        _product = book.product,
        _password = book.password,
        _creationdate = book.creationdate,
        _image = book.image,
        _key = book.key,
        _status = book.status;

    var emailcontroller = TextEditingController(text: _email);
    var productcontroller = TextEditingController(text: _product);
    var passwordcontroller = TextEditingController(text: _password);

    var creationdatecontroller = TextEditingController(text: _creationdate);

    print(_key);
    return new Scaffold(
      body: GetBuilder<orderController>(
        init: orderController(),
        builder: (orderController) => CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.redAccent,
              titleSpacing: 3,
              pinned: true,
              expandedHeight: 160.0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  book.email.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                background: book.image != ""
                    ? Image.network(book.image)
                    : Image.asset(
                        'assets/alm.png',
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Hero(
                    //   tag: book.image.toString() ?? "image1",
                    //   child: CircleAvatar(
                    //     backgroundImage: book.image != ""
                    //         ? NetworkImage(book.image)
                    //         : Image.asset(
                    // 'assets/alm.png',
                    //     radius: 50,
                    //   ),
                    // ),
                    TextFormField(
                      controller: emailcontroller,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Title is required';
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email ...',
                        labelText: 'Email*',
                      ),
                    ),
                    TextFormField(
                      controller: productcontroller,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'product';
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'product ...',
                        labelText: 'product*',
                      ),
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Isbn is Required';
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Password ...',
                        labelText: 'Password*',
                      ),
                    ),

                    // TextFormField(
                    //   controller: statuscontroller,
                    //   validator: (input) {
                    //     if (input.isEmpty) {
                    //       return 'status is Required';
                    //     }
                    //   },
                    //   decoration: const InputDecoration(
                    //     hintText: 'status ...',
                    //     labelText: 'status*',
                    //     icon: Icon(Icons.stacked_bar_chart_sharp),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownSearch<String>(
                        mode: Mode.MENU,
                        // showSelectedItem: true,
                        items: ['free', 'pending', 'received'],
                        label: "Status",
                        onChanged: (newValue) {
                          orderController.onchagesdtatusvalue(newValue);
                        },
                        selectedItem: _status != ""
                            ? _status
                            : orderController.statusvalue),

                    TextFormField(
                      controller: creationdatecontroller,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'creation date';
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'creation date ...',
                        labelText: 'creation date*',
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            MaterialButton(
                                onPressed: () async {
                                  final XFile image = await _picker
                                      .pickImage(source: ImageSource.gallery)
                                      .then((value) {
                                    orderController.onselectImage(value.name);
                                    //Todo:Isloading to know if url received
                                    storage
                                        .uploadImage(value.name, value.path)
                                        .then((value) {
                                      urlImage = value;
                                      orderController.onsetstatusimage(value);
                                      print(urlImage);
                                    });
                                  });
                                },
                                child: Text("Select Image",
                                    style: TextStyle(color: Colors.blue))),
                            Text(
                              orderController.imageselected != ""
                                  ? urlImage != ""
                                      ? orderController.imageselected
                                      : "Wait ...."
                                  : "No File Selected",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    // Display passed data from first screen

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new RaisedButton(
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                    'Are You Sure You Want To Delete: $_email'),
                                content: const Text(
                                  'Sample alert',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      orderController.deleterecord(_key);
                                      Navigator.pushReplacement(
                                          _context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MainPage()));
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ).then((returnVal) {
                              // if (returnVal != null) {
                              //   if (returnVal == "OK") {
                              //     Navigator.pop(_context);
                              //   }
                              // }
                            });
                          },
                          child: Row(children: <Widget>[
                            Icon(Icons.delete),
                            SizedBox(width: 5),
                            Text("Delete")
                          ]),
                        ),
                        new RaisedButton(
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            print("url image" + urlImage);
                            print("old image" + _image);
                            orderController.edit(new Book(
                                emailcontroller.text,
                                productcontroller.text,
                                passwordcontroller.text,
                                orderController.statusvalue,
                                urlImage != "" ? urlImage : _image,
                                _key,
                                creationdatecontroller.text));
                            Navigator.pop(_context);
                          },
                          child: Row(children: <Widget>[
                            Icon(Icons.save),
                            SizedBox(width: 5),
                            Text("Save"),
                          ]),
                        ),
                        new RaisedButton(
                            child: Row(children: <Widget>[
                              Icon(Icons.arrow_back),
                              SizedBox(width: 5),
                              Text("Back"),
                            ]),
                            onPressed: () {
                              // Navigate back to first screen when tapped!
                              Navigator.pop(context);
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
