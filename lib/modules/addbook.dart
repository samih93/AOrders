import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:test_new/controller/orderscontroller.dart';
import "package:test_new/models/Book.dart";
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddBook extends StatelessWidget {
  final _database = FirebaseDatabase.instance.reference();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _context = context;
    var emailcontroller = TextEditingController();
    var productcontroller = TextEditingController();
    var passwordcontroller = TextEditingController();
    var statuscontroller = TextEditingController();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Order"),
        backgroundColor: Colors.redAccent,
      ),
      body: GetBuilder<orderController>(
        init: orderController(),
        builder: (orderController) => Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailcontroller,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'email is required';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'email ...',
                      labelText: 'email*',
                    ),
                  ),
                  TextFormField(
                    controller: productcontroller,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'product is Required';
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
                        return 'password is Required';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'password ...',
                      labelText: 'password*',
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
                  //     icon: Icon(Icons.category),
                  //   ),
                  // ),
                  SizedBox(height: 15),
                  DropdownSearch<String>(
                      mode: Mode.MENU,
                      // showSelectedItem: true,
                      items: ['free', 'pending', 'received'],
                      label: "Status",
                      onChanged: (newValue) {
                        orderController.onchagesdtatusvalue(newValue);
                      },
                      selectedItem: orderController.statusvalue),

                  SizedBox(
                    height: 10,
                  ),
                  DateTimePicker(
                    initialValue: orderController.creationdate,
                    dateMask: "dd-MM-yyyy",
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date',
                    onChanged: (val) {
                      orderController.onselectcreationDate(val);
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) {
                      orderController.onselectcreationDate(val);
                    },
                  ),
                  // Display passed data from first screen

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new RaisedButton(
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            print('samih');
                            final DateFormat formatter =
                                DateFormat('dd-MM-yyyy');
                            final String newcreationdate = formatter.format(
                                DateTime.parse(orderController.creationdate));
                            //print();
                            orderController.add_book(new Book(
                                emailcontroller.text,
                                productcontroller.text,
                                passwordcontroller.text,
                                orderController.statusvalue,
                                "",
                                "",
                                newcreationdate));
                            //ToDo: navigate
                            Navigator.pop(_context);
                          },
                          child: Row(children: <Widget>[
                            Icon(Icons.add),
                            Text('Add'),
                          ])),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
