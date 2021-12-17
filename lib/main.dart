//import 'dart:js_util';
// @dart=2.9
import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_new/modules/QuotaBookList.dart';
import 'package:test_new/modules/addbook.dart';
import 'package:test_new/modules/detailsbook.dart';
import 'modules/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:test_new/models/Book.dart";

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  // by3ml kl chi async w bi5alles b3den by3ml run
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(home: LoginPage() // LoginPage()
      ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final key = new GlobalKey<ScaffoldState>();

  String user_signIn = "";

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // no back after logout
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  ListenToNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      // if (notification != null && android != null) {
      //   showDialog(
      //       context: context,
      //       builder: (_) {
      //         return AlertDialog(
      //           title: Text(notification.title.toString()),
      //           content: SingleChildScrollView(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [Text(notification.body.toString())],
      //             ),
      //           ),
      //         );
      //       });
      // }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ListenToNotification();
    Firebase.initializeApp().whenComplete(() {
      print("Fire Base completed");
      setState(() {
        ToDo: // share user between pages
        User user = FirebaseAuth.instance.currentUser;
        user_signIn = (user != null && user.email != null) ? user.email : "";
      });
    });

    //_onLoading();
  }

  @override
  Widget build(BuildContext context) {
    String buttonStatusname = user_signIn != "" ? "Logout" : "Login";

    return Scaffold(
      key: key,
      drawer: Drawer(),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text(
          user_signIn,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontSize: 11,
          ),
        ),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.person, color: Colors.green),
              label: Text(buttonStatusname,
                  style: TextStyle(
                    color: Colors.green,
                  ))),
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search))
        ],
      ),

      body: QuotaBookList(),
      // Center(
      //   child: SpinKitFadingCube(
      //     color: Colors.blue[800],
      //     size: 50.0,
      //     duration: Duration(seconds: 3),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          if (user_signIn != "") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBook()),
            );
          } else {
            key.currentState.showSnackBar(new SnackBar( 
              backgroundColor: Colors.redAccent,
              content: new Text("You Are Not Authorized"),
            ));
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.book),
      //       label: 'Books',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.redAccent,
      //   // onTap: (index) => setState(() {
      //   //   if (index != 2) {
      //   //     _selectedIndex = index;
      //   //   }
      //   // }),
      // ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  // final Books = [
  //   "Firebase For Android",
  //   "Flutter",
  //   "Sql Server",
  //   "Java 1",
  //   "Math",
  //   "Routers",
  //   "Wan",
  //   "lan",
  //   "Reseaux",
  //   "Java script",
  //   "database"
  // ];

  final RecentBooks = <Book>[];

  final _database = FirebaseDatabase.instance.reference();

  final Books = <Book>[];

  DataSearch() {
    _database.child("books").onValue.listen((event) {
      Map<dynamic, dynamic> values = event.snapshot.value;
      //print(values.toString());
      values.forEach((k, v) {
        Books.add(new Book(v['email'], v['product'], v['password'], v['status'],
            v["image"], k, DateTime.now().toString()));
        //print("Books " + Books.length.toString());
        // print("Recent Books " + RecentBooks.length.toString());
      });
    });

    // _database.child("books").limitToLast(5).onValue.listen((event) {
    //   Map<dynamic, dynamic> values = event.snapshot.value;
    //   //print(values.toString());
    //   values.forEach((k, v) {
    //     RecentBooks.add(new Book(
    //         v['title'], v['author'], v['isbn'], v['category'], v["image"]));
    //   });
    //   print("Recent Books " + RecentBooks.length.toString());
    // });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for app bar
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leanding icon on the left of the app bar
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something

    final suggestionbook = query.isEmpty
        ? Books.toList()
        : Books.where(
                (p) => p.email.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new DetailsBook(
                    book: new Book(
                        suggestionbook[index].email,
                        suggestionbook[index].product,
                        suggestionbook[index].password,
                        suggestionbook[index].status,
                        suggestionbook[index].image,
                        suggestionbook[index].key,
                        DateTime.now().toString())),
              ));
        },
        leading: CircleAvatar(
            backgroundImage: suggestionbook[index].image.toString() != ""
                ? NetworkImage(suggestionbook[index].image)
                : AssetImage("assets/alm.png")),
        title: RichText(
            text: TextSpan(
                text: suggestionbook[index].email.substring(0, query.length),
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                children: [
              TextSpan(
                  text: suggestionbook[index].email.substring(query.length),
                  style: TextStyle(
                    color: Colors.black,
                  ))
            ])),
      ),
      itemCount: suggestionbook.length,
    );
  }
}
