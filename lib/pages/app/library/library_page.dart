import 'package:flutter/material.dart';
import 'package:nit_andhra/StylesAndColors.dart';

class LibraryPage extends StatelessWidget {
  LibraryPage({Key key, this.openDrawerFunction}) : super(key: key);
  final VoidCallback openDrawerFunction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appMenuButton(openDrawerFunction),
        centerTitle: true,
        title: Text('Library', style: titleStyle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.sentiment_satisfied,
              size: 80.0,
              color: Colors.teal,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Comming Soon!',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
