import 'package:flutter/material.dart';

class FacultyLoginPage extends StatefulWidget {
  @override
  _FacultyLoginPageState createState() => _FacultyLoginPageState();
}

class _FacultyLoginPageState extends State<FacultyLoginPage> {
  // TODO:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Image(
              image: AssetImage('assets/images/teacher.jpg'),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black54,
            ),
          ),
          Container(
              child: Center(
            child: Text('Faculty Login Page'),
          )),
        ],
      ),
    );
  }
}
