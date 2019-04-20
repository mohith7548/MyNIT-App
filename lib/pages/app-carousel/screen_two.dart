import 'package:flutter/material.dart';

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          'Screen Two',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
