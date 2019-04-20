import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text(
          'Screen One',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
