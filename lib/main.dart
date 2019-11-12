import 'package:brownwater_pilot/pages/Home.dart';
// import 'package:brownwater_pilot/pages/Radar.dart';
// import 'package:brownwater_pilot/pages/Signup.dart';
import 'package:flutter/material.dart';
// import 'package:brownwater_pilot/pages/Wind.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brownwater Pilot',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(),
      // home: SignupPage(),
      // home: Wind(),
    );
  }
} 