//import 'dart:js_util';
// @dart=2.9
import 'dart:collection';
//import 'dart:html';
import 'package:get/get.dart';
import 'package:test_new/controller/orderscontroller.dart';
import "package:test_new/main.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:test_new/models/Book.dart";

/// for format
import 'package:intl/intl.dart';
import 'package:test_new/modules/detailsbook.dart';

class QuotaBookList extends StatefulWidget {
  @override
  _QuotaBookListState createState() => _QuotaBookListState();
}

class _QuotaBookListState extends State<QuotaBookList> {
  SharedPreferences sp;

  bool _loading = false;
  int _selectedIndex = 0;
  final key = new GlobalKey<ScaffoldState>();

  String user_signIn = "";

  final _database = FirebaseDatabase.instance.reference();

  int received, pending, free;

  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("Fire Base completed");
      setState(() {
        ToDo: // share user between pages
        User user = FirebaseAuth.instance.currentUser;
        user_signIn = (user != null && user.email != null) ? user.email : "";

        // if (user != null) {
        //   user_signIn = user.email;
        // } else {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => LoginPage()),
        //   );
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<orderController>(
      init: orderController(),
      builder: (editordercontrooler) => Scaffold(
        key: key,
        // drawer: Drawer(),
        backgroundColor: Colors.grey[200],

        body: Column(
          children: [
            Obx(
              () => Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${editordercontrooler.received.string}',
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 7,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${editordercontrooler.pending.string}',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 7,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${editordercontrooler.free}',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GetBuilder<orderController>(
                  init: orderController(),
                  builder: (orderController) => Column(
                    children: _OrderItem(orderController.books),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _OrderItem(List<Book> books) {
    List<Container> conts = <Container>[];
    Container cont;
    for (int i = 0; i < books.length; i++) {
      cont = Container(
        padding: EdgeInsets.all(8),
        child: GetBuilder<orderController>(
          init: orderController(),
          builder: (orderController) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new DetailsBook(book: books[i])));
            },
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: books[i].image != ""
                            ? NetworkImage(books[i].image.toString())
                            : AssetImage("assets/alm.png"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(books[i].email),
                          SizedBox(
                            height: 10,
                          ),
                          Text(books[i].password),
                          SizedBox(
                            height: 10,
                          ),
                          Text(books[i].product,
                              style: TextStyle(color: Colors.red)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(books[i].creationdate),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(books[i].status ?? "free",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: books[i].statuscolor)),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 4,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      );
      conts.add(cont);
    }
    return conts;
  }
}
