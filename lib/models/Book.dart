import 'package:flutter/material.dart';

class Book {
  String email;
  String product;
  String password;
  String status;
  String image;
  String key;
  String creationdate;
  Color statuscolor;

  Book(this.email, this.product, this.password, this.status, this.image,
      this.key, this.creationdate);

  Book.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }

    email = map["email"];
    product = map["product"];
    password = map["password"];
    status = map["status"];
    image = map["image"];
    key = map["key"].toString();
    creationdate = map["creationdate"];
  }
}
