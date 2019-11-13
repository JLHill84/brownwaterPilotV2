import 'package:brownwater_pilot/pages/Login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brownwater Pilot',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: LoginPage(),
      // home: SignupPage(),
      // home: Wind(),
    );
  }
}
