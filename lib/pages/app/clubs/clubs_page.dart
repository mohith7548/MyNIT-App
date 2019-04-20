import 'package:flutter/material.dart';
import 'package:nit_andhra/StylesAndColors.dart';

class ClubsPage extends StatefulWidget {
  ClubsPage({Key key, this.openDrawerFunction}) : super(key: key);

  final VoidCallback openDrawerFunction;

  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appMenuButton(widget.openDrawerFunction),
        centerTitle: true,
        title: Text('Clubs', style: titleStyle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.widgets,
              size: 80.0,
              color: appColors.clubs,
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
