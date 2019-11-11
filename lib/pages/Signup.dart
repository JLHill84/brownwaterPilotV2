import 'package:brownwater_pilot/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _loggingIn = false;
  String _userName;

  _updateProfile() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = _userName;
    await _user.updateProfile(userUpdateInfo);
    await _user.reload();
    _user = await _firebaseAuth.currentUser();
    print(_user);
  }

  _signup() async {
    if (_passwordController.text.trim() !=
        _passwordConfirmController.text.trim()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Password mismatch'),
      ));
      return;
    }

    setState(() {
      _loggingIn = true;
    });

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Creating your account..."),
      ),
    );

    try {
      FirebaseUser _user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim()))
          .user;

      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Account created!"),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
        return LoginPage();
      }));
      setState(() {
        _loggingIn = false;
        _userName = _nameController.text.trim();
      });

    } catch (ex) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text((ex as PlatformException).message),
        ),
      );
      setState(() {
        _loggingIn = false;
      });
    }
    _updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey,
        body: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 72, bottom: 36),
                child: Icon(
                  Icons.explore,
                  size: 60,
                  color: Colors.white,
                ),
              ), // NAME FIELD CONTAINER
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Icon(Icons.person, color: Colors.white)),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withOpacity(.5),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    Expanded(
                      // NAME FIELD
                      child: TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your name",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // EMAIL FIELD
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child:
                            Icon(Icons.alternate_email, color: Colors.white)),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withOpacity(.5),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your email",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              // PASSWORD FIELD
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Icon(Icons.lock_open, color: Colors.white)),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withOpacity(.5),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your password",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Icon(Icons.lock_open, color: Colors.white)),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withOpacity(.5),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordConfirmController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Re-enter your password",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //LOGIN BUTTON
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        splashColor: Colors.white,
                        color: Colors.white,
                        disabledColor: Colors.white.withOpacity(.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: _loggingIn == true
                            ? null
                            : () {
                                _signup();
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'SIGN UP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                //SIGNUP BUTTON
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext ctx) {
                            return LoginPage();
                          }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Already have an account? Login here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}