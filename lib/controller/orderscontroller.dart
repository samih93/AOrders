import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_new/models/Book.dart';
import 'package:intl/intl.dart';

class orderController extends GetxController {
  List<Book> _books = [];
  List<Book> get books => _books;
  final _database = FirebaseDatabase.instance.reference();
  DateFormat format = DateFormat("dd-MM-yyyy");
  var received = 0.obs;
  var pending = 0.obs;
  var free = 0.obs;

  RxBool is_loding_urlImage = true.obs;

  String _statusvalue = "free";
  String get statusvalue => _statusvalue;

  String _creationdate = "";
  String get creationdate => _creationdate;

  String _imageselected = "";
  String get imageselected => _imageselected;

  String _urlimage = "";
  String get urlimage => _urlimage;
  String _textimagetstatus = "";
  String get textimagetstatus => _textimagetstatus;

  orderController() {
    _books = fetchOrders();
  }

  void onsetstatusimage(String name) {
    _textimagetstatus = name;
    update();
  }

  void onselectImage(String name) {
    _imageselected = name;
    _textimagetstatus = "wait ...";
    update();
  }

  onchagesdtatusvalue(String v) {
    _statusvalue = v;
    update();
  }

  onselectcreationDate(String cdate) {
    _creationdate = cdate;
    update();
  }

  List<Book> fetchOrders() {
    List<Book> b = [];

    _database.once().then((DataSnapshot data) {
      //  print(data.value['books']);
      data.value['books'].forEach((k, v) {
        final nextbook = Book.fromJson(v);
        nextbook.key = k;
        nextbook.statuscolor = nextbook.status.toString() == "free"
            ? Colors.blue
            : nextbook.status.toString() == "pending"
                ? Colors.red
                : nextbook.status.toString() == "received"
                    ? Colors.green
                    : Colors.black;

        b.add(nextbook);
      });

      b.sort((a, b) {
        return format
            .parse(a.creationdate)
            .compareTo((format.parse(b.creationdate)));
      });
      received = RxInt(
          b.where((element) => element.status == "received").toList().length);
      pending = RxInt(
          b.where((element) => element.status == "pending").toList().length);
      free =
          RxInt(b.where((element) => element.status == "free").toList().length);
      update();
    });
    return b;
  }

  void add_book(Book book) async {
    // print(book.creationdate);
    await _database.reference().child("books").push().set({
      "email": book.email,
      "product": book.product,
      "password": book.password,
      "status": book.status,
      "image": "",
      "creationdate": book.creationdate,
    }).toString();
    _books = fetchOrders();
    update();
  }

  void edit(Book book) {
    Map<String, dynamic> UpdatedBook = new HashMap();
    UpdatedBook['email'] = book.email;
    UpdatedBook['product'] = book.product;
    UpdatedBook['password'] = book.password;
    UpdatedBook['status'] = book.status;
    UpdatedBook['image'] = book.image;
    UpdatedBook['creationdate'] = book.creationdate;
    _database.child('books').child(book.key).update(UpdatedBook);
    _books = fetchOrders();
    update();

    // print("updated done");
  }

  deleterecord(String key) async {
    //TODO:
    print("delete record " + key);
    await _database.child('books').child(key).remove();
    _books = fetchOrders();
    update();

    //Navigator.pop(_context);
  }

}
