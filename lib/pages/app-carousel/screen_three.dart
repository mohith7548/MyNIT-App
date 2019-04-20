import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/auth/login_page.dart';

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              'Screen Three',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false),
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Next')),
            ),
          )
        ],
      ),
    );
  }
}
