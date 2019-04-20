import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/methods.dart' as methods;
import 'package:url_launcher/url_launcher.dart';

class SingleAnnouncement extends StatelessWidget {
  final DocumentSnapshot snapshot;

  SingleAnnouncement({Key key, @required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration duration = DateTime.now().difference(snapshot['timeStamp']);
    String timeAgo = '${methods.getDurationString(duration)} ago';
    bool _isNew = false;
    if (duration.inDays <= 2) {
      _isNew = true;
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new InkWell(
          onTap: () {
            return _launchURL(snapshot['url'], context);
          },
          child: new Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Text(snapshot['title'], style: darkText),
                    ),
                    (_isNew)
                        ? Expanded(
                            flex: 1,
                            child: Image(
                                image: AssetImage('assets/images/new.png')),
                          )
                        : Container(),
                  ],
                ),
                const SizedBox(height: 6.0),
                (snapshot['description'] != '')
                    ? Text(snapshot['description'], style: primaryText)
                    : Container(),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(timeAgo, style: lightText),
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      methods.showSnackbar(
        scaffoldState: Scaffold.of(context),
        msg: 'Could not launch $url',
      );
    }
  }
}
