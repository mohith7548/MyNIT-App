import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/auth/faculty_login_page.dart';
import 'package:nit_andhra/pages/auth/student_login_page.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:simple_permissions/simple_permissions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut)
      ..addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Image(
                image: AssetImage('assets/images/login_background4.jpeg'),
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black26,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: _animation.value * 125.0,
                ),
                const SizedBox(height: 50.0),
                RaisedButton(
                  onPressed: () {
                    _sendTo(StudentLoginPage());
                  },
                  shape: new StadiumBorder(),
                  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80.0, vertical: 15.0),
                  child: Text(
                    'Student Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                ),
                RaisedButton(
                  onPressed: () {
                    _sendTo(FacultyLoginPage());
                  },
                  shape: new StadiumBorder(),
                  color: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 85.0, vertical: 15.0),
                  child: Text(
                    'Faculty Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _sendTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
