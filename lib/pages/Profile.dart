import 'package:brownwater_pilot/pages/Home.dart';
import 'package:brownwater_pilot/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _updateProfile() async {
    if (_passwordController.text.trim() !=
        _passwordConfirmController.text.trim()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Password mismatch'),
      ));
      return;
    }

    FirebaseUser _user = await _firebaseAuth.currentUser();
    try {
      if (_passwordController.text.trim() ==
              _passwordConfirmController.text.trim() &&
          _passwordController.text.length > 5) {
        await _user.updatePassword(_passwordController.text.trim());
      }
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = _nameController.text.trim();
      await _user.updateProfile(userUpdateInfo);
      await _user.reload();
      _user = await _firebaseAuth.currentUser();
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
        return HomePage();
      }));
    } catch (ex) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text((ex as PlatformException).message),
        ),
      );
    }
  }

  _deleteUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Profile?'),
            content: const Text('This will permanently remove your account.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('ACCEPT'),
                onPressed: () {
                  _user.delete();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext ctx) {
                    return LoginPage();
                  }));
                },
              )
            ],
          );
        });
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
                  Icons.account_circle,
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
                            hintText: "Edit your username",
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
                            hintText: "Change your password",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.5),
                            )),
                      ),
                    ),
                  ],
                ),
              ), // RE-ENTER PASSWORD
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
              // SUBMIT CHANGES BUTTON
              Container(
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
                        onPressed: () {
                          _updateProfile();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'SUBMIT',
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
              // DELETE ACCOUNT BUTTON
              Container(
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
                        color: Colors.red,
                        disabledColor: Colors.white.withOpacity(.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          _deleteUser();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'DELETE ACCOUNT',
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
              ),
              // CANCEL BUTTON
              Container(
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
                            return HomePage();
                          }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Discard changes and return to homescreen',
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
