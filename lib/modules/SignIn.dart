import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:test_new/main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:test_new/modules/QuotaBookList.dart';
import 'package:transparent_image/transparent_image.dart'
    show kTransparentImage;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final key = new GlobalKey<ScaffoldState>();
  String _email = "", _password = "";

  bool _authSuccess = false;
  LocalAuthentication _localAuth;
  BuildContext _context;

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _context = context;
    this._localAuth = LocalAuthentication();

    // WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().whenComplete(() {
      print("Fire Base completed");
      setState(() {});
    });
  }

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Text("Orders"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "Login Page",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an email';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    onSaved: (input) => _email = input,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.length < 6) {
                        return 'Longer password please';
                      }
                    },
                    obscureText: this._showPassword,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.security),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color:
                                this._showPassword ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(
                                () => this._showPassword = !this._showPassword);
                          },
                        )),
                    onSaved: (input) => _password = input,
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    onPressed: signIn,
                    child: Text('Sign in'),
                  ),
                  // RaisedButton(
                  //   color: Colors.redAccent,
                  //   textColor: Colors.white,
                  //   onPressed: () async {
                  //     final authSuccess = await this._auth();
                  //     setState(() => this._authSuccess = authSuccess);
                  //   },
                  //   child: Text('Sign in With touch Id'),
                  // ),
                  // if (this._authSuccess)
                  //   FadeInImage(
                  //     placeholder: MemoryImage(kTransparentImage),
                  //     image: const AssetImage(
                  //         'res/images/animated_flutter_lgtm.gif'),
                  //   )
                  // else
                  //   const Placeholder(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    FirebaseAuth mAuth = FirebaseAuth.instance;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim().toString(),
            password: _password.trim().toString());
        _pushPage(context, MainPage());
        _formKey.currentState?.reset();
      } catch (e) {
        //print(e.toString());
        key.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.red,
          content: new Text("Sign In Failed"),
        ));
      }
    }
  }

  // Future<void> SignInByTouchId() async {
  //   bool Authenticated = false;
  //   try {
  //     Authenticated = await this._localAuth.authenticateWithBiometrics(
  //         localizedReason: "Scan Your Finger To authenticate",
  //         useErrorDialogs: true,
  //         stickyAuth: false);
  //   } on PlatformException catch (e) {
  //     key.currentState!.showSnackBar(new SnackBar(
  //       backgroundColor: Colors.red,
  //       content: new Text("Sign In Failed With Touch Id"),
  //     ));
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     if (Authenticated) _pushPage(context, QuoteList());
  //   });
  // }

  // Future<bool> _auth() async {
  //   setState(() => this._authSuccess = false);
  //   if (await this._localAuth.canCheckBiometrics == false) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Your device is NOT capable of checking biometrics.\n'
  //             'This demo will not work on your device!\n'
  //             'You must have android 6.0+ and have fingerprint sensor.'),
  //       ),
  //     );
  //     return false;
  //   }
  //   // **NOTE**: for local auth to work, tha MainActivity needs to extend from
  //   // FlutterFragmentActivity, cf. https://stackoverflow.com/a/56605771.
  //   try {
  //     final authSuccess = await this._localAuth.authenticate(
  //           biometricOnly: true,
  //           localizedReason: 'Auth in to see hidden image',
  //         );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('authSuccess=$authSuccess')),
  //     );
  //     return authSuccess;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //     return false;
  //   }
  // }
}
